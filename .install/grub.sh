#!/usr/bin/env bash

Lines='GRUB_DEFAULT=0
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

function GrubConfig() {
    if grub-install --version >&- && [ -f /boot/grub/grub.cfg ]; then
        mv /etc/default/grub /etc/default/grub.bak

        if echo "${Lines//  /}" >> grub; then
            grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
}