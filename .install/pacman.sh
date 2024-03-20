#!/usr/bin/env bash

PacmanConf() {
    PacmanDir="/etc/pacman.conf"
    MultilibLine=$(grep -n "\\[multilib\\]" "$PacmanDir" | cut -d: -f1)
    IncludeLine=$((MultilibLine + 1))
    
    sudo sed -i "/^#Color\|^#ParallelDownloads\|^#VerbosePkgLists\|^#\[multilib\]/s/^#//" "$PacmanDir"
    sudo sed -i "${IncludeLine}s/^#//" "$PacmanDir"
    sudo sed -i '/^Color/a ILoveCandy' "$PacmanDir"

    sudo pacman -Syyu --noconfirm
}

