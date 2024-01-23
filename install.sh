#!/usr/bin/env bash


# ==================== VARIABLES ==================== #

AUR_DIR="$HOME"/Downloads/Repos/AUR
CONFIG_DIR="$HOME"/.config/
CONFIG_BKP="$CONFIG_DIR"/config.bak

ARCH_PKG=(
    linux-headers
    base-devel
    git
    ly
    hyprland
    xdg-desktop-portal-hyprland
    pipewire
    wireplumber
    pavucontrol
    kitty
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

DOTFILES=(
    hypr
    kitty
    swww
    waybar
)

# ==================== VARIABLES ==================== #

# ==================== FUNCTIONS ==================== #

nvidia_detect()
{
    if [ "$(lspci -k | grep -A 2 -E "(VGA|3D)" | grep -c nvidia)" -gt 0 ]
    then
        return 0
    else
        return 1
    fi
}

GrubConfig()
{
    if [ "$(bootctl status | awk '{if ($1 == "Product:") print $2}')"  == "GRUB" ]; then
        echo -e "\033[92m[BOOTLOADER]\033[0m: grub detected..."

        if [ ! -f /etc/default/grub.bak ] && [ ! -f /boot/grub/grub.bak ]; then
            echo -e "\033[92m[GRUB]\033[0m: configuring grub..."
            sudo cp /etc/default/grub /etc/default/grub.bak
            sudo cp /boot/grub/grub.cfg /boot/grub/grub.bak

            if nvidia_detect; then
                echo -e "\033[92m[GRUB]\033[0m: nvidia detected, adding nvidia_drm.modeset=1 to boot option..."
                gcld=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" | cut -d'"' -f2 | sed 's/\b nvidia_drm.modeset=.\b//g')
                sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"${gcld} nvidia_drm.modeset=1\"" /etc/default/grub

                sudo grub-mkconfig -o /boot/grub/grub.cfg
            fi
        fi
    fi
}

BkpDotfiles()
{
    mkdir "$CONFIG_BKP"

    for i in "${DOTFILES[@]}"; do
        if [ -d "$CONFIG_DIR"/"$i" ]; then
            cp -r "$CONFIG_DIR"/"$i" "$CONFIG_BKP"
        fi
    done
}

# ==================== FUNCTIONS ==================== #

# ==================== BEGIN ==================== #

sudo pacman -Syyu --noconfirm

sudo rm /etc/pacman.conf && sudo cp Config/.config/pacman/pacman.conf /etc/pacman.conf
sudo mkdir /etc/ly && sudo cp ../Config/.config/ly/config.ini /etc/ly/config.ini 

if nvidia_detect; then
    sudo pacman -S --noconfirm nvidia-dkms nvidia-utils
fi

GrubConfig

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