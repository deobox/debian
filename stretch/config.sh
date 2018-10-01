#!/bin/sh

lb config \
  --apt apt \
  --apt-indices false \
  --apt-options "--yes -oAcquire::Languages=none -oAcquire::PDiffs=false -oAPT::Install-Recommends=0 -oAPT::Install-Suggests=0 -oDpkg::Progress-Fancy=true" \
  --apt-recommends false \
  --apt-source-archives false \
  -a amd64 \
  -b iso-hybrid \
  --bootappend-live "boot=live components loglevel=3 net.ifnames=0" \
  --bootappend-live-failsafe "boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal net.ifnames=0" \
  --bootloaders "syslinux" \
  --zsync false \
  --debootstrap-options "--variant=minbase --no-merged-usr" \
  -d stretch \
  --iso-volume "stretch" \
  --archive-areas "main contrib non-free" \
  --firmware-binary false \
  --firmware-chroot false
