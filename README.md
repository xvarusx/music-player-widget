# Quickshell Music Player Widget

A small music and clock widget for Omarchy using Quickshell and MPRIS.

## Requirements

- Omarchy / Arch Linux
- Quickshell 0.3.2
- A media player that exposes an MPRIS interface

## Run

```bash
qs -c music-card
```

The Quickshell configuration directory should contain this repository as
`~/.config/quickshell/music-card/`.

## Project structure

```text
music-card/
├── shell.qml
├── components/
│   ├── AlbumArtwork.qml
│   ├── Equalizer.qml
│   ├── MusicCard.qml
│   ├── PlaybackControls.qml
│   ├── ProgressBar.qml
│   └── TrackInfo.qml
└── services/
    ├── MprisService.qml
    └── ThemeService.qml
```

- **ThemeService** reads Omarchy's active `colors.toml`, watches for changes, and periodically reloads the file to handle theme symlink changes.
- **MprisService** exposes the selected MPRIS player and its metadata/playback controls to the UI.
- **MusicCard** composes the clock, artwork, track information, equalizer, progress display, and playback controls.

## Local verification

After updating the repository, restart the Quickshell configuration:

```bash
qs -c music-card
```

If the configuration is already running, reload it using your usual Quickshell workflow or stop and launch it again.

Test with a player that exposes MPRIS metadata:

```bash
playerctl metadata
playerctl status
```

Then verify:

1. The widget displays the current title and artist.
2. Artwork appears when the MPRIS player provides a readable art URL.
3. Play/pause and previous/next work when the player advertises those capabilities.
4. The progress display advances during playback.
5. Switching Omarchy themes updates the widget colors.

## Current implementation notes

- The first available MPRIS player is selected, matching the initial widget.
- Artwork uses the MPRIS `trackArtUrl`; a musical-note placeholder is shown if artwork is missing or cannot be loaded.
- Position is refreshed once per second during playback.
- Progress seeking and frame-smooth animation are not implemented yet.
