import QtQuick

Item {
    id: root

    property var theme: null
    property var media: null
    property var audio: null
    property color accentColor: "transparent"
    property color primaryText: "transparent"
    property color trackColor: "transparent"
    readonly property color pillBg: theme ? theme.borderColor : "transparent"

    // Pills follow the system corner radius instead of a hard-coded value.
    readonly property real pillRadius: theme
        ? Math.min(Math.max(0, Number(theme.cornerRadius)), root.height / 2)
        : 16

    width: parent.width
    height: 32

    Row {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            height: 32
            width: sourceRow.width + 24
            color: root.pillBg
            radius: root.pillRadius

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
            radius: root.pillRadius

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
                anchors.rightMargin: 11
                spacing: 9

                Text {
                    width: 43
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
                    id: volumeTrack
                    width: 103
                    height: 18
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: 7
                        radius: height / 2
                        color: root.trackColor
                        opacity: 0.9
                    }

                    Rectangle {
                        width: parent.width * (root.audio && root.audio.available
                            ? Math.max(0, Math.min(1, root.audio.volume)) : 0)
                        height: 7
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        radius: height / 2
                        color: root.accentColor

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    // A full-height hit target makes click-and-hold dragging reliable.
                    MouseArea {
                        anchors.fill: parent
                        enabled: root.audio && root.audio.available
                        cursorShape: Qt.PointingHandCursor
                        preventStealing: true
                        hoverEnabled: true

                        function setFromMouse(mouseX) {
                            const ratio = Math.max(0, Math.min(1, mouseX / width))
                            root.audio.setVolume(ratio)
                        }

                        onPressed: mouse => setFromMouse(mouse.x)
                        onPositionChanged: mouse => {
                            if (pressed)
                                setFromMouse(mouse.x)
                        }
                        onReleased: mouse => setFromMouse(mouse.x)
                    }
                }
            }
        }
    }
}
