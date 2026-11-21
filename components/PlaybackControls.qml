import QtQuick

Item {
    id: root

    property var media: null
    property color accentColor: "transparent"
    property color primaryText: "transparent"
    property color secondaryText: "transparent"

    readonly property bool isPlaying: media ? media.isPlaying : false

    Row {
        anchors.centerIn: parent
        spacing: 48

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
                    else if (root.media)
                        root.media.seekBackward()
                }
            }
        }

        Rectangle {
            width: 56
            height: 56
            radius: 28
            color: root.accentColor
            anchors.verticalCenter: parent.verticalCenter

            Row {
                anchors.centerIn: parent
                spacing: 5
                visible: root.isPlaying

                Rectangle {
                    width: 4.5
                    height: 18
                    radius: 1
                    color: root.primaryText
                }
                Rectangle {
                    width: 4.5
                    height: 18
                    radius: 1
                    color: root.primaryText
                }
            }

            Text {
                text: "▶"
                color: root.primaryText
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
                    else if (root.media)
                        root.media.seekForward()
                }
            }
        }
    }
}
