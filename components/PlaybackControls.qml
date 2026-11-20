import QtQuick

Item {
    id: root

    property var media: null
    property color accentColor: "#7aa2f7"
    property color primaryText: "#c0caf5"
    property color secondaryText: "#a9b1d6"

    Row {
        anchors.centerIn: parent
        spacing: 24

        // Seek backward by 10 seconds.
        Rectangle {
            width: 38
            height: 38
            radius: 19
            color: "transparent"
            opacity: root.media && root.media.canSeek ? 1 : 0.35
            anchors.verticalCenter: parent.verticalCenter

            Column {
                anchors.centerIn: parent
                spacing: -2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "↶"
                    color: root.secondaryText
                    font.pixelSize: 19
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "10"
                    color: root.secondaryText
                    font.pixelSize: 9
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                enabled: root.media !== null && root.media.canSeek
                onClicked: root.media.seekBackward()
            }
        }

        // Play / pause.
        Rectangle {
            width: 42
            height: 42
            radius: 21
            color: root.accentColor
            opacity: root.media && root.media.canTogglePlayback ? 1 : 0.45
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: root.media && root.media.isPlaying ? "Ⅱ" : "▶"
                color: root.primaryText
                font.pixelSize: 18
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                enabled: root.media !== null && root.media.canTogglePlayback
                onClicked: root.media.togglePlayback()
            }
        }

        // Seek forward by 10 seconds.
        Rectangle {
            width: 38
            height: 38
            radius: 19
            color: "transparent"
            opacity: root.media && root.media.canSeek ? 1 : 0.35
            anchors.verticalCenter: parent.verticalCenter

            Column {
                anchors.centerIn: parent
                spacing: -2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "↷"
                    color: root.secondaryText
                    font.pixelSize: 19
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "10"
                    color: root.secondaryText
                    font.pixelSize: 9
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                enabled: root.media !== null && root.media.canSeek
                onClicked: root.media.seekForward()
            }
        }
    }
}
