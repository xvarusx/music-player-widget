import Quickshell
import QtQuick
import "components"
import "services"

PanelWindow {
    id: root

    anchors {
        top: true
        right: true
    }

    margins {
        top: 75
        right: 30
    }

    implicitWidth: 360
    implicitHeight: 350

    color: "transparent"
    exclusiveZone: 0
    focusable: false

    ThemeService {
        id: theme
    }

    MprisService {
        id: media
    }

    property date currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    MusicCard {
        anchors.fill: parent
        theme: theme
        media: media
        currentTime: root.currentTime
    }
}
