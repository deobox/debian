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
  --bootloader "syslinux" \
  --debootstrap-options "--variant=minbase" \
  -d bullseye \
  --iso-volume "deobian" \
  --archive-areas "main contrib non-free" \
  --firmware-binary false \
  --firmware-chroot false 
