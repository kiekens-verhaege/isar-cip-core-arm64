#!/bin/bash

QEMU=qemu-system-aarch64
QEMU_ARGS=" \
	-m 1G \
	-serial mon:stdio \
	-netdev user,id=net,hostfwd=tcp:127.0.0.1:22222-:22 \
    -cpu cortex-a57 \
    -smp 4 \
    -machine virt \
    -device virtio-serial-device \
    -device virtconsole,chardev=con -chardev vc,id=con \
    -device virtio-blk-device,drive=disk \
    -device virtio-net-device,netdev=net"

U_BOOT_BIN="qemu/firmware.bin"
WIC_FILE="qemu/cip-core-image-cip-core-bookworm-qemu-arm64.wic"

${QEMU} \
    -drive file=${WIC_FILE},discard=unmap,if=none,id=disk,format=raw \
    -bios ${U_BOOT_BIN} \
    ${QEMU_ARGS} "$@"
