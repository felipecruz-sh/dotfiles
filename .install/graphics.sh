#!/usr/bin/env bash

Intel() {
    sudo pacman -S --noconfirm mesa lib32-mesa lib32-vulkan-intel vulkan-intel xf86-video-intel
}

AMD() {
    sudo pacman -S --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau xf86-video-amdgpu
}

Nvidia() {
    sudo pacman -S --noconfirm nvidia-dkms nvidia-utils

    gcld=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "/etc/default/grub" | cut -d'"' -f2 | sed 's/\b nvidia_drm.modeset=.\b//g')
    sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"${gcld} nvidia_drm.modeset=1\"" /etc/default/grub

    sudo grub-mkconfig -o /boot/grub/grub.cfg

    mkmod=$(grep "^MODULES=" "/etc/mkinitcpio.conf" | cut -d'=' -f2 | sed s/"("// | sed s/")"//)
    sed -i "/^MODULES=/c\MODULES=\(${mkmod} nvidia nvidia_modeset nvidia_uvm nvidia_drm)" /etc/mkinitcpio.conf

    sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

    echo "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf > /dev/null

    cat > /etc/modprobe.d/nvidia.conf << EOF
    options nvidia-drm modeset=1
    options nvidia "NVreg_UsePageAttributeTable=1"
    options nvidia "NVreg_PreserveVideoMemoryAllocations=1"
    options nvidia "NVreg_TemporaryFilePath=/var/temp"
    options nvidia "NVreg_EnableS0ixPowerManagement=1"
EOF
}
