import QtQuick

Item {
    id: root

    property bool playing: false
    property color accentColor: "transparent"
    property color secondaryAccent: "transparent"
    property color mutedColor: "transparent"

    Row {
        anchors.centerIn: parent
        spacing: 4
        height: 28

        Repeater {
            model: 37

            Item {
                width: 4
                height: 28
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    id: bar
                    width: 4
                    height: 4
                    radius: 2
                    anchors.verticalCenter: parent.verticalCenter
                    color: (index >= 9 && index <= 12) || (index >= 20 && index <= 21) || (index >= 29 && index <= 36)
                        ? root.accentColor : root.mutedColor

                    SequentialAnimation on height {
                        running: root.playing
                        loops: Animation.Infinite

                        NumberAnimation {
                            to: (index >= 9 && index <= 12) || (index >= 20 && index <= 21) || (index >= 29 && index <= 36)
                                ? (8 + (index * 3) % 15) : (4 + (index * 2) % 8)
                            duration: 180 + (index * 47) % 220
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            to: 4
                            duration: 180 + (index * 47) % 220
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
}
