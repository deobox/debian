#!/bin/bash

dpkg -s live-build &>/dev/null || apt install -f live-build;

for dist in stable sid ; do
  pushd $dist
  lb clean
  ./config.sh
  lb build
  popd

done
