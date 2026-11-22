import Quickshell
import Quickshell.Wayland
import QtQuick
import "components"
import "services"

Scope {
    id: root

    ThemeService {
        id: theme
        surfaceOverride: settings.surface
        opacityOverride: settings.surfaceOpacity
    }

    MprisService {
        id: media
    }

    SystemVolume {
        id: audio
    }

    WidgetSettings {
        id: settings
    }

    property date currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    PanelWindow {
        id: widgetWindow

        screen: settings.selectedScreen

        // Namespace lets Hyprland blur this surface in "glassy" mode.
        WlrLayershell.namespace: "music-card"

        // Keep the card above the wallpaper but below normal application windows.
        WlrLayershell.layer: WlrLayer.Bottom

        anchors {
            top: settings.corner.indexOf("top-") === 0
            bottom: settings.corner.indexOf("bottom-") === 0
            left: settings.corner.endsWith("-left")
            right: settings.corner.endsWith("-right")
        }

        margins {
            top: settings.corner.indexOf("top-") === 0 ? settings.offsetY : 0
            bottom: settings.corner.indexOf("bottom-") === 0 ? settings.offsetY : 0
            left: settings.corner.endsWith("-left") ? settings.offsetX : 0
            right: settings.corner.endsWith("-right") ? settings.offsetX : 0
        }

        implicitWidth: settings.widgetWidth
        implicitHeight: settings.widgetHeight

        color: "transparent"
        exclusiveZone: 0
        focusable: false
        visible: settings.selectedScreen !== null

        MusicCard {
            anchors.fill: parent
            theme: theme
            media: media
            audio: audio
        }
    }
}
