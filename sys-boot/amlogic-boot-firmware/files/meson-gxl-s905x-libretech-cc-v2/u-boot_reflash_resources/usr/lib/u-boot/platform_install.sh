# Armbian u-boot install script for linux-u-boot-sweet-potato-current 2024.04-S2504-P8577-H13e4-V0b69-Bb703-R448a
# This file provides functions for deploying u-boot to a block device.
DIR=/usr/lib/linux-u-boot-current-sweet-potato
write_uboot_platform () 
{ 
    dd if=$1/u-boot.bin of=$2 bs=1 count=442 conv=fsync 2>&1;
    dd if=$1/u-boot.bin of=$2 bs=512 skip=1 seek=1 conv=fsync 2>&1
}


