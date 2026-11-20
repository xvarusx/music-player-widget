import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root
    visible: false
    width: 0
    height: 0

    readonly property string settingsPath: Quickshell.shellDir + "/settings.json"

    // Resolve the configured monitor by name on every screen-list change.
    // Do not retain a ShellScreen object after its monitor is disconnected.
    readonly property var selectedScreen: {
        const screens = Quickshell.screens
        if (!screens || screens.length === 0)
            return null

        for (let i = 0; i < screens.length; i++) {
            if (settingsData.screenName !== ""
                    && screens[i].name === settingsData.screenName)
                return screens[i]
        }

        return screens[0]
    }

    FileView {
        id: settingsFile
        path: root.settingsPath
        watchChanges: true
        preload: true

        JsonAdapter {
            id: settingsData

            property string screenName: ""
            property string corner: "top-right"
            property int offsetX: 30
            property int offsetY: 75
            property int width: 360
            property int height: 350
        }

        onAdapterUpdated: writeAdapter()

        onLoaded: {
            console.log("Music widget settings loaded:", root.settingsPath)
            for (let i = 0; i < Quickshell.screens.length; i++)
                console.log("Available monitor:", Quickshell.screens[i].name)
        }

        onLoadFailed: error => {
            console.warn("Music widget settings could not be loaded; writing defaults:", error)
            writeAdapter()
        }

        onFileChanged: reload()
        onSaveFailed: error => console.warn("Could not save music widget settings:", error)
    }

    readonly property string screenName: settingsData.screenName
    readonly property string corner: settingsData.corner
    readonly property int offsetX: settingsData.offsetX
    readonly property int offsetY: settingsData.offsetY
    readonly property int widgetWidth: settingsData.width
    readonly property int widgetHeight: settingsData.height
}
