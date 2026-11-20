import QtQuick

Column {
    id: root
    property string title: "Nothing playing"
    property string artist: "Start playing music"
    property string album: ""
    property color primaryText: "#c0caf5"
    property color secondaryText: "#a9b1d6"
    spacing: 5

    Text {
        width: root.width
        text: root.title
        color: root.primaryText
        font.pixelSize: 14
        font.bold: true
        elide: Text.ElideRight
    }
    Text {
        width: root.width
        text: root.artist
        color: root.secondaryText
        font.pixelSize: 12
        elide: Text.ElideRight
    }
    Text {
        width: root.width
        text: root.album
        color: root.secondaryText
        font.pixelSize: 10
        elide: Text.ElideRight
        visible: text.length > 0
        opacity: 0.8
    }
}
