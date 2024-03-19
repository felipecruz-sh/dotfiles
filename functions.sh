#!/usr/bin/env bash

BootSplashScreen() {
    sed -i '/^HOOKS/ s/udev /udev plymouth /' /etc/mkinitcpio.conf
    mkinitcpio -p linux-lts
    plymouth-set-default-theme -R bgrt
    sed -i '/^Theme/a ShowDelay\=0' /etc/plymouth/plymouthd.conf
    sed -i '/message/d' /etc/grub.d/10_linux
}