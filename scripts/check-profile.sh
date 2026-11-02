#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/profile/packages.x86_64"

if grep -Eq '^[[:space:]]+[^#[:space:]]' "$PKG"; then
  echo "Package entries must not have leading whitespace."
  exit 1
fi
if grep -Ev '^[[:space:]]*(#.*)?$|^[[:space:]]*[[:alnum:]@._+-]+[[:space:]]*$' "$PKG"; then
  echo "Invalid package-list line. Use one package name per line."
  exit 1
fi
for p in base linux linux-firmware mkinitcpio mkinitcpio-archiso archinstall plasma-desktop sddm steam ollama grub; do
  grep -Eq "^[[:space:]]*$p[[:space:]]*$" "$PKG" || { echo "Missing required package: $p"; exit 1; }
done
[[ -f "$ROOT/profile/profiledef.sh" ]] || { echo "Missing profile/profiledef.sh"; exit 1; }
[[ -f "$ROOT/profile/grub/grub.cfg" ]] || { echo "UEFI GRUB selected, but profile/grub/grub.cfg is missing."; exit 1; }
grep -q "bootmodes=('uefi.grub')" "$ROOT/profile/profiledef.sh" || { echo "Expected the supported uefi.grub boot mode."; exit 1; }
echo "AquaOS profile consistency checks passed. This does not verify package availability or build an ISO."

