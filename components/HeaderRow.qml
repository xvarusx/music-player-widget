import QtQuick

Item {
    id: root
    property var theme: null
    property var media: null

    readonly property color pillBg: theme ? theme.borderColor : "#2A2E36"
    readonly property color textColor: theme ? theme.primaryText : "#8B97A6"
    readonly property color dimColor: theme ? theme.secondaryText : "#5F6B7A"

    width: parent.width
    height: 32

    Row {
        anchors.fill: parent

        // Source Selector Pill
        Rectangle {
            height: 32
            width: sourceRow.width + 24
            color: root.pillBg
            radius: 16

            Row {
                id: sourceRow
                anchors.centerIn: parent
                spacing: 7

                Rectangle {
                    width: 6
                    height: 6
                    radius: 3
                    color: root.textColor
                }

                Text {
                    text: root.media && root.media.identity ? root.media.identity : "Spotify"
                    color: root.textColor
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }

                Text {
                    text: "↕"
                    color: root.dimColor
                    font.pixelSize: 12
                }
            }
        }

        Item {
            width: 20
            height: 1
        }

        // Volume Pill
        Rectangle {
            width: 120
            height: 32
            color: root.pillBg
            radius: 16

            Row {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                Text {
                    text: "🔊"
                    font.pixelSize: 13
                }

                Item { width: 40; height: 1 }

                Text {
                    text: "100%"
                    color: root.textColor
                    font.family: "Inter"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                }
            }
        }

        // App Button
        Rectangle {
            width: 32
            height: 32
            color: root.pillBg
            radius: 16

            Text {
                text: "≡"
                color: root.textColor
                font.pixelSize: 14
                anchors.centerIn: parent
            }
        }
    }
}
