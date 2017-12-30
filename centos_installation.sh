#!/bin/bash
# A script to build up a basic environment for me.
#
# Author: thorgeir <thorgeirsigurd@GMAIL.com>

# Notes
#
# lightdm
#   In the lightdm login session, remember to choose
#   the i3 startup session in the right upper corner.
#
# TODO Create a argument parser to be able to choose what to isntall.
#
set -o xtrace  # Print every command out to stdout.
set -o errexit # Exit immediately if a command exits with non-zero status.

#
# Initialize directories
#
mkdir ~/github
mkdir ~/github/thorgeir
mkdir ~/Downloads
mkdir ~/notes
mkdir ~/Pictures
mkdir ~/Pictures/wallpapers
mkdir ~/Pictures/display_manager

sudo chown -R thorgeir:thorgeir ~/github/

#
# Clone repositories
#
git clone https://github.com/thorgeir93/dotfiles.git ~/github/thorgeir/
git clone https://github.com/thorgeir93/i3wm-config-thorgeir ~/github/thorgeir/

# Link config files
#
ln --symbolic ~/github/thorgeir/dotfiles/.bashrc        ~/.bashrc
ln --symbolic ~/github/thorgeir/dotfiles/.vimrc         ~/.vimrc
ln --symbolic ~/github/thorgeir/dotfiles/.Xdefaults     ~/.Xdefaults
ln --symbolic ~/github/thorgeir/dotfiles/.aliases       ~/.aliases
ln --symbolic ~/github/thorgeir/dotfiles/.speedswapper  ~/.speedswapper

ln --symbolic ~/github/thorgeir/i3wm-config-thorgeir ~/.config/i3

#
# YUM Install
#
sudo yum --quiet -y install gcc
sudo yum --quiet -y install vim
sudo yum --quiet -y install rxvt-unicode
sudo yum --quiet -y install htop
sudo yum --quiet -y install openvpn
sudo yum --quiet -y install tigervnc
sudo yum --quiet -y install net-tools
sudo yum --quiet -y install xf86vmode
sudo yum --quiet -y install python
sudo yum --quiet -y install python34
sudo yum --quiet -y install python34-pip
sudo yum --quiet -y install python-devel
sudo yum --quiet -y install python34-devel
sudo yum --quiet -y install python-psutil
sudo yum --quiet -y install py3status

sudo yum -y install libinput
sudo yum -y install libinput-devel
sudo yum -y install xorg-x11-drv-libinput
sudo yum -y install xorg-x11-drv-libinput-devel

# Install missing -devel packages.
# (to install xcalib)
sudo yum -y install libXxf86vm-devel
sudo yum -y install libXrandr-devel

#
# Install from source
#
# TODO xcalib

#
# PIP install
#
sudo pip3 install i3pystatus
sudo pip3 install psutil
sudo pip3 install netifaces
sudo pip3 install colour 
sudo pip3 install ipython

sudo pip2 install ipython

#
# Install xcalib
# 
# This tool will make it avialable to 
# invert the colors in the scrren.

# Get the source code and install it.
cd ~/github/
git clone https://github.com/OpenICC/xcalib.git
cd ./xcalib/
make xcalib


# May have to execute these statements.
#```
#sudo rm /bin/xalib
#sudo ln -s /home/thorgeir/github/xcalib/xcalib /bin/xcalib
#sudo chmod 755 /bin/xcalib
#```

# I3LOCK
Sudo yum install -y i3lock
# To get the `image` command line tool.
sudo yum install -y ImageMagick 


#
# SCRIPTS THAT MIGHT BRAKES
# -------------------------
#
# Modify lightdm (display manager)
#
# Get the Cyren logo.
cd ~/Pictures/display_manager/
wget http://www.l8solutions.co.uk/media/wysiwyg/CYREN-logo-1C.png
mv CYREN-logo-1C.png cyren.png

# 
# Setup ethernet network, follow:
# lintut.com/how-to-setup-network-after-rhelcentos-7-minimal-installation/

# Install scrot (screenshot utils).
#
function install_scrot () {
    pushd ~/Downloads
    wget http://packages.psychotic.ninja/7/base/x86_64/RPMS/psychotic-release-1.0.0-1.el7.psychotic.noarch.rpm
    rpm -Uvh psychotic-release*rpm
    yum --enablerepo=psychotic install scrot
    popd
}

# Install st (Simple Terminal)
#
function install_st_terminal () {
    # Notes, Edit the config.h to change the configs.
    # To make the config have affect run `make clean install`.

    #requirements
    sudo yum install libXft-devel

    pushd ~/Downloads
    wget https://dl.suckless.org/st/st-0.7.tar.gz
    tar -xvf st-0.7.tar.gz
    cd st-0.7

    # Edit config.mk to mactch my local setup (centos). 
    sed 's|^X11INC.*|X11INC = /usr/include/X11|g' ./config.mk
    sed 's|^X11LIB.*|X11LIB = /usr/lib64/X11|g' ./config.mk

    make clean install
    popd
}



#
# BACKLIGHT CONFIGS
#
# Install xbacklight
# Add nux-desktop repo to yum.
#sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
#sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
# The repo should be in the repo list
#yum repolist
#sudo yum install xbacklight

# (from: https://askubuntu.com/questions/715306)
# Find the path
# sudo find /sys/ -type f -iname '*brightness*'
# sudo ln -s /sys/THE/PATH/intel_backlight  /sys/class/backlight
#echo 'Section "Device"
#Identifier  "Card0"
#Driver      "intel"
#Option      "Backlight"  "NAME OF THE FOLDER"
#EndSection' >> /etc/X11/xorg.conf


#
# Extra information
#

#### Mouse settings
#When everything is in order, this settings is applied.
#```sh
#[thorgeir@SMYRILL ~]$ xinput --list
#⎡ Virtual core pointer                          id=2    [master pointer  (3)]
#⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
#⎜   ↳ SynPS/2 Synaptics TouchPad                id=11   [slave  pointer  (2)]
#⎜   ↳ TPPS/2 IBM TrackPoint                     id=12   [slave  pointer  (2)]
#⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
#    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
#    ↳ Power Button                              id=6    [slave  keyboard (3)]
#    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
#    ↳ Sleep Button                              id=8    [slave  keyboard (3)]
#    ↳ Integrated Camera                         id=9    [slave  keyboard (3)]
#    ↳ AT Translated Set 2 keyboard              id=10   [slave  keyboard (3)]
#```
