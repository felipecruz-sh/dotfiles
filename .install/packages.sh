#!/usr/bin/env bash

PacmanPackages=(
    linux-headers
    plymouth
    hyprland
    xdg-desktop-portal-hyprland
    pipewire
    pipewire-pulse
    gst-plugin-pipewire
    wireplumber
    pavucontrol
    kitty
    imagemagick
    waybar
    btop
    neofetch
    network-manager-applet
    polkit-gnome
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    base-devel #AUR
    ly #Display Manager
    rofi #App Launcher
)

AUR_PKG=(
    nwg-look
    swaync
    swww
)

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
