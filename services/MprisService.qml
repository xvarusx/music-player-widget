import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root
    visible: false
    width: 0
    height: 0

    property var player: Mpris.players.values.length > 0
        ? Mpris.players.values[0] : null

    readonly property string title: player
        ? (player.trackTitle || "Unknown title") : "Nothing playing"
    readonly property string artist: player
        ? (player.trackArtist || "Unknown artist") : "Start playing music"
    readonly property string album: player ? (player.trackAlbum || "") : ""
    readonly property url artworkUrl: player ? player.trackArtUrl : ""
    readonly property bool isPlaying: player ? player.isPlaying : false
    readonly property real position: player ? player.position : 0
    readonly property real length: player ? player.length : 0

    function togglePlayback() {
        if (player) player.togglePlaying()
    }
    function next() {
        if (player) player.next()
    }
    function previous() {
        if (player) player.previous()
    }

    // MPRIS position is not guaranteed to emit frequent updates.
    // Ask the active player to refresh while playback is running.
    Timer {
        interval: 1000
        running: root.player !== null && root.isPlaying
        repeat: true
        onTriggered: {
            if (root.player) root.player.positionChanged()
        }
    }
}
