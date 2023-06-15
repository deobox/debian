#!/bin/bash

if [ $# -lt 1 ] ; then
  echo "usage: $0 /dev/sdX"
  exit
fi

if [ ! -e "$1" ] ; then
  echo "$1 is not accepted"
  exit
fi

DEVICE=$1

apt-get install syslinux-common syslinux gdisk parted systemd-boot

rm -rf build

mkdir -p build/boot
wget http://boot.test.net.in/ipxe.efi -O build/boot/ipxe.efi
wget http://boot.test.net.in/ipxe.lkrn -O build/boot/ipxe.lkrn

mkdir -p build/boot/modules/bios
cp /usr/lib/syslinux/modules/bios/{libutil,menu}.c32 build/boot/modules/bios

mkdir -p build/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi build/EFI/BOOT/bootx64.efi

mkdir -p build/live/stable
wget http://boot.test.net.in/live/bullseye/filesystem.squashfs -O build/live/stable/filesystem.squashfs
wget http://boot.test.net.in/live/bullseye/initrd.img -O build/live/stable/initrd.img
wget http://boot.test.net.in/live/bullseye/vmlinuz -O build/live/stable/vmlinuz

mkdir -p build/live/sid
wget http://boot.test.net.in/live/sid/filesystem.squashfs -O build/live/sid/filesystem.squashfs
wget http://boot.test.net.in/live/sid/initrd.img -O build/live/sid/initrd.img
wget http://boot.test.net.in/live/sid/vmlinuz -O build/live/sid/vmlinuz

cat > build/syslinux.cfg << _EOF_
PATH /boot/modules/bios
DEFAULT stable 
PROMPT 0
TIMEOUT 10
ONTIMEOUT live

UI menu.c32

MENU TITLE BOOT MENU
MENU VSHIFT 5
MENU ROWS 10
MENU TABMSGROW 15
MENU TABMSG Press ENTER to boot or TAB to edit a menu entry
MENU HELPMSGROW 17
MENU HELPMSGENDROW -3
MENU AUTOBOOT BIOS default device boot in # second{,s}...
MENU MARGIN 15

MENU COLOR screen 0 #80ffffff #00000000 std
MENU COLOR border 0 #ffffffff #ee000000 std
MENU COLOR title  0 #ffff3f7f #ee000000 std
MENU COLOR unsel  0 #ffffffff #ee000000 std

LABEL stable 
  MENU LABEL Stable
  MENU default
  KERNEL /live/stable/vmlinuz
  INITRD /live/stable/initrd.img
  APPEND boot=live components loglevel=3 live-media-path=/live/stable toram

LABEL sid
  MENU LABEL Sid
  MENU default
  KERNEL /live/sid/vmlinuz
  INITRD /live/sid/initrd.img
  APPEND boot=live components loglevel=3 live-media-path=/live/sid toram

LABEL pxe
  MENU LABEL iPxe 
  KERNEL /boot/ipxe.lkrn
  APPEND dhcp && chain http://boot.test.net.in
_EOF_

mkdir -p build/loader

cat > build/loader/loader.conf << _EOF_
default       01-stable.conf
timeout       10
console-mode  keep
editor        yes
auto-entries  yes
auto-firmware yes
_EOF_

mkdir -p build/loader/entries

cat > build/loader/entries/01-stable.conf << _EOF_
title      Stable 
options    boot=live components loglevel=3 net.ifnames=0 live-media-path=/live/stable toram
linux      /live/stable/vmlinuz
initrd     /live/stable/initrd.img
_EOF_

cat > build/loader/entries/02-sid.conf << _EOF_
title      Sid 
options    boot=live components loglevel=3 net.ifnames=0 live-media-path=/live/sid toram
linux      /live/sid/vmlinuz
initrd     /live/sid/initrd.img
_EOF_

cat > build/loader/entries/03-pxe.conf << _EOF_
title    iPxe
linux    /boot/ipxe.efi
options  dhcp && chain http://boot.test.net.in
_EOF_

sgdisk -g -o ${DEVICE}
sgdisk -o ${DEVICE}
sgdisk -a 1 -n 1:34:1G -c 1:esp -t 1:ef00 -A 1:set:2 -p ${DEVICE}
partprobe ${DEVICE}

sleep 2
mkfs.vfat ${DEVICE}1

dd if=/usr/lib/syslinux/mbr/gptmbr.bin of=${DEVICE} bs=440 count=1

sleep 5
syslinux -i ${DEVICE}1

mkdir -p mount
mount ${DEVICE}1 mount/

cp -a build/* mount/
sync
umount mount/

