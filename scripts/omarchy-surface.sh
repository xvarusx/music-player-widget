#!/bin/sh
# Prints "<opacity> <blur>" describing how Omarchy currently renders windows.
#   opacity: 0.0-1.0 (1.0 = opaque)
#   blur:    0 or 1 (1 = blurred)
# Used by services/ThemeService.qml. Run it by hand to debug.

mode=$(omarchy-hyprland-window-transparency 2>/dev/null)
case "$mode" in
  opaque)
    opacity=1.0
    blur=0
    ;;
  transparent|glassy)
    # Defaults from Omarchy's transparent window (o.transparent_window):
    # opacity 0.985 with the glassy blur layered on top.
    opacity=0.985
    blur=1
    ;;
  *)
    opacity=1.0
    blur=0
    ;;
esac

printf "%.2f %d\n" "$opacity" "$blur"
