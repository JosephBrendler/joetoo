# Armbian u-boot install script for linux-u-boot-rock-4se-current 2025.04-S3482-Pec6b-H4003-V9b92-Bb703-R448a
# This file provides functions for deploying u-boot to a block device.
DIR=/usr/lib/linux-u-boot-current-rock-4se
write_uboot_platform () 
{ 
    local logging_prelude="";
    [[ $(type -t run_host_command_logged) == function ]] && logging_prelude="run_host_command_logged";
    if [ -f $1/u-boot-rockchip.bin ]; then
        ${logging_prelude} dd if=$1/u-boot-rockchip.bin of=$2 bs=32k seek=1 conv=notrunc status=none;
    else
        if [ -f $1/rksd_loader.img ]; then
            ${logging_prelude} dd if=$1/rksd_loader.img of=$2 seek=64 conv=notrunc status=none;
        else
            if [[ -f $1/u-boot.itb ]]; then
                ${logging_prelude} dd if=$1/idbloader.img of=$2 seek=64 conv=notrunc status=none;
                ${logging_prelude} dd if=$1/u-boot.itb of=$2 seek=16384 conv=notrunc status=none;
            else
                if [[ -f $1/uboot.img ]]; then
                    ${logging_prelude} dd if=$1/idbloader.bin of=$2 seek=64 conv=notrunc status=none;
                    ${logging_prelude} dd if=$1/uboot.img of=$2 seek=16384 conv=notrunc status=none;
                    ${logging_prelude} dd if=$1/trust.bin of=$2 seek=24576 conv=notrunc status=none;
                else
                    echo "Unsupported u-boot processing configuration!";
                    exit 1;
                fi;
            fi;
        fi;
    fi
}
write_uboot_platform_mtd () 
{ 
    FILES=$(find "$1" -maxdepth 1 -type f -name "rkspi_loader*.img");
    if [ -z "$FILES" ]; then
        echo "No SPI image found.";
        exit 1;
    fi;
    MENU_ITEMS=();
    i=1;
    while IFS= read -r file; do
        filename=$(basename "$file");
        MENU_ITEMS+=("$i" "$filename" "");
        ((i++));
    done <<< "$FILES";
    if [[ $i -eq 2 ]]; then
        dd if=$1/${MENU_ITEMS[1]} of=$2 conv=notrunc status=none > /dev/null 2>&1;
        return;
    fi;
    [[ -f /etc/armbian-release ]] && source /etc/armbian-release;
    backtitle="Armbian for $BOARD_NAME install script, https://www.armbian.com";
    CHOICE=$(dialog --no-collapse --title "armbian-install" --backtitle "$backtitle" --radiolist "Choose SPI image:" 0 56 4 "${MENU_ITEMS[@]}" 3>&1 1>&2 2>&3);
    if [ $? -eq 0 ]; then
        dd if=$1/${MENU_ITEMS[($CHOICE*3)-2]} of=$2 conv=notrunc status=none > /dev/null 2>&1;
    else
        echo "No SPI image chosen.";
        exit 1;
    fi
}
setup_write_uboot_platform () 
{ 
    if grep -q "ubootpart" /proc/cmdline; then
        local tmp part dev;
        tmp=$(cat /proc/cmdline);
        tmp="${tmp##*ubootpart=}";
        tmp="${tmp%% *}";
        [[ -n $tmp ]] && part=$(findfs PARTUUID=$tmp 2> /dev/null);
        [[ -n $part ]] && dev=$(lsblk -n -o PKNAME $part 2> /dev/null);
        [[ -n $dev ]] && DEVICE="/dev/$dev";
    fi
}
