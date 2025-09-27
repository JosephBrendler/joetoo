declare -a UBOOT_TARGET_BINS=('u-boot-rockchip.bin' 'u-boot-tpl.bin' 'u-boot-spl.bin' 'u-boot.itb' 'rkspi_loader.img')
declare UBOOT_TARGET_MAKE='BL31=bl31.elf ROCKCHIP_TPL=/armbian/cache/sources/rkbin-tools/rk33/rk3399_ddr_933MHz_v1.25.bin'
declare UBOOT_TARGET_CONFIG="u-boot-config-target-1"
declare UBOOT_TARGET_DEFCONFIG="u-boot-defconfig-target-1"
