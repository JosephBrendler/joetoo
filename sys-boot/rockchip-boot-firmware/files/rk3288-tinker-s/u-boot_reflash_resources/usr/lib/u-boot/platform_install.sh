DIR=/usr/lib/linux-u-boot-current-tinkerboard
write_uboot_platform () 
{ 
    UBOOT_SRC="u-boot-rockchip-with-spl.bin";
    dd if=/dev/zero of=$2 bs=32k count=63 seek=1 status=noxfer > /dev/null 2>&1;
    dd if=$1/$UBOOT_SRC of=$2 bs=32k seek=1 conv=notrunc
}


