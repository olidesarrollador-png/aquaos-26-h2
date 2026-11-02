#!/usr/bin/env bash
iso_name="aquaos"
iso_label="AQUAOS_26H2"
iso_publisher="Quack Labs"
iso_application="AquaOS 26 H2 Live/Install Environment"
iso_version="26H2"
install_dir="aquaos"
bootmodes=('uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"

file_permissions=(
  ["/usr/local/bin/aquaos-first-boot"]="0:0:755"
)
