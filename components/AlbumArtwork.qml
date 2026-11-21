import QtQuick

Item {
    id: root
    property url source: ""
    property color accentColor: "#7aa2f7"
    property color borderColor: "#414868"

    width: 98
    height: 98

    // Background circle
    Rectangle {
        anchors.fill: parent
        radius: 49
        color: root.borderColor
        opacity: 0.45
    }

    // Container with circular clipping
    Rectangle {
        id: clipArea
        anchors.fill: parent
        radius: 49
        color: "transparent"
        
        // Album artwork image - clipped by parent rectangle's radius
        Image {
            id: artwork
            anchors.fill: parent
            anchors.margins: 1
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
            clip: true
        }

        // Fallback placeholder
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            visible: artwork.status !== Image.Ready
            radius: 48
            gradient: Gradient {
                GradientStop { position: 0; color: "#544E3D" }
                GradientStop { position: 0.6; color: "#3B372B" }
                GradientStop { position: 1; color: "#24221A" }
            }
        }
    }

    // Border
    Rectangle {
        anchors.fill: parent
        radius: 49
        color: "transparent"
        border.width: 1
        border.color: root.borderColor
    }
}