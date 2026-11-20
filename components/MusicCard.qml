import QtQuick

Item {
    id: root
    property var theme: null
    property var media: null
    property date currentTime: new Date()

    readonly property color cardColor: theme ? theme.cardColor : "#24283b"
    readonly property color accentColor: theme ? theme.accentColor : "#7aa2f7"
    readonly property color primaryText: theme ? theme.primaryText : "#c0caf5"
    readonly property color secondaryText: theme ? theme.secondaryText : "#a9b1d6"
    readonly property color borderColor: theme ? theme.borderColor : "#414868"
    readonly property color secondaryAccent: theme ? theme.secondaryAccent : "#ad8ee6"

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: root.cardColor
        border.width: 1
        border.color: root.borderColor

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 13

            Column {
                spacing: 3
                Text {
                    text: Qt.formatTime(root.currentTime, "h:mm AP")
                    color: root.primaryText
                    font.pixelSize: 34
                    font.weight: Font.Bold
                }
                Text {
                    text: Qt.formatDate(root.currentTime, "dddd, MMMM d")
                    color: root.secondaryText
                    font.pixelSize: 12
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: root.borderColor
                opacity: 0.7
            }

            Row {
                width: parent.width
                spacing: 12

                AlbumArtwork {
                    width: 76
                    height: 76
                    source: root.media ? root.media.artworkUrl : ""
                    accentColor: root.accentColor
                    borderColor: root.borderColor
                }

                TrackInfo {
                    width: Math.max(80, parent.width - 76 - 12 - 82)
                    anchors.verticalCenter: parent.verticalCenter
                    title: root.media ? root.media.title : "Nothing playing"
                    artist: root.media ? root.media.artist : "Start playing music"
                    album: root.media ? root.media.album : ""
                    primaryText: root.primaryText
                    secondaryText: root.secondaryText
                }

                Equalizer {
                    width: 82
                    height: 42
                    anchors.verticalCenter: parent.verticalCenter
                    playing: root.media ? root.media.isPlaying : false
                    accentColor: root.accentColor
                    secondaryAccent: root.secondaryAccent
                }
            }

            ProgressBar {
                width: parent.width
                position: root.media ? root.media.position : 0
                duration: root.media ? root.media.length : 0
                accentColor: root.accentColor
                trackColor: root.borderColor
                secondaryText: root.secondaryText
            }

            PlaybackControls {
                width: parent.width
                height: 42
                player: root.media ? root.media.player : null
                accentColor: root.accentColor
                primaryText: root.primaryText
                secondaryText: root.secondaryText
            }
        }
    }
}
