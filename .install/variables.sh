#!/usr/bin/env bash

Reset='\033[0m'
BoldRed='\033[1;31m'
BoldGreen='\033[1;32m'
BoldYellow='\033[1;33m'

GrubCFG='GRUB_DEFAULT=0
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