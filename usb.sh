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

mkdir -p build/live
wget http://boot.test.net.in/live/bullseye/filesystem.squashfs -O build/live/filesystem.squashfs
wget http://boot.test.net.in/live/bullseye/initrd.img -O build/live/initrd.img
wget http://boot.test.net.in/live/bullseye/vmlinuz -O build/live/vmlinuz

mkdir -p build/boot
wget http://boot.test.net.in/snp.efi -O build/boot/snp.efi
wget http://boot.test.net.in/ipxe.efi -O build/boot/ipxe.efi
wget http://boot.test.net.in/ipxe.lkrn -O build/boot/ipxe.lkrn

mkdir -p build/boot/modules/bios
cp /usr/lib/syslinux/modules/bios/{libutil,menu}.c32 build/boot/modules/bios

mkdir -p build/EFI/BOOT
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi build/EFI/BOOT/bootx64.efi

cat > build/syslinux.cfg << _EOF_
PATH /boot/modules/bios
DEFAULT live
PROMPT 0
TIMEOUT 600
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

LABEL live
  MENU LABEL Live (amd64)
  MENU default
  KERNEL /live/vmlinuz
  INITRD /live/initrd.img
  APPEND boot=live components loglevel=3 net.ifnames=0

LABEL net
  MENU LABEL Boot from test.net.in
  KERNEL /boot/ipxe.lkrn
  APPEND dhcp && chain http://boot.test.net.in
_EOF_

mkdir -p build/loader

cat > build/loader/loader.conf << _EOF_
default       01-live.conf
timeout       5 
console-mode  keep
editor        yes
auto-entries  yes
auto-firmware yes
_EOF_

mkdir -p build/loader/entries

cat > build/loader/entries/01-live.conf << _EOF_
title    Live
linux    /live/vmlinuz
initrd   /live/initrd.img
options  boot=live components loglevel=3 net.ifnames=0
_EOF_

cat > build/loader/entries/02-ipxe.conf << _EOF_
title    Boot IPXE EFI from test.net.in
linux    /boot/ipxe.efi
options  dhcp && chain http://boot.test.net.in
_EOF_

cat > build/loader/entries/03-snp.conf << _EOF_
title    Boot SNP EFI from test.net.in
linux    /boot/snp.efi
options  dhcp && chain http://boot.test.net.in
_EOF_

sgdisk -g -o ${DEVICE}
sgdisk -o ${DEVICE}
sgdisk -a 1 -n 1:34: -c 1:esp -t 1:ef00 -A 1:set:2 -p ${DEVICE}
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
