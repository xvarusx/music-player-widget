# Quickshell Music Player Widget

A clock and MPRIS music widget for Omarchy using Quickshell 0.3.2.

## Requirements

- Omarchy / Arch Linux
- Quickshell 0.3.2
- A media player exposing MPRIS
- PipeWire / WirePlumber (`wpctl`) for system output volume control

## Run manually

Install this repository at `~/.config/quickshell/music-card/`, then run:

```bash
qs -c music-card
```

## Automatic startup

Enable the user-level systemd service:

```bash
bash scripts/install-autostart.sh
```

Check its status and logs:

```bash
systemctl --user status music-card.service
journalctl --user -u music-card.service -f
```

Disable automatic startup:

```bash
systemctl --user disable --now music-card.service
```

## Persistent configuration

Settings are stored in `settings.json` next to `shell.qml`. This file is intentionally ignored by Git so personal monitor and layout preferences do not become repository changes.

Example:

```json
{
  "screenName": "DP-1",
  "corner": "top-right",
  "offsetX": 30,
  "offsetY": 75,
  "width": 360,
  "height": 350
}
```

- `screenName`: exact monitor name, such as `DP-1`, `HDMI-A-1`, or `eDP-1`. Empty selects the first connected screen.
- `corner`: `top-left`, `top-right`, `bottom-left`, or `bottom-right`.
- `offsetX` and `offsetY`: distance from the selected corner in logical pixels.
- `width` and `height`: widget dimensions in logical pixels.
- `surface`: `auto` (default, follows Omarchy), `opaque`, `transparent` or `glassy`.
- `surfaceOpacity`: `-1` for automatic, or `0.0`-`1.0` to force the card alpha.

### Opacity, glass and corner radius

The card radius comes from Hyprland's `decoration:rounding`, and the surface
follows Omarchy's window transparency (`scripts/omarchy-surface.sh`):
opaque when transparency is off, transparent when it is on, and glassy when
transparency is on and Hyprland blur is enabled. Run
`sh scripts/omarchy-surface.sh` to see what the widget detects (`<opacity> <blur>`).

For the blur behind the card in glassy mode, add to your Hyprland config
(the widget's layer namespace is `music-card`):

```
# Hyprland < 0.53
layerrule = blur, music-card
layerrule = ignorealpha 0.2, music-card
# Hyprland >= 0.53
layerrule = blur on, match:namespace music-card
layerrule = ignore_alpha 0.2, match:namespace music-card
```

The widget is created only once. If the configured monitor is disconnected, it falls back to the first connected monitor; when the configured monitor returns, it is selected again. Available monitor names are printed in the Quickshell logs.

## Features

- Loads colors from Omarchy's active `~/.local/state/omarchy/current/theme/colors.toml` palette and reloads when the active theme changes.
- MPRIS metadata, artwork, play/pause and 10-second seek controls.
- Use the `−` and `+` controls or scroll over the volume pill to adjust the default PipeWire output volume in 5% steps using `wpctl`.
- System volume is polled so changes made by keyboard shortcuts or another mixer are reflected in the widget.
- Click the progress track to seek to the clicked position (when MPRIS seeking is supported).
- Animated equalizer while playing.

## Verify

```bash
playerctl -l
playerctl status
wpctl get-volume @DEFAULT_AUDIO_SINK@
journalctl --user -u music-card.service -f
```
