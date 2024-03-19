#!/usr/bin/env bash

PacmanConf() {
    PacmanDir="/etc/pacman.conf"
    MultilibLine=$(grep -n "\\[multilib\\]" "$PacmanDir" | cut -d: -f1)
    IncludeLine=$((MultilibLine + 1))
    
    sed -i "/^#Color\|^#ParallelDownloads\|^#VerbosePkgLists\|^#\[multilib\]/s/^#//" "$PacmanDir"
    sed -i "${IncludeLine}s/^#//" "$PacmanDir"
    sed -i '/^Color/a ILoveCandy' "$PacmanDir"

    pacman -Syyu --noconfirm
}

