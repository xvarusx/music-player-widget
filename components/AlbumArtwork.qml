import QtQuick

Item {
    id: root
    property url source: ""
    property color accentColor: "#7aa2f7"
    property color borderColor: "#414868"

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: root.borderColor
        opacity: 0.45
    }

    Image {
        id: artwork
        anchors.fill: parent
        source: root.source
        asynchronous: true
        cache: true
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
        opacity: status === Image.Ready ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }
    }

    Text {
        anchors.centerIn: parent
        text: "♫"
        color: root.accentColor
        font.pixelSize: Math.min(root.width, root.height) * 0.42
        visible: artwork.status !== Image.Ready
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "transparent"
        border.width: 1
        border.color: root.borderColor
    }
}
