import QtQuick
import QtQuick.Effects

Item {
    id: root
    property url source: ""
    property color accentColor: "#7aa2f7"
    property color borderColor: "#414868"

    width: 98
    height: 98

    Rectangle {
        anchors.fill: parent
        radius: Math.min(width, height) / 2
        color: root.borderColor
        opacity: 0.45
    }

    Item {
        id: clipArea
        anchors.fill: parent

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

            // A rounded Rectangle behind an Image does not clip its children.
            // MultiEffect applies a true alpha-circle mask to the image itself.
            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: circleMaskTexture
                maskThresholdMin: 0.5
                maskSpreadAtMin: 0.02
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }
        }

        Rectangle {
            id: circleMask
            anchors.fill: artwork
            radius: Math.min(width, height) / 2
            color: "white"
        }

        ShaderEffectSource {
            id: circleMaskTexture
            sourceItem: circleMask
            hideSource: true
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            visible: artwork.status !== Image.Ready
            radius: Math.min(width, height) / 2
            gradient: Gradient {
                GradientStop { position: 0; color: "#544E3D" }
                GradientStop { position: 0.6; color: "#3B372B" }
                GradientStop { position: 1; color: "#24221A" }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Math.min(width, height) / 2
        color: "transparent"
        border.width: 1
        border.color: root.borderColor
    }
}
