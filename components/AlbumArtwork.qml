import QtQuick

Item {
    id: root
    property url source: ""
    property color accentColor: "#7aa2f7"
    property color borderColor: "#414868"

    Rectangle {
        anchors.fill: parent
        radius: 14
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

    // Simplified fallback as per redesign
    Item {
        anchors.fill: parent
        visible: artwork.status !== Image.Ready
        
        Rectangle {
            anchors.fill: parent
            radius: 14
            gradient: Gradient {
                GradientStop { position: 0; color: "#544E3D" }
                GradientStop { position: 0.6; color: "#3B372B" }
                GradientStop { position: 1; color: "#24221A" }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: "transparent"
        border.width: 1
        border.color: root.borderColor
    }
}
