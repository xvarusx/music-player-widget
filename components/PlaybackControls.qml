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

        Rectangle {
            width: 38
            height: 38
            radius: 19
            color: "transparent"
            opacity: root.media && root.media.canGoPrevious ? 1 : 0.35
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: "⏮"
                color: root.secondaryText
                font.pixelSize: 21
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                enabled: root.media !== null && root.media.canGoPrevious
                onClicked: root.media.previous()
            }
        }

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

        Rectangle {
            width: 38
            height: 38
            radius: 19
            color: "transparent"
            opacity: root.media && root.media.canGoNext ? 1 : 0.35
            anchors.verticalCenter: parent.verticalCenter

            Text {
                anchors.centerIn: parent
                text: "⏭"
                color: root.secondaryText
                font.pixelSize: 21
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                enabled: root.media !== null && root.media.canGoNext
                onClicked: root.media.next()
            }
        }
    }
}
