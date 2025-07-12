@ECHO OFF

PATH=%PATH%;"%CD%\tools"

fastboot flash bootloader0 u-boot.imx
fastboot reboot-bootloader
ping -n 3 127.0.0.1 >nul

fastboot flash gpt partition-table-8gb.img
fastboot reboot-bootloader
ping -n 3 127.0.0.1 >nul

fastboot erase misc
fastboot flash home home.img
fastboot flash boot boot_arm64.img
fastboot flash rootfs rootfs_arm64.img
fastboot reboot

echo Press any key to exit...
pause >nul
exit
