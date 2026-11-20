import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root

    visible: false
    width: 0
    height: 0

    // Prefer the player that is actively playing. If none is playing,
    // prefer one that advertises playback control, then fall back to
    // the first connected MPRIS player.
    property var player: {
        const availablePlayers = Mpris.players.values
        if (!availablePlayers || availablePlayers.length === 0)
            return null

        for (let i = 0; i < availablePlayers.length; i++) {
            const candidate = availablePlayers[i]
            if (candidate.isPlaying && candidate.canTogglePlaying)
                return candidate
        }

        for (let i = 0; i < availablePlayers.length; i++) {
            const candidate = availablePlayers[i]
            if (candidate.canTogglePlaying || candidate.canGoNext || candidate.canGoPrevious)
                return candidate
        }

        return availablePlayers[0]
    }

    readonly property string playerIdentity: player ? player.identity : "No MPRIS player"
    readonly property string title: player
        ? (player.trackTitle || "Unknown title") : "Nothing playing"
    readonly property string artist: player
        ? (player.trackArtist || "Unknown artist") : "Start playing music"
    readonly property string album: player ? (player.trackAlbum || "") : ""
    readonly property url artworkUrl: player ? player.trackArtUrl : ""
    readonly property bool isPlaying: player ? player.isPlaying : false
    readonly property real position: player ? player.position : 0
    readonly property real length: player ? player.length : 0

    readonly property bool canTogglePlayback: player ? player.canTogglePlaying : false
    readonly property bool canGoNext: player ? player.canGoNext : false
    readonly property bool canGoPrevious: player ? player.canGoPrevious : false
    readonly property bool canSeek: player ? player.canSeek : false

    // Seek offsets are expressed in seconds by Quickshell's MprisPlayer API.
    property real seekStep: 10

    function togglePlayback() {
        if (!player) {
            console.warn("MPRIS: no player is available")
            return
        }

        if (player.isPlaying) {
            if (player.canPause)
                player.pause()
            else
                console.warn("MPRIS: selected player does not support pause:", player.identity)
        } else {
            if (player.canPlay)
                player.play()
            else
                console.warn("MPRIS: selected player does not support play:", player.identity)
        }
    }

    function seekBackward() {
        if (player && player.canSeek)
            player.seek(-seekStep)
        else
            console.warn("MPRIS: seeking is not supported by the selected player")
    }

    function seekForward() {
        if (player && player.canSeek)
            player.seek(seekStep)
        else
            console.warn("MPRIS: seeking is not supported by the selected player")
    }

    onPlayerChanged: {
        if (player) {
            console.log(
                "MPRIS selected:", player.identity,
                "| playing:", player.isPlaying,
                "| canPlay:", player.canPlay,
                "| canPause:", player.canPause,
                "| canSeek:", player.canSeek
            )
        } else {
            console.log("MPRIS: waiting for a media player")
        }
    }

    // Quickshell does not continuously emit position changes by default.
    Timer {
        interval: 1000
        running: root.player !== null && root.isPlaying
        repeat: true
        onTriggered: {
            if (root.player)
                root.player.positionChanged()
        }
    }
}
