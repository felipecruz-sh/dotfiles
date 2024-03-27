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
    local lines='GRUB_DEFAULT=0
	    GRUB_TIMEOUT_STYLE=hidden
	    GRUB_TIMEOUT=0
	    GRUB_DISTRIBUTOR="Arch"
	    GRUB_CMDLINE_LINUX_DEFAULT="quiet vga=current splash"
	    GRUB_CMDLINE_LINUX=""
	    #GRUB_DISABLE_OS_PROBER=false
	    #GRUB_TERMINAL=console
	    #GRUB_GFXMODE=auto
	    #GRUB_DISABLE_LINUX_UUID=true
	    #GRUB_DISABLE_RECOVERY="true"
	    #GRUB_INIT_TUNE="480 440 1"'

    if grub-install --version >&- && [ -f /boot/grub/grub.cfg ]; then
        sudo mv /etc/default/grub /etc/default/grub.bak
        if echo "$lines" | sed 's/^[ \t]*//' | sudo tee -a /etc/default/grub > /dev/null; then
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
}

function Plymouth() {
    sudo sed -i '/^HOOKS/ s/udev /udev plymouth /' /etc/mkinitcpio.conf
    sudo mkinitcpio -p linux-lts
    sudo plymouth-set-default-theme -R bgrt
    sudo sed -i '/^Theme/a ShowDelay\=0' /etc/plymouth/plymouthd.conf
    sudo sed -i '/message/d' /etc/grub.d/10_linux
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