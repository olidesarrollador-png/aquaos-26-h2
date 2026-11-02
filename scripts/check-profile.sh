#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="$ROOT/profile/packages.x86_64"

if grep -Eq '^[[:space:]]+[^#[:space:]]' "$PKG"; then
  echo "Los nombres de paquete no pueden tener espacios iniciales."
  exit 1
fi
if grep -Ev '^[[:space:]]*(#.*)?$|^[[:space:]]*[[:alnum:]@._+-]+[[:space:]]*$' "$PKG"; then
  echo "Línea no válida en la lista de paquetes. Usa un paquete por línea."
  exit 1
fi
for p in base linux linux-firmware mkinitcpio mkinitcpio-archiso archinstall plasma-desktop sddm steam ollama grub; do
  grep -Eq "^[[:space:]]*$p[[:space:]]*$" "$PKG" || { echo "Falta un paquete obligatorio: $p"; exit 1; }
done
[[ -f "$ROOT/profile/profiledef.sh" ]] || { echo "Falta profile/profiledef.sh"; exit 1; }
[[ -f "$ROOT/profile/grub/grub.cfg" ]] || { echo "Se seleccionó UEFI GRUB, pero falta profile/grub/grub.cfg."; exit 1; }
[[ -f "$ROOT/profile/airootfs/etc/systemd/system/aquaos-live-user.service" ]] || { echo "Falta el servicio de cuenta live de AquaOS."; exit 1; }
[[ -f "$ROOT/profile/airootfs/etc/sddm.conf.d/aquaos.conf" ]] || { echo "Falta la configuración de SDDM para AquaOS."; exit 1; }
grep -q "bootmodes=('uefi.grub')" "$ROOT/profile/profiledef.sh" || { echo "No se encontró el modo de arranque uefi.grub esperado."; exit 1; }
grep -q '^User=aquaos$' "$ROOT/profile/airootfs/etc/sddm.conf.d/aquaos.conf" || { echo "SDDM no tiene configurado el usuario live AquaOS."; exit 1; }
echo "Comprobación estática del perfil AquaOS completada. No valida los paquetes de Arch ni construye o arranca una ISO."


