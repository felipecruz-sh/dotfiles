#!/usr/bin/env bash

Reset='\033[0m'
BoldRed='\033[1;31m'
BoldGreen='\033[1;32m'
BoldYellow='\033[1;33m'

PacmanPackages=(
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