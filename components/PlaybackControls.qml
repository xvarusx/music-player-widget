import QtQuick

Item {
    id: root

    property var media: null
    property color accentColor: "#7aa2f7"
    property color primaryText: "#c0caf5"
    property color secondaryText: "#a9b1d6"

    Row {
        anchors.centerIn: parent
        spacing: 48

        // Previous
        Item {
            width: 32
            height: 32
            
            Text {
                text: "⏮"
                color: "#8B97A6"
                font.pixelSize: 22
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.media.seekBackward()
            }
        }

        // Play / pause.
        Rectangle {
            width: 56
            height: 56
            radius: 28
            color: root.accentColor
            
            Row {
                anchors.centerIn: parent
                spacing: 5
                
                Rectangle {
                    width: 4.5
                    height: 18
                    radius: 1
                    color: "#14191F"
                }
                Rectangle {
                    width: 4.5
                    height: 18
                    radius: 1
                    color: "#14191F"
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.media.togglePlayback()
            }
        }

        // Next
        Item {
            width: 32
            height: 32
            
            Text {
                text: "⏭"
                color: "#8B97A6"
                font.pixelSize: 22
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.media.seekForward()
            }
        }
    }
}
