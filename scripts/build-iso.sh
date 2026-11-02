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
mkdir -p "$NETWORK_WANTS"
ln -sfn /usr/lib/systemd/system/sddm.service "$SYSTEMD_DIR/display-manager.service"
ln -sfn /usr/lib/systemd/system/NetworkManager.service "$NETWORK_WANTS/NetworkManager.service"
cleanup() {
  rm -f "$SYSTEMD_DIR/display-manager.service" "$NETWORK_WANTS/NetworkManager.service"
}
trap cleanup EXIT
sudo mkarchiso -v -w work -o out profile
