#!/usr/bin/env bash
# Prints: <rounding> <opacity> <blur 0|1>
rounding=$(hyprctl getoption decoration:rounding -j | jq -r '.int // 0')
blur=$(hyprctl getoption decoration:blur:enabled -j | jq -r '.int // 0')

# Omarchy sets transparency through window rules, not active_opacity.
# Adjust this grep if your rule lives elsewhere.
opacity=$(grep -rhoE 'opacity +[0-9.]+' ~/.config/hypr/ 2>/dev/null | head -n1 | awk '{print $2}')
opacity=${opacity:-1.0}

echo "$rounding $opacity $blur"