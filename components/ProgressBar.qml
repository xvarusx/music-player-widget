import QtQuick

Column {
    id: root

    property real position: 0
    property real duration: 0
    property var media: null
    property color accentColor: "#7aa2f7"
    property color trackColor: "#414868"
    property color secondaryText: "#a9b1d6"

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
        color: "#2F343E"
        clip: true

        Rectangle {
            width: parent.width * root.progress
            height: parent.height
            radius: 2
            color: "#6E879C"
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
            text: formatTime(root.position / 1000)
            color: "#5F6B7A"
            font.family: "Roboto Mono"
            font.pixelSize: 12
        }

        Text {
            anchors.right: parent.right
            text: formatTime(root.duration / 1000)
            color: "#5F6B7A"
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
