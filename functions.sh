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


# GRUB
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