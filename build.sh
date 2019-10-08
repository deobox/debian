#!/bin/sh

pushd buster
lb clean
./config.sh
lb build
popd

pushd bullseye
lb clean
./config.sh
lb build
popd

mkdir -p /var/www/boot.test.net.in/live/buster/
cp buster/binary/live/vmlinuz /var/www/boot.test.net.in/live/buster/
cp buster/binary/live/initrd.img /var/www/boot.test.net.in/live/buster/
cp buster/binary/live/filesystem.squashfs /var/www/boot.test.net.in/live/buster/
cp buster/live-image-amd64.hybrid.iso /var/www/boot.test.net.in/live/buster/

mkdir -p /var/www/boot.test.net.in/live/bullseye/
cp bullseye/binary/live/vmlinuz /var/www/boot.test.net.in/live/bullseye/
cp bullseye/binary/live/initrd.img /var/www/boot.test.net.in/live/bullseye/
cp bullseye/binary/live/filesystem.squashfs /var/www/boot.test.net.in/live/bullseye/
cp bullseye/live-image-amd64.hybrid.iso /var/www/boot.test.net.in/live/bullseye/
