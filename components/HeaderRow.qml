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

            // Scroll anywhere over the volume pill to adjust system output volume.
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
                    height: 7
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: root.trackColor
                        opacity: 0.9
                    }

                    Rectangle {
                        width: parent.width * (root.audio && root.audio.available
                            ? Math.max(0, Math.min(1, root.audio.volume)) : 0)
                        height: parent.height
                        radius: height / 2
                        color: root.accentColor

                        Behavior on width {
                            NumberAnimation {
                                duration: 140
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    // Click or drag along the bar to set the volume directly.
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -7
                        enabled: root.audio && root.audio.available
                        cursorShape: Qt.PointingHandCursor

                        function setFromMouse(mouseX) {
                            const x = Math.max(0, Math.min(width, mouseX))
                            root.audio.setVolume(x / width)
                        }

                        onPressed: mouse => setFromMouse(mouse.x)
                        onPositionChanged: mouse => {
                            if (pressed)
                                setFromMouse(mouse.x)
                        }
                    }
                }
            }
        }
    }
}
