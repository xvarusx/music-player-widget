import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root

    property var theme: null
    property var media: null
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

                Text {
                    text: root.media.playerIdentity ? root.media.playerIdentity : "Spotify"
                    color: root.accentColor
                    font.family: "Inter"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }

            }
        }

        Item {
            width: parent.width - sourceRow.width - 24 - 140 - 32 - 24
            height: 1
        }

        // Volume Pill
        Rectangle {
            width: 177
            height: 32
            color: root.pillBg
            radius: 16

            Row {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: parent.width - 64 

                Text {
                    text: media ? Math.round(media.volume * 100) + "%" : "100%"
                    color: root.accentColor
                    font.family: "Inter"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                  text: "🕪"
                  color: root.accentColor
                  font.pixelSize: 12
                  anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onWheel: wheel => {
                    if (root.media) {
                        let vol = root.media.volume
                        if (wheel.angleDelta.y > 0)
                            vol = Math.min(1.0, vol + 0.05)
                        else
                            vol = Math.max(0.0, vol - 0.05)
                        root.media.setVolume(vol)
                    }
                }
            }
        }

        // App Button
    }
}
