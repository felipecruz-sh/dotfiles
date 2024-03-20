#!/usr/bin/env bash

# ==================== SOURCES ====================

source .install/pacman.sh
source .install/packages.sh

# ==================== SOURCES ====================

PacmanConf

for i in "${PacmanPackages[@]}"; do
    sudo pacman -S --noconfirm "$i"
done