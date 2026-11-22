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

    property var themeColors: ({})
    property string themeMode: themeColors["mode"] || "unknown"

    // Read the same Hyprland decoration setting used by widget-launcher.
    // The initial value preserves the existing appearance until the first
    // successful query returns the active Omarchy/Hyprland value.
    property int cornerRadius: 26

    // Desktop widgets are unfocused surfaces, so follow Hyprland's
    // inactive window opacity setting from Omarchy's Window Opacity control.
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

    readonly property color cardColor:
        themeColors["lighter_background"] || themeColors["background"] || fallbackPalette.window
    readonly property color accentColor:
        themeColors["accent"] || themeColors["blue"] || fallbackPalette.highlight
    readonly property color primaryText:
        themeColors["foreground"] || fallbackPalette.windowText
    readonly property color secondaryText:
        themeColors["dark_foreground"] || themeColors["muted"] || fallbackPalette.mid
    readonly property color borderColor:
        themeColors["muted"] || fallbackPalette.mid
    readonly property color mutedColor:
        themeColors["muted"] || fallbackPalette.mid
    readonly property color secondaryAccent:
        themeColors["magenta"] || themeColors["blue"] || fallbackPalette.highlight
    readonly property color trackColor:
        themeColors["dark_background"] || themeColors["background"] || fallbackPalette.base

    function parseTheme() {
        const content = themeFile.text()
        if (!content || content.length === 0) {
            console.warn("Omarchy theme palette is empty:", themePath)
            return
        }

        const parsed = {}
        const lines = content.split(/\\r?\\n/)
        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim()
            if (!line || line.startsWith("#"))
                continue

            const separator = line.indexOf("=")
            if (separator < 1)
                continue

            const key = line.slice(0, separator).trim()
            let value = line.slice(separator + 1).trim()
            value = value.replace(/^["']|["']$/g, "")
            if (key && value)
                parsed[key] = value
        }

        themeColors = parsed
        console.log("Loaded Omarchy palette:", themePath, "| mode:", themeMode)
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
        interval: 2000
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
