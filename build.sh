#!/bin/sh

pushd buster
lb clean
./config.sh
lb build
popd

pushd stretch
lb clean
./config.sh
lb build
popd

mkdir -p /var/www/boot.test.net.in/live/buster/
cp buster/binary/live/vmlinuz /var/www/boot.test.net.in/live/buster/
cp buster/binary/live/initrd.img /var/www/boot.test.net.in/live/buster/
cp buster/binary/live/filesystem.squashfs /var/www/boot.test.net.in/live/buster/
cp buster/live-image-amd64.hybrid.iso /var/www/boot.test.net.in/live/buster/

mkdir -p /var/www/boot.test.net.in/live/stretch/
cp stretch/binary/live/vmlinuz /var/www/boot.test.net.in/live/stretch/
cp stretch/binary/live/initrd.img /var/www/boot.test.net.in/live/stretch/
cp stretch/binary/live/filesystem.squashfs /var/www/boot.test.net.in/live/stretch/
cp stretch/live-image-amd64.hybrid.iso /var/www/boot.test.net.in/live/stretch/
