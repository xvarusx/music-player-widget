import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root
    visible: false
    width: 0
    height: 0

    property string themePath: Quickshell.env("HOME")
        + "/.local/state/omarchy/current/theme/colors.toml"

    property color cardColor: themeColor("lighter_background", "#24283b")
    property color accentColor: themeColor("accent", "#7aa2f7")
    property color primaryText: themeColor("bright_foreground", "#c0caf5")
    property color secondaryText: themeColor("foreground", "#a9b1d6")
    property color borderColor: themeColor("muted", "#414868")
    property color secondaryAccent: themeColor("magenta", "#ad8ee6")
    property string themeMode: themeColor("mode", "dark")

    function themeColor(name, fallback) {
        const content = themeFile.text()
        const expression = new RegExp(
            "^\\s*" + name + "\\s*=\\s*[\\\"']([^\\\"']+)[\\\"']",
            "m"
        )
        const match = content.match(expression)
        return match ? match[1] : fallback
    }

    FileView {
        id: themeFile
        path: root.themePath
        watchChanges: true
        preload: true
        onFileChanged: reload()
        onLoaded: console.log("Omarchy theme loaded successfully")
        onLoadFailed: error => console.warn("Theme loading failed:", error)
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: themeFile.reload()
    }
}
