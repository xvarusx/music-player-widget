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

    // Preserve the existing inactive-opacity behavior.
    property real cardOpacity: 1.0

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

    function updateCardOpacity(output) {
        try {
            const settings = JSON.parse(output)
            if (settings && Number.isFinite(settings.float))
                cardOpacity = Math.max(0.0, Math.min(1.0, settings.float))
        } catch (error) {
            console.warn("Could not parse Hyprland inactive opacity:", error)
        }
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
        command: ["hyprctl", "getoption", "decoration:inactive_opacity", "-j"]

        stdout: StdioCollector {
            onStreamFinished: root.updateCardOpacity(this.text)
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                console.warn("Could not read Hyprland inactive window opacity; keeping current card opacity")
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
                opacityQuery.exec()
            if (!roundingQuery.running)
                roundingQuery.exec()
        }
    }

    Component.onCompleted: {
        opacityQuery.exec()
        roundingQuery.exec()
    }
}
