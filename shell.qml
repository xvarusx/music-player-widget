import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Mpris

PanelWindow {
    id: root

    // Window positioning
    anchors {
        top: true
        right: true
    }

    margins {
        top: 75
        right: 30
    }

    implicitWidth: 340
    implicitHeight: 270

    color: "transparent"
    exclusiveZone: 0
    focusable: false

    // =====================================================
    // THEME INTEGRATION
    // =====================================================

    property string themePath:
        Quickshell.env("HOME")
        + "/.local/state/omarchy/current/theme/colors.toml"

    FileView {
        id: themeFile

        path: root.themePath
        watchChanges: true
        preload: true

        onFileChanged: reload()

        onLoaded: {
            console.log("Omarchy theme loaded successfully")
        }

        onLoadFailed: error => {
            console.warn("Theme loading failed:", error)
        }
    }

    function themeColor(name, fallback) {
        const content = themeFile.text()

        const expression = new RegExp(
            "^\\s*" + name +
            "\\s*=\\s*[\"']([^\"']+)[\"']",
            "m"
        )

        const match = content.match(expression)

        return match ? match[1] : fallback
    }

    // Tokyo Night palette
    property color cardColor:
        themeColor("lighter_background", "#24283b")

    property color accentColor:
        themeColor("accent", "#7aa2f7")

    property color primaryText:
        themeColor("bright_foreground", "#c0caf5")

    property color secondaryText:
        themeColor("foreground", "#a9b1d6")

    property color borderColor:
        themeColor("muted", "#414868")

    property color secondaryAccent:
        themeColor("magenta", "#ad8ee6")

    property string themeMode:
        themeColor("mode", "dark")

    // Refresh in case the active theme symlink changes.
    Timer {
        interval: 5000
        running: true
        repeat: true

        onTriggered: themeFile.reload()
    }

    // =====================================================
    // CLOCK
    // =====================================================

    property var currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: root.currentTime = new Date()
    }

    // =====================================================
    // MUSIC PLAYER
    // =====================================================

    property var player:
        Mpris.players.values.length > 0
        ? Mpris.players.values[0]
        : null

    // Refresh MPRIS playback position.
    Timer {
        interval: 1000
        running: root.player !== null &&
                 root.player.isPlaying
        repeat: true

        onTriggered: {
            if (root.player)
                root.player.positionChanged()
        }
    }

    // =====================================================
    // MAIN CARD
    // =====================================================

    Rectangle {
        anchors.fill: parent

        radius: 20
        color: root.cardColor

        border.width: 1
        border.color: root.borderColor

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            // CLOCK
            Column {
                spacing: 3

                Text {
                    text: Qt.formatTime(
                        root.currentTime, "h:mm AP"
                    )

                    color: root.primaryText

                    font.pixelSize: 38
                    font.weight: Font.Bold
                }

                Text {
                    text: Qt.formatDate(
                        root.currentTime, "dddd, MMMM d"
                    )

                    color: root.secondaryText
                    font.pixelSize: 13
                }
            }

            // DIVIDER
            Rectangle {
                width: parent.width
                height: 1
                color: root.borderColor
                opacity: 0.7
            }

            // MUSIC INFORMATION
            Row {
                width: parent.width
                spacing: 12

                Column {
                    width: 190
                    spacing: 5

                    Text {
                        text: root.player
                            ? root.player.trackTitle || "Unknown title"
                            : "Nothing playing"

                        color: root.primaryText
                        font.pixelSize: 14
                        font.bold: true

                        elide: Text.ElideRight
                        width: parent.width
                    }

                    Text {
                        text: root.player
                            ? root.player.trackArtist || "Unknown artist"
                            : "Start playing music"

                        color: root.secondaryText
                        font.pixelSize: 12

                        elide: Text.ElideRight
                        width: parent.width
                    }
                }

                // ANIMATED EQUALIZER
                Item {
                    width: 75
                    height: 32

                    Row {
                        anchors.centerIn: parent
                        spacing: 4

                        Repeater {
                            model: 7

                            Rectangle {
                                id: bar

                                property real idleHeight: 5
                                property real peakHeight:
                                    14 + (index % 4) * 5

                                width: 4
                                height: bar.idleHeight
                                radius: 3

                                color: index % 2 === 0
                                    ? root.accentColor
                                    : root.secondaryAccent

                                SequentialAnimation on height {
                                    running: root.player !== null &&
                                        root.player.isPlaying

                                    loops: Animation.Infinite

                                    NumberAnimation {
                                        to: bar.peakHeight
                                        duration: 300 + index * 70
                                        easing.type: Easing.InOutSine
                                    }

                                    NumberAnimation {
                                        to: bar.idleHeight
                                        duration: 300 + index * 70
                                        easing.type: Easing.InOutSine
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // PLAYBACK PROGRESS
            Column {
                width: parent.width
                spacing: 6

                Rectangle {
                    width: parent.width
                    height: 5
                    radius: 5
                    color: root.borderColor

                    Rectangle {
                        width: parent.width *
                            (root.player &&
                             root.player.length > 0
                                ? Math.max(
                                    0,
                                    Math.min(
                                        1,
                                        root.player.position /
                                        root.player.length
                                    )
                                )
                                : 0)

                        height: parent.height
                        radius: 5
                        color: root.accentColor
                    }
                }

                Row {
                    width: parent.width

                    Text {
                        text: root.player
                            ? formatTime(root.player.position)
                            : "0:00"

                        color: root.secondaryText
                        font.pixelSize: 10
                    }

                    Item {
                        width: parent.width - 90
                        height: 1
                    }

                    Text {
                        text: root.player
                            ? formatTime(root.player.length)
                            : "0:00"

                        color: root.secondaryText
                        font.pixelSize: 10
                    }
                }
            }
        }
    }

    // =====================================================
    // HELPERS
    // =====================================================

    function formatTime(seconds) {
        const value = Math.floor(seconds)
        const minutes = Math.floor(value / 60)
        const remaining = value % 60

        return minutes + ":" +
            (remaining < 10 ? "0" : "") + remaining
    }
}
