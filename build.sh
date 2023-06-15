#!/bin/bash

for dist in stable sid ; do
  pushd $dist
  lb clean
  ./config.sh
  lb build
  popd

done
