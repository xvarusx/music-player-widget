import QtQuick

Item {
    id: root
    property var theme: null
    property var media: null
    property var audio: null

    readonly property color cardColor: theme ? theme.cardColor : "transparent"
    readonly property color accentColor: theme ? theme.accentColor : "transparent"
    readonly property color primaryText: theme ? theme.primaryText : "transparent"
    readonly property color secondaryText: theme ? theme.secondaryText : "transparent"
    readonly property color borderColor: theme ? theme.borderColor : "transparent"
    readonly property color mutedColor: theme ? theme.mutedColor : "transparent"
    readonly property color trackColor: theme ? theme.trackColor : "transparent"
    readonly property color secondaryAccent: theme ? theme.secondaryAccent : "transparent"

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
                audio: root.audio
                accentColor: root.accentColor
                primaryText: root.primaryText
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
                    placeholderColor: root.cardColor
                }

                TrackInfo {
                    width: parent.width - 98 - 18
                    anchors.verticalCenter: parent.verticalCenter
                    title: root.media ? root.media.title : "Nothing playing"
                    artist: root.media ? root.media.artist : "Start playing music"
                    album: root.media ? root.media.album : ""
                    primaryText: root.primaryText
                    secondaryText: root.secondaryText
                }
            }

            ProgressBar {
                width: parent.width
                position: root.media ? root.media.position : 0
                duration: root.media ? root.media.length : 0
                media: root.media
                accentColor: root.accentColor
                trackColor: root.trackColor
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
                mutedColor: root.mutedColor
            }

            Item {
                width: parent.width
                height: 3
                Rectangle {
                    anchors.centerIn: parent
                    width: 36
                    height: 3
                    radius: 1.5
                    color: root.borderColor
                }
            }
        }
    }
}
