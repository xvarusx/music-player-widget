import QtQuick
import Quickshell.Io

// Controls and monitors the default PipeWire playback sink via wpctl.
// MPRIS volume is intentionally not used: it controls per-player volume
// and is not consistently supported by media applications.
Item {
    id: root

    visible: false
    width: 0
    height: 0

    readonly property real volume: currentVolume
    property real currentVolume: 0
    property bool muted: false
    property bool available: false
    property int pendingSteps: 0

    function refresh() {
        if (!volumeQuery.running)
            volumeQuery.exec(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"])
    }

    function adjustVolume(direction) {
        if (direction === 0)
            return

        pendingSteps = Math.max(-20, Math.min(20,
            pendingSteps + (direction > 0 ? 1 : -1)))
        runNextAdjustment()
    }

    function runNextAdjustment() {
        if (volumeCommand.running || pendingSteps === 0)
            return

        const step = pendingSteps > 0 ? "5%+" : "5%-"
        pendingSteps += pendingSteps > 0 ? -1 : 1
        volumeCommand.exec([
            "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", step,
            "--limit", "1.0"
        ])
    }

    function updateFromOutput(output) {
        const match = output.match(/Volume:\s*([0-9]+(?:\.[0-9]+)?)/)
        if (!match) {
            available = false
            return
        }

        currentVolume = Math.max(0, Math.min(1, Number(match[1])))
        muted = output.indexOf("[MUTED]") !== -1
        available = true
    }

    Process {
        id: volumeQuery
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: root.updateFromOutput(this.text)
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                root.available = false
        }
    }

    Process {
        id: volumeCommand

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                console.warn("System volume: wpctl set-volume failed with exit code", exitCode)

            if (root.pendingSteps !== 0)
                root.runNextAdjustment()
            else
                root.refresh()
        }
    }

    // Also reflect changes made outside the widget (keyboard keys, mixer, etc.).
    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
