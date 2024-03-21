#!/usr/bin/env bash

# ==================== SOURCES ====================

source .install/pacman.sh
source .install/grub.sh
source .install/packages.sh
source .install/graphics.sh

# ==================== SOURCES ====================

PacmanConf

for i in "${PacmanPackages[@]}"; do
    sudo pacman -S --noconfirm "$i"
done

GrubConfig

echo "
=================================
=     Which Graphics Card?      =
=================================

1) Intel
2) AMD
3) Nvidia
"

read -r GraphicsCard

case $GraphicsCard in
1)
    IntelGraphics;;
2)
    AMDGraphics;;
3)
    NvidiaGraphics;;
esac