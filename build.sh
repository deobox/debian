#!/bin/sh

for dist in buster sid ; do
  pushd $dist
  lb clean
  ./config.sh
  lb build
  popd

done
