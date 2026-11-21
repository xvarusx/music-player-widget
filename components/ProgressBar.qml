import QtQuick

Column {
    id: root

    // Quickshell MprisPlayer.position and length are already in seconds.
    property real position: 0
    property real duration: 0
    property var media: null
    property color accentColor: "transparent"
    property color trackColor: "transparent"
    property color secondaryText: "transparent"

    readonly property real progress: duration > 0
        ? Math.max(0, Math.min(1, position / duration)) : 0
    readonly property bool seekEnabled:
        media !== null && media.canSeek && duration > 0

    spacing: 6

    Rectangle {
        id: track
        width: root.width
        height: 4
        radius: 2
        color: root.trackColor
        clip: true

        Rectangle {
            width: parent.width * root.progress
            height: parent.height
            radius: 2
            color: root.accentColor
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.seekEnabled
            acceptedButtons: Qt.LeftButton
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: mouse => {
                const ratio = Math.max(0, Math.min(1, mouse.x / width))
                root.media.seekTo(ratio * root.duration)
            }
        }
    }

    Item {
        width: root.width
        height: 16

        Text {
            anchors.left: parent.left
            text: root.formatTime(root.position)
            color: root.secondaryText
            font.family: "Roboto Mono"
            font.pixelSize: 12
        }

        Text {
            anchors.right: parent.right
            text: root.duration > 0 ? root.formatTime(root.duration) : "--:--"
            color: root.secondaryText
            font.family: "Roboto Mono"
            font.pixelSize: 12
        }
    }

    function formatTime(seconds) {
        const value = Math.max(0, Math.floor(seconds))
        const minutes = Math.floor(value / 60)
        const remaining = value % 60
        return minutes + ":" + (remaining < 10 ? "0" : "") + remaining
    }
}
