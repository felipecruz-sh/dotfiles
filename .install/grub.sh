#!/usr/bin/env bash

GrubConfig() {   
mv /etc/default/grub /etc/default/grub.bak

cat > /etc/default/grub << EOF
GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMOUT=0
GRUB_DISTRIBUTOR="Arch"
GRUB_CMDLINE_LINUX_DEFAULT="quiet vga=current splash"
GRUB_CMDLINE_LINUX=""
#GRUB_DISABLE_OS_PROBER=false
#GRUB_TERMINAL=console
#GRUB_GFXMODE=auto
#GRUB_DISABLE_LINUX_UUID=true
#GRUB_DISABLE_RECOVERY="true"
#GRUB_INIT_TUNE="480 440 1"
EOF

grub-mkconfig -o /boot/grub/grub.cfg
}