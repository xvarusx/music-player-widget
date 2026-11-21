import QtQuick

Item {
    id: root

    property var theme: null
    property var media: null
    property var audio: null
    property color accentColor: "transparent"
    property color primaryText: "transparent"
    readonly property color pillBg: theme ? theme.borderColor : "transparent"

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
            id: volumePill
            width: 177
            height: 32
            color: root.pillBg
            radius: 16

            MouseArea {
                anchors.fill: parent
                onWheel: wheel => {
                    wheel.accepted = true
                    if (root.audio && wheel.angleDelta.y !== 0)
                        root.audio.adjustVolume(wheel.angleDelta.y > 0 ? 1 : -1)
                }
            }

            Row {
                anchors.fill: parent
                anchors.leftMargin: 11
                anchors.rightMargin: 9
                spacing: 8

                Text {
                    width: 48
                    text: {
                        if (!root.audio || !root.audio.available)
                            return "--%"
                        return root.audio.muted
                            ? "Muted" : Math.round(root.audio.volume * 100) + "%"
                    }
                    color: root.primaryText
                    font.family: "Inter"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width: 55
                    height: 1
                }

                Text {
                    text: "−"
                    color: root.accentColor
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -5
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (root.audio) root.audio.adjustVolume(-1)
                    }
                }

                Text {
                    text: "+"
                    color: root.accentColor
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -5
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (root.audio) root.audio.adjustVolume(1)
                    }
                }
            }
        }
    }
}
