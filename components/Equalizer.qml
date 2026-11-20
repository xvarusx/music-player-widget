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
                id: bar
                property real idleHeight: 5
                property real peakHeight: 12 + (index % 5) * 5
                width: 4
                height: root.playing ? animatedHeight : idleHeight
                property real animatedHeight: idleHeight
                radius: 3
                color: index % 2 === 0 ? root.accentColor : root.secondaryAccent

                SequentialAnimation on animatedHeight {
                    running: root.playing
                    loops: Animation.Infinite
                    NumberAnimation {
                        to: bar.peakHeight
                        duration: 260 + index * 65
                        easing.type: Easing.InOutSine
                    }
                    NumberAnimation {
                        to: bar.idleHeight
                        duration: 260 + index * 65
                        easing.type: Easing.InOutSine
                    }
                }
                Behavior on height {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }
        }
    }
}
