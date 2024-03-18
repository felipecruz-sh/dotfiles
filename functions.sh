#!/usr/bin/env bash

NvidiaDetect()
{
    if [ "$(lspci -k | grep -A 2 -E "(VGA|3D)" | grep -c nvidia)" -gt 0 ]
    then
        return 0
    else
        return 1
    fi
}

PacmanConf()
{
    PacmanDir="/etc/pacman.conf"
    MultilibLine=$(grep -n "\\[#multilib\\]" $PacmanDir | cut -d: -f1)
    IncludeLine=$((MultilibLine + 1))

    sed -i "/^#Color\|^#ParallelDownloads\|^#VerbosePkgLists\|^#\[multilib\]/s/^#//" $PacmanDir
    sed -i "$IncludeLine s/#//" $PacmanDir
    sed -i '/^Color/a ILoveCandy' $PacmanDir
}


GrubConfig()
{   
mv /etc/default/grub /etc/default/grub.bak

cat > /etc/default/grub << EOF
GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMOUT=0
GRUB_DISTRIBUTOR="Arch"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""
#GRUB_DISABLE_OS_PROBER=false
#GRUB_TERMINAL=console
#GRUB_GFXMODE=auto
#GRUB_DISABLE_LINUX_UUID=true
#GRUB_DISABLE_RECOVERY="true"
#GRUB_INIT_TUNE="480 440 1"
EOF

grub-mkconfig -o /boot/grub/grbu.cfg
}

BootSplashScreen()
{
    sed -i '/HOOKS=/ s/udev /udev plymouth ' /etc/mkinitcpio.conf
    sed -i '/^Theme/a ShowDelay=0' /etc/plymouth/plymouthd.conf
    mkinitcpio -p linux-lts
    plymouth-set-default-theme -R bgrt

    sed -i '/message/d' /etc/grub.d/10_linux
}