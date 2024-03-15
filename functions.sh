#!/usr/bin/env bash

nvidia_detect()
{
    if [ "$(lspci -k | grep -A 2 -E "(VGA|3D)" | grep -c nvidia)" -gt 0 ]
    then
        return 0
    else
        return 1
    fi
}

PacmanConf()
{
    PacmanDir="/etc/pacman.conf"
    MultilibLine=$(grep -n "\\[#multilib\\]" $PacmanDir | cut -d: -f1)
    IncludeLine=$((MultilibLine + 1))

    sed -i "/^#Color\|^#ParallelDownloads\|^#VerbosePkgLists\|^#\[multilib\]/s/^#//" $PacmanDir
    sed -i "$IncludeLine s/#//" $PacmanDir
    sed -i '/^Color/a ILoveCandy' $PacmanDir
}
