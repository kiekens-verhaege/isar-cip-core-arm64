#!/bin/bash

mkdir -p qemu
cp build/tmp/deploy/images/qemu-arm64/firmware.bin qemu/
cp build/tmp/deploy/images/qemu-arm64/cip-core-image-cip-core-bookworm-qemu-arm64.wic qemu/
