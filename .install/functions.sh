#!/usr/bin/env bash

# ============================== SOURCE VARIABLES ==============================

source .install/variables.sh

# ============================== SOURCE VARIABLES ==============================


# ============================== FUNCTIONS ==============================

function IsInstalled () {
    command -v $1 >&-;
}

function PacmanConf() {
    IncludeLine=$(($(grep -n "\\[multilib\\]" /etc/pacman.conf | cut -d: -f1) + 1))
    sudo sed -i "/^#Color\|^#ParallelDownloads\|^#VerbosePkgLists\|^#\[multilib\]/s/^#//" /etc/pacman.conf
    sudo sed -i "${IncludeLine}s/^#//" /etc/pacman.conf
    sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
    sudo pacman -Syyu --noconfirm
}

function GrubConfig() {
    if grub-install --version >&- && [ -f /boot/grub/grub.cfg ]; then
        sudo mv /etc/default/grub /etc/default/grub.bak
        if sudo echo "${Lines//  /}" >> /etc/default/grub; then
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
}

InstallPacmanPackages() {
    for i in "${PacmanPackages[@]}"; do
    sudo pacman -S --noconfirm "$i"
    done
}

InstallAURPackages() {
    for i in "${AUR_PKG[@]}"; do
    git clone https://aur.archlinux.org/"$i".git
    cd "$i" || exit
    makepkg -si --noconfirm
    cd .. 
    rm -rf "$i"
    done
}

Plymouth() {
    sed -i '/^HOOKS/ s/udev /udev plymouth /' /etc/mkinitcpio.conf
    mkinitcpio -p linux-lts
    plymouth-set-default-theme -R bgrt
    sed -i '/^Theme/a ShowDelay\=0' /etc/plymouth/plymouthd.conf
    sed -i '/message/d' /etc/grub.d/10_linux
}


# ============================== FUNCTIONS ==============================