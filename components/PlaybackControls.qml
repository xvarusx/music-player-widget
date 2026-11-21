import QtQuick

Item {
    id: root

    property var media: null
    property color accentColor: "#7aa2f7"
    property color primaryText: "#c0caf5"
    property color secondaryText: "#a9b1d6"

    readonly property bool isPlaying: media ? media.isPlaying : false

    Row {
        anchors.centerIn: parent
        spacing: 48

        // Previous
        Item {
            width: 32
            height: 32
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                text: "◀◀"
                color: root.accentColor
                font.pixelSize: 22
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.media && root.media.canGoPrevious)
                        root.media.player.previous()
                    else
                        root.media.seekBackward()
                }
            }
        }

        // Play / pause.
        Rectangle {
            width: 56
            height: 56
            radius: 28
            color: root.accentColor
            anchors.verticalCenter: parent.verticalCenter
            
            // Pause Icon (two bars)
            Row {
                anchors.centerIn: parent
                spacing: 5
                visible: root.isPlaying
                
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

            // Play Icon (triangle)
            Text {
                text: "▶"
                color: "#14191F"
                font.pixelSize: 20
                anchors.centerIn: parent
                visible: !root.isPlaying
                leftPadding: 2
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.media)
                        root.media.togglePlayback()
                }
            }
        }

        // Next
        Item {
            width: 32
            height: 32
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                text: "▶▶"
                color: root.accentColor
                font.pixelSize: 22
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.media && root.media.canGoNext)
                        root.media.player.next()
                    else
                        root.media.seekForward()
                }
            }
        }
    }
}
