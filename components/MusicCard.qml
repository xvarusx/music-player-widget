import QtQuick

Item {
    id: root
    property var theme: null
    property var media: null

    readonly property color cardColor: theme ? theme.cardColor : "#24283b"
    readonly property color accentColor: theme ? theme.accentColor : "#7aa2f7"
    readonly property color primaryText: theme ? theme.primaryText : "#c0caf5"
    readonly property color secondaryText: theme ? theme.secondaryText : "#a9b1d6"
    readonly property color borderColor: theme ? theme.borderColor : "#414868"
    readonly property color secondaryAccent: theme ? theme.secondaryAccent : "#ad8ee6"

    width: 380

    Rectangle {
        anchors.fill: parent
        radius: 26
        color: root.cardColor
        border.width: 1
        border.color: root.borderColor

        Column {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            anchors.topMargin: 22
            anchors.bottomMargin: 18
            spacing: 20

            HeaderRow {
                width: parent.width
                theme: root.theme
                media: root.media
            }

            Row {
                width: parent.width
                spacing: 18

                AlbumArtwork {
                    width: 98
                    height: 98
                    source: root.media ? root.media.artworkUrl : ""
                    accentColor: root.accentColor
                    borderColor: root.borderColor
                }

                TrackInfo {
                    width: parent.width - 98 - 18
                    anchors.verticalCenter: parent.verticalCenter
                    title: root.media ? root.media.title : "INSANITY"
                    artist: root.media ? root.media.artist : "WIL$ON"
                    album: root.media ? root.media.album : "Method Acting : act I"
                    primaryText: root.primaryText
                    secondaryText: root.secondaryText
                }
            }

            ProgressBar {
                width: parent.width
                position: root.media ? root.media.position : 17000
                duration: root.media ? root.media.length : 125000
                media: root.media
                accentColor: root.accentColor
                trackColor: root.borderColor
                secondaryText: root.secondaryText
            }

            PlaybackControls {
                width: parent.width
                height: 56
                media: root.media
                accentColor: root.accentColor
                primaryText: root.primaryText
                secondaryText: root.secondaryText
            }

            Equalizer {
                width: parent.width
                height: 28
                playing: root.media ? root.media.isPlaying : false
                accentColor: root.accentColor
                secondaryAccent: root.secondaryAccent
            }

            Item {
                width: parent.width
                height: 3
                Row {
                    anchors.centerIn: parent
                    width: 36
                    height: 3
                    Rectangle {
                        width: 36
                        height: 3
                        radius: 1.5
                        color: root.borderColor
                    }
                }
            }
        }
    }
}
