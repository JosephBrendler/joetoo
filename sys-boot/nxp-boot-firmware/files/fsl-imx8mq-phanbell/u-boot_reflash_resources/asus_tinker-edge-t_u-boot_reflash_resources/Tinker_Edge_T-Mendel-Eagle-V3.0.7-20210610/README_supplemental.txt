Note: I have removed the following really large files from this directory --
  rootfs_arm64.img   -- script would write to root_fs partition (/)
  boot_arm64.img     --	script would write to boot_fs partition (/boot)
  home.img           --	script would write to user (mendel) partition (/home/mendel)
  sdcard_arm64.img   -- complete Mendel system bootable from sdcard

So the flash.sh script won't work -- follow u-boot_reflash_instructions instead


If you really need them, these files can be downloaded at --
    https://tinker-board.asus.com/download-list.html
(select "Tiner Edge T" from drop-down selector and be *patient* - then unzip)
