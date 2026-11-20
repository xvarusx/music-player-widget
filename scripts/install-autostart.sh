#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
SERVICE_NAME="music-card.service"

mkdir -p "$SERVICE_DIR"
install -Dm644 "$SOURCE_DIR/systemd/$SERVICE_NAME" "$SERVICE_DIR/$SERVICE_NAME"

systemctl --user daemon-reload
systemctl --user enable --now "$SERVICE_NAME"

printf 'Installed and enabled %s\n' "$SERVICE_NAME"
printf 'Check logs with: journalctl --user -u %s -f\n' "$SERVICE_NAME"
