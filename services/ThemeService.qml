import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root
    visible: false
    width: 0
    height: 0

    readonly property string themePath: Quickshell.env("HOME")
        + "/.local/state/omarchy/current/theme/colors.toml"

    // Keep the same fallback palette as widget-launcher's read_palette().
    // The live Omarchy file overrides these values when it is available.
    property var themeColors: ({
        background: "#171717",
        dark_background: "#101010",
        darker_background: "#090909",
        lighter_background: "#262626",
        foreground: "#f5f5f5",
        dark_foreground: "#a3a3a3",
        accent: "#89b4fa",
        selection: "#343434",
        muted: "#737373",
        red: "#f38ba8",
        green: "#a6e3a1",
        blue: "#89b4fa"
    })
    property string themeMode: themeColors["mode"] || "unknown"

    // Match the exact Hyprland option queried by widget-launcher.
    property int cornerRadius: 0

    // Surface style. "auto" follows Omarchy; "opaque", "transparent" or
    // "glassy" force a mode. surfaceOpacity >= 0 forces the alpha.
    property string surfaceOverride: "auto"
    property real opacityOverride: -1

    // What Omarchy/Hyprland currently does to windows (scripts/omarchy-surface.sh).
    property real detectedOpacity: 1.0
    property bool detectedBlur: false

    readonly property string surfaceMode: {
        if (surfaceOverride === "opaque" || surfaceOverride === "transparent"
                || surfaceOverride === "glassy")
            return surfaceOverride
        if (detectedOpacity >= 0.999)
            return "opaque"
        return detectedBlur ? "glassy" : "transparent"
    }

    // Alpha applied to the card surface only.
    readonly property real cardOpacity: {
        if (opacityOverride >= 0)
            return Math.min(1.0, opacityOverride)
        if (surfaceMode === "opaque")
            return 1.0
        if (surfaceMode === "glassy")
            return detectedOpacity < 0.999 ? Math.min(detectedOpacity, 0.8) : 0.6
        return detectedOpacity < 0.999 ? detectedOpacity : 0.85
    }

    function updateCornerRadius(output) {
        try {
            const settings = JSON.parse(output)
            const rawValue = settings.int !== undefined
                ? settings.int
                : settings.float
            const value = Number(rawValue)

            if (Number.isFinite(value))
                cornerRadius = Math.max(0, Math.min(64, Math.round(value)))
        } catch (error) {
            console.warn("Could not parse Hyprland decoration rounding:", error)
        }
    }

    function updateSurface(output) {
        const parts = output.trim().split(/\s+/)
        if (parts.length < 2)
            return
        const o = Number(parts[0])
        if (Number.isFinite(o))
            detectedOpacity = Math.max(0.0, Math.min(1.0, o))
        const b = Number(parts[1])
        detectedBlur = Number.isFinite(b) && b > 0
    }

    SystemPalette {
        id: fallbackPalette
    }

    // These roles intentionally follow widget-launcher's Omarchy palette:
    // background for the surface, selection for subtle surfaces/borders,
    // muted for secondary details, and accent for interactive emphasis.
    readonly property color cardColor:
        themeColors["background"] || fallbackPalette.window
    readonly property color accentColor:
        themeColors["accent"] || themeColors["blue"] || fallbackPalette.highlight
    readonly property color primaryText:
        themeColors["foreground"] || fallbackPalette.windowText
    readonly property color secondaryText:
        themeColors["dark_foreground"] || fallbackPalette.mid
    readonly property color borderColor:
        themeColors["selection"] || fallbackPalette.mid
    readonly property color mutedColor:
        themeColors["muted"] || fallbackPalette.mid
    readonly property color secondaryAccent:
        themeColors["blue"] || themeColors["accent"] || fallbackPalette.highlight
    readonly property color trackColor:
        themeColors["dark_background"] || fallbackPalette.base

    function parseTheme() {
        const content = themeFile.text()
        if (!content || content.length === 0) {
            console.warn("Omarchy theme palette is empty:", themePath)
            return
        }

        // Start with the launcher's defaults so missing optional keys never
        // leave the widget with unrelated Qt system colors.
        const parsed = {
            background: "#171717",
            dark_background: "#101010",
            darker_background: "#090909",
            lighter_background: "#262626",
            foreground: "#f5f5f5",
            dark_foreground: "#a3a3a3",
            accent: "#89b4fa",
            selection: "#343434",
            muted: "#737373",
            red: "#f38ba8",
            green: "#a6e3a1",
            blue: "#89b4fa"
        }

        const lines = content.split(/\r?\n/)
        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim()
            if (!line || line.startsWith("#"))
                continue

            const separator = line.indexOf("=")
            if (separator < 1)
                continue

            const key = line.slice(0, separator).trim()
            let value = line.slice(separator + 1).trim()
            value = value.replace(/\s+#.*$/, "")
            value = value.replace(/^["']|["']$/g, "")

            // Match the flat color keys consumed by widget-launcher.
            if (Object.prototype.hasOwnProperty.call(parsed, key)
                    && /^#[0-9a-fA-F]{6,8}$/.test(value)) {
                parsed[key] = value
            }
        }

        themeColors = parsed
        console.log("Loaded Omarchy palette:", themePath)
    }

    FileView {
        id: themeFile
        path: root.themePath
        watchChanges: true
        preload: true
        onLoaded: root.parseTheme()
        onFileChanged: reload()
        onLoadFailed: error => console.warn("Could not load Omarchy colors.toml:", error)
    }

    Process {
        id: opacityQuery
        command: ["sh", Quickshell.shellDir + "/scripts/omarchy-surface.sh"]

        stdout: StdioCollector {
            onStreamFinished: root.updateSurface(this.text)
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                console.warn("Could not read Omarchy window opacity; keeping current surface")
        }
    }

    Process {
        id: roundingQuery
        command: ["hyprctl", "-j", "getoption", "decoration:rounding"]

        stdout: StdioCollector {
            onStreamFinished: root.updateCornerRadius(this.text)
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                console.warn("Could not read Hyprland decoration rounding; keeping current corner radius")
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            themeFile.reload()
            if (!opacityQuery.running)
                opacityQuery.exec(["sh", Quickshell.shellDir + "/scripts/omarchy-surface.sh"])
            if (!roundingQuery.running)
                roundingQuery.exec(["hyprctl", "-j", "getoption", "decoration:rounding"])
        }
    }

    Component.onCompleted: {
        opacityQuery.exec(["sh", Quickshell.shellDir + "/scripts/omarchy-surface.sh"])
        roundingQuery.exec(["hyprctl", "-j", "getoption", "decoration:rounding"])
    }
}
