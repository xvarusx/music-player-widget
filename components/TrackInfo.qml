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
        font.family: "Roboto Mono"
        font.pixelSize: 17
        font.weight: Font.DemiBold
        elide: Text.ElideRight
    }
    Text {
        width: root.width
        text: root.artist
        color: root.secondaryText
        font.family: "Roboto Mono"
        font.pixelSize: 13
        font.weight: Font.Medium
        elide: Text.ElideRight
    }
    Text {
        width: root.width
        text: root.album
        color: "#586574"
        font.family: "Roboto Mono"
        font.pixelSize: 12
        font.weight: Font.Normal
        elide: Text.ElideRight
        visible: text.length > 0
    }
}
