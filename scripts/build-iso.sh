#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "Falta archiso. Instala con: sudo pacman -S archiso"
  exit 1
fi

# The source ZIP contained empty regular files where systemd enablement
# symlinks should be. Materialize the links for the overlay during the build.
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
