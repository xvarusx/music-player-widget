import QtQuick

Item {
    id: root

    property var theme: null
    property var media: null
    property var audio: null
    property color accentColor: "#7aa2f7"
    property color secondaryAccent: "#ad8ee6"
    readonly property color pillBg: theme ? theme.borderColor : "#2A2E36"
    readonly property color textColor: theme ? theme.primaryText : "#8B97A6"
    readonly property color dimColor: theme ? theme.secondaryText : "#5F6B7A"

    width: parent.width
    height: 32

    Row {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            height: 32
            width: sourceRow.width + 24
            color: root.pillBg
            radius: 16

            Row {
                id: sourceRow
                anchors.centerIn: parent
                spacing: 7

                Text {
                    text: root.media && root.media.playerIdentity
                        ? root.media.playerIdentity : "No player"
                    color: root.accentColor
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Item {
            width: Math.max(0, parent.width - sourceRow.width - 24 - 177 - 24)
            height: 1
        }

        Rectangle {
            width: 177
            height: 32
            color: root.pillBg
            radius: 16

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    if (!root.audio || !root.audio.available)
                        return "--%"
                    return root.audio.muted
                        ? "Muted" : Math.round(root.audio.volume * 100) + "%"
                }
                color: root.accentColor
                font.family: "Inter"
                font.pixelSize: 12
                font.weight: Font.Bold
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                text: root.audio && root.audio.muted ? "🔇" : "🕪"
                color: root.accentColor
                font.pixelSize: 12
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onWheel: wheel => {
                    wheel.accepted = true
                    if (root.audio && root.audio.available && wheel.angleDelta.y !== 0)
                        root.audio.adjustVolume(wheel.angleDelta.y > 0 ? 1 : -1)
                }
            }
        }
    }
}
