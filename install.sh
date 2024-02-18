#!/usr/bin/env bash


# ==================== VARIABLES ==================== #

AUR_DIR="$HOME"/Downloads/Repos/AUR

ARCH_PKG=(
    linux-headers
    base-devel
    git
    ly
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
    thunar
    btop
    neofetch
    zsh
    firefox
    network-manager-applet
    polkit-gnome
    flameshot
    rofi
    steam
    discord
    bitwarden
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
)

AUR_PKG=(
    nwg-look
    swaync
    swww
)

# ==================== VARIABLES ==================== #

# ==================== BEGIN ==================== #

sudo pacman -Syyu --noconfirm

sudo rm /etc/pacman.conf && sudo cp Config/.config/pacman/pacman.conf /etc/pacman.conf
sudo mkdir /etc/ly && sudo cp ../Config/.config/ly/config.ini /etc/ly/config.ini 


for i in "${ARCH_PKG[@]}"; do
    sudo pacman -S --noconfirm "$i"
done

mkdir -p "$AUR_DIR"
for i in "${AUR_PKG[@]}"; do
    git clone https://aur.archlinux.org/"$i".git
    cd "$i" || exit
    makepkg -si --noconfirm
    cd .. 
    rm -rf "$i"
done

# ==================== END ==================== #