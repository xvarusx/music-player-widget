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

            Rectangle {
                width: 4
                height: 4
                radius: 2
                color: "#5F6B7A"
            }
        }
    }
}
