#!/bin/sh

lb config \
  --apt apt \
  --apt-indices false \
  --apt-options "--yes -oAcquire::Languages=none -oAcquire::PDiffs=false -oAPT::Install-Recommends=0 -oAPT::Install-Suggests=0 -oDpkg::Progress-Fancy=true" \
  --apt-recommends false \
  --apt-source-archives false \
  -a amd64 \
  -b iso-hybrid \
  --bootappend-live "boot=live components loglevel=3" \
  --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal" \
  --bootloaders "syslinux" \
  --zsync false \
  --debootstrap-options "--variant=minbase" \
  -d buster \
  --iso-volume "buster" \
  --archive-areas "main contrib non-free" \
  --firmware-binary false \
  --firmware-chroot false

lb build;

if [ ! -d "/srv/tftp/deobian" ]; then mkdir -p "/srv/tftp/deobian"; fi
if [ -f "binary/live/vmlinuz" ]; then cp -f "binary/live/vmlinuz" "/srv/tftp/deobian/vmlinuz"; fi
if [ -f "binary/live/initrd.img" ]; then cp -f "binary/live/initrd.img" "/srv/tftp/deobian/initrd.img"; fi
if [ ! -d "/var/www/html/deobian" ]; then mkdir -p "/var/www/html/deobian"; fi
if [ -f "binary/live/filesystem.squashfs" ]; then cp -f "binary/live/filesystem.squashfs" "/var/www/html/deobian/filesystem.squashfs"; fi

outfile="/var/www/html/deobian/deobian.iso";
if [ -f "live-image-amd64.hybrid.iso" ]; then mv -f "live-image-amd64.hybrid.iso" "${outfile}"; fi
if [ -f "${outfile}" ]; then chmod 0644 "${outfile}"; lb clean --all; lb clean --cache; fi
