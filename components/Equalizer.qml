import QtQuick

Item {
    id: root

    property bool playing: false
    property color accentColor: "#7aa2f7"
    property color secondaryAccent: "#ad8ee6"

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
                        ? root.accentColor : "#5F6B7A"

                    SequentialAnimation on height {
                        id: barAnimation
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
