These files are required to flash the Mendel Linux OS to an attached Tinker
Edge T board using fastboot.

Note: Do not power the board or connect any cables until instructed to do so.

The factory setting only includes a U-Boot bootloader for the fastboot mode
and does not include a system.

Before you begin the flashing procedure, please ensure of the following:
- The board is completely powered off.
- The boot mode switches are set to eMMC mode.
  (ON: Switch 1; OFF: Switch 2/Switch 3/Switch 4)

1. Connect the USB Type-C cable to the USB Type-C port on the board and your
   host computer.
2. Power on the board and the board should automatically boots into the
   fastboot mode.
3. Make sure the driver is installed if the host computer is equipped with
   Windows.
4. Run the flash.cmd script for Windows or flash.sh for Linux in this
   directory.

To reflash the system image, please launch weston-terminal on the board and
run sudo reboot-bootloader to reboot the board into the fastboot mode.
Then, follow the step 4 above.

If you get unlucky and you can't even boot your board into the fastboot mode,
then you can recover the system by booting into the fastboot mode from an
image on the SD card and then reflash the board from your host computer as
follows.

1. Power off the board and change the boot mode switches to boot from SD card.
   (ON: Switch 1/Switch 3/Switch 4; OFF: Switch 2)
2. Use a program such as balenaEtcher to flash the recovery.img file to your
   microSD card.

   Note: The recovery.img file is just the U-Boot image. Use that to recover a
   failing device by flashing it to an SD card and booting from that.
3. Connect the USB Type-C cable to the USB Type-C port on the board and your
   host computer.
4. Insert the SD card and then power on the board and the board should
   automatically boots into the fastboot mode.
5. Run the flash.cmd script for Windows or flash.sh for Linux in this
   directory.
6. When flashing is complete, your board will reboot. However, because you set
   the boot mode to SD card, you will see the fastboot mode again. So power
   off the board and reset the boot switches to eMMC mode.

* The driver for Windows could installed from Microsoft Update automatically or
  local driver package manually.



