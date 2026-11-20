import QtQuick

Item {
    id: root

    property bool playing: false
    property color accentColor: "#7aa2f7"
    property color secondaryAccent: "#ad8ee6"

    Row {
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: 9

            Rectangle {
                property real idleHeight: 5
                property real peakHeight: 12 + (index % 5) * 5

                width: 4
                height: idleHeight
                radius: 3
                color: index % 2 === 0 ? root.accentColor : root.secondaryAccent
                anchors.verticalCenter: parent.verticalCenter

                SequentialAnimation on height {
                    running: root.playing
                    loops: Animation.Infinite

                    NumberAnimation {
                        to: peakHeight
                        duration: 240 + index * 65
                        easing.type: Easing.InOutSine
                    }

                    NumberAnimation {
                        to: idleHeight
                        duration: 240 + index * 65
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }
    }
}
