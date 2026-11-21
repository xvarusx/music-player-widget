import QtQuick
import Quickshell.Io

// Controls the default PipeWire playback sink with wpctl.
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
    property real pendingAbsoluteVolume: -1

    function refresh() {
        if (!volumeQuery.running)
            volumeQuery.running = true
    }

    function adjustVolume(direction) {
        if (direction === 0)
            return

        pendingAbsoluteVolume = -1
        pendingSteps = Math.max(-20, Math.min(20,
            pendingSteps + (direction > 0 ? 1 : -1)))
        runNextAdjustment()
    }

    // Click/drag on the meter sets an absolute volume between 0 and 100%.
    function setVolume(value) {
        pendingSteps = 0
        pendingAbsoluteVolume = Math.max(0, Math.min(1, value))
        runNextAdjustment()
    }

    function runNextAdjustment() {
        if (volumeCommand.running)
            return

        if (pendingAbsoluteVolume >= 0) {
            const target = Math.round(pendingAbsoluteVolume * 100)
            pendingAbsoluteVolume = -1
            volumeCommand.command = [
                "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@",
                target + "%", "--limit", "1.0"
            ]
            volumeCommand.running = true
            return
        }

        if (pendingSteps === 0)
            return

        const step = pendingSteps > 0 ? "5%+" : "5%-"
        pendingSteps += pendingSteps > 0 ? -1 : 1
        volumeCommand.command = [
            "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", step,
            "--limit", "1.0"
        ]
        volumeCommand.running = true
    }

    function updateFromOutput(output) {
        // wpctl prints e.g. "Volume: 0.50" (decimal fraction, not percent).
        const match = output.match(/Volume:\s*([0-9]+(?:\.[0-9]+)?)/)
        if (!match) {
            available = false
            console.warn("Could not parse wpctl volume output:", output)
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
            if (exitCode !== 0) {
                root.available = false
                console.warn("System volume: wpctl get-volume failed with exit code", exitCode)
            }
        }
    }

    Process {
        id: volumeCommand

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                console.warn("System volume: wpctl set-volume failed with exit code", exitCode)

            if (root.pendingAbsoluteVolume >= 0 || root.pendingSteps !== 0)
                root.runNextAdjustment()
            else
                root.refresh()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
