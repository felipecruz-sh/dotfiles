#!/usr/bin/env bash

function PacmanConf() {
    local pacmanPath=/etc/pacman.conf
    local includeLine=$(($(grep -n "\\[multilib\\]" "$pacmanPath" | cut -d: -f1) + 1))

    sudo sed -i "/^#Color\|^#ParallelDownloads\|^#VerbosePkgLists\|^#\[multilib\]/s/^#//" "$pacmanPath"
    sudo sed -i "${includeLine}s/^#//" "$pacmanPath"
    sudo sed -i '/^Color/a ILoveCandy' "$pacmanPath"
    sudo pacman -Syyu --noconfirm
}

function InstallPacmanPackages() {
    local packageList=("$@")

    for package in "${packageList[@]}"; do
        if ! pacman -Q $package &> /dev/null; then
            sudo pacman -S --noconfirm "$package"
        else
            echo "Package $package already installed. Skipping task..."
        fi
    done
}

function GrubConfig() {
    local lines="$1"
    if grub-install --version >&- && [ -f /boot/grub/grub.cfg ]; then
        sudo mv /etc/default/grub /etc/default/grub.bak
        if sudo echo "${lines//  /}" >> /etc/default/grub; then
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
}

function Plymouth() {
    sed -i '/^HOOKS/ s/udev /udev plymouth /' /etc/mkinitcpio.conf
    mkinitcpio -p linux-lts
    plymouth-set-default-theme -R bgrt
    sed -i '/^Theme/a ShowDelay\=0' /etc/plymouth/plymouthd.conf
    sed -i '/message/d' /etc/grub.d/10_linux
}

function InstallAURPackages() {
    for i in "${AUR_PKG[@]}"; do
    git clone https://aur.archlinux.org/"$i".git
    cd "$i" || exit
    makepkg -si --noconfirm
    cd .. 
    rm -rf "$i"
    done
}