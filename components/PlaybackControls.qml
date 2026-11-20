import QtQuick

Item {
    id: root
    property var player: null
    property color accentColor: "#7aa2f7"
    property color primaryText: "#c0caf5"
    property color secondaryText: "#a9b1d6"

    Row {
        anchors.centerIn: parent
        spacing: 22

        Text {
            text: "⏮"
            color: root.secondaryText
            font.pixelSize: 21
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                anchors.margins: -10
                enabled: root.player !== null
                onClicked: root.player.previous()
            }
        }

        Rectangle {
            width: 38
            height: 38
            radius: 19
            color: root.accentColor
            anchors.verticalCenter: parent.verticalCenter
            Text {
                anchors.centerIn: parent
                text: root.player && root.player.isPlaying ? "Ⅱ" : "▶"
                color: root.primaryText
                font.pixelSize: 17
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.player !== null
                onClicked: root.player.togglePlaying()
            }
        }

        Text {
            text: "⏭"
            color: root.secondaryText
            font.pixelSize: 21
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                anchors.margins: -10
                enabled: root.player !== null
                onClicked: root.player.next()
            }
        }
    }
}
