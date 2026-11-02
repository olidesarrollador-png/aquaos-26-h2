#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "Falta archiso. Instálalo en el equipo Arch Linux de compilación."
  exit 1
fi

# El ZIP fuente tenía archivos regulares vacíos donde hacen falta enlaces
# simbólicos de systemd. Se crean temporalmente durante la compilación.
SYSTEMD_DIR="$PWD/profile/airootfs/etc/systemd/system"
NETWORK_WANTS="$SYSTEMD_DIR/multi-user.target.wants"
GRAPHICAL_WANTS="$SYSTEMD_DIR/graphical.target.wants"
mkdir -p "$NETWORK_WANTS"
mkdir -p "$GRAPHICAL_WANTS"
ln -sfn /usr/lib/systemd/system/graphical.target "$SYSTEMD_DIR/default.target"
ln -sfn /usr/lib/systemd/system/sddm.service "$SYSTEMD_DIR/display-manager.service"
ln -sfn /usr/lib/systemd/system/sddm.service "$GRAPHICAL_WANTS/display-manager.service"
ln -sfn /usr/lib/systemd/system/NetworkManager.service "$NETWORK_WANTS/NetworkManager.service"
ln -sfn /usr/lib/systemd/system/aquaos-live-user.service "$GRAPHICAL_WANTS/aquaos-live-user.service"
cleanup() {
  rm -f "$SYSTEMD_DIR/default.target" \
    "$SYSTEMD_DIR/display-manager.service" \
    "$GRAPHICAL_WANTS/display-manager.service" \
    "$GRAPHICAL_WANTS/aquaos-live-user.service" \
    "$NETWORK_WANTS/NetworkManager.service"
  rmdir "$GRAPHICAL_WANTS" 2>/dev/null || true
}
trap cleanup EXIT
sudo mkarchiso -v -w work -o out profile

