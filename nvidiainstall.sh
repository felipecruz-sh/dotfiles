#!/usr/bin/env bash


# ============================== FUNCTIONS ============================== #

nvidia_detect()
{
    if [ "$(lspci -k | grep -A 2 -E "(VGA|3D)" | grep -c nvidia)" -gt 0 ]
    then
        return 0
    else
        return 1
    fi
}

# ============================== FUNCTIONS ============================== #


# ================================ BEGIN ================================ #

if nvidia_detect; then

    sudo pacman -S --noconfirm nvidia-dkms linux-headers

    echo -e "\033[92mNVIDIA Detected!!!\033[0m"
    sleep 1
    echo -e "\033[92m[GRUB]\033[0m: Adding nvidia_drm.modeset=1 to boot option..."
    gcld=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" | cut -d'"' -f2 | sed 's/\b nvidia_drm.modeset=.\b//g')
    sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"${gcld} nvidia_drm.modeset=1\"" /etc/default/grub

    sudo grub-mkconfig -o /boot/grub/grub.cfg

    echo -e "\033[92m[MODULES]\033[0m: Adding NVIDIA Modules to mkinitcpio.conf..."
    sleep 1
    mkmod=$(grep "^MODULES=" "/etc/mkinitcpio.conf" | cut -d'=' -f2 | sed s/"("// | sed s/")"//)
    sed -i "/^MODULES=/c\MODULES=\(${mkmod} nvidia nvidia_modeset nvidia_uvm nvidia_drm)" /etc/mkinitcpio.conf

    sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

    echo -e "\033[92m[OPTIONS]\033[0m: Adding nvidia-drm modeset=1 to modprobe.d/nvidia.conf..."
    sleep 1
    echo "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf > /dev/null
fi

# ================================ BEGIN ================================ #