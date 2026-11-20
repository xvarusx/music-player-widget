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

    spacing: 7

    Rectangle {
        id: track
        width: root.width
        height: 7
        radius: 5
        color: root.trackColor
        clip: true

        Rectangle {
            width: parent.width * root.progress
            height: parent.height
            radius: 5
            color: root.accentColor
            Behavior on width {
                NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
            }
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

    Row {
        width: root.width

        Text {
            text: formatTime(root.position)
            color: root.secondaryText
            font.pixelSize: 10
        }

        Item {
            width: Math.max(0, root.width - 90)
            height: 1
        }

        Text {
            text: formatTime(root.duration)
            color: root.secondaryText
            font.pixelSize: 10
        }
    }

    function formatTime(seconds) {
        const value = Math.max(0, Math.floor(seconds))
        const minutes = Math.floor(value / 60)
        const remaining = value % 60
        return minutes + ":" + (remaining < 10 ? "0" : "") + remaining
    }
}
