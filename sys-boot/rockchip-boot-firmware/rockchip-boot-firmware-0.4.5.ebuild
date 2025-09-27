# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY
# installs u-boot files from ebuild's ${FILESDIR}
# if selected by USE armbian_kernel, depends on sys-kernel package to install kernel and dtb/overlays

EAPI=8

DESCRIPTION="Rockchip bootloader firmware for supported boards"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
#SRC_URI=""

LICENSE="GPL-2 Rockchip"
SLOT="0"
KEYWORDS="~arm ~arm64"

IUSE="
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-rock-4se rk3399-tinker-2
	rk3588-rock-5b rk3588-radxa-rock-5b+
	rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	+armbian_kernel +dtbo
"

# require exactly one kind of board to be selected
REQUIRED_USE="
        ^^ (
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-rock-4se rk3399-tinker-2
	rk3588-rock-5b rk3588-radxa-rock-5b+
	rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	)
"

RESTRICT="mirror binchecks strip"

S="${WORKDIR}/"


# armbian kernel and dtbos, if requested, will be installed by sys-kernel package
# start incorporating new kernel-build from .img files 8/30/25 - w rock 5c
BDEPEND="
	armbian_kernel? (
		rk3288-tinker-s?        ( sys-kernel/linux-rk3288-tinker-s_armbian_kernel_image[dtbo=] )
		rk3399-rock-pi-4c-plus? ( sys-kernel/linux-rk3399-rock-pi-4c-plus_armbian_kernel_image[dtbo=] )
		rk3399-rock-4se?        ( sys-kernel/linux_arm64_rk3399-rock-4se_armbian_kernel_image[dtbo=] )
		rk3399-tinker-2?        ( sys-kernel/linux-rk3399-tinker-2_armbian_kernel_image[dtbo=] )
		rk3588-rock-5b?         ( sys-kernel/linux-rk3588-rock-5b_armbian_kernel_image[dtbo=] )
		rk3588-radxa-rock-5b+?  ( sys-kernel/linux_arm64_rk3588-radxa-rock-5b+_armbian_kernel_image[dtbo=] )
		rk3588s-orangepi-5?     ( sys-kernel/linux-rk3588s-orangepi-5_armbian_kernel_image[dtbo=] )
		rk3588s-orangepi-5b?    ( sys-kernel/linux_arm64_rk3588s-orangepi-5b_armbian_kernel_image[dtbo=] )
		rk3588s-rock-5c?        ( sys-kernel/linux_arm64_rk3588s-rock-5c_armbian_kernel_image[dtbo=] )
	)
"
# (old)		rk3588s-rock-5c?        ( sys-kernel/linux-rk3588s-rock-5c_armbian_kernel_image[dtbo=] )
# (new)		rk3588s-rock-5c?        ( sys-kernel/linux_arm64_rk3588s-rock-5c_armbian_kernel_image[dtbo=] )

RDEPEND="
	!sys-boot/raspberrypi-firmware
	${BDEPEND}
"

pkg_setup() {
	# if /boot is on a separate block device, and it is not mounted, try to mount it
	if grep -v '^#' /etc/fstab | grep boot >/dev/null 2>&1  && \
		! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1
	then
		elog "${ROOT%/}/boot is not mounted, trying to mount it now..."
		! $(mount /boot) && \
			die "Failed to mount /boot" || \
		elog "Succeeded in mounting /boot ; continuing..."
	else
		elog "Verified /boot is mounted ; continuing..."
	fi

	# for sbc systems we need to know which board we are using
	if use rk3288-tinker-s ; then export board="rk3288-tinker-s"
	elif use rk3399-rock-pi-4c-plus ; then export board="rk3399-rock-pi-4c-plus"
	elif use rk3399-rock-4se ; then export board="rk3399-rock-4se"
	elif use rk3399-tinker-2; then export board="rk3399-tinker-2"
	elif use rk3588-rock-5b; then export board="rk3588-rock-5b"
	elif use rk3588-radxa-rock-5b+; then export board="rk3588-radxa-rock-5b+"
	elif use rk3588s-orangepi-5; then export board="rk3588s-orangepi-5"
	elif use rk3588s-orangepi-5b; then export board="rk3588s-orangepi-5b"
	elif use rk3588s-rock-5c; then export board="rk3588s-rock-5c"
	else export board=""
	fi
	einfo "Assigned board: ${board}"

	einfo "S and D are used; here they are ..."
	einfo "  S=${S}"
	einfo "  D=${D}"
	einfo "P=${P}"
	einfo "  PN=${PN}"
	einfo "  PV=${PV}"
	einfo "  PVR=${PVR}"
	einfo "BDEPEND=${BDEPEND}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "board=${board}"
}

src_install() {
	# install u-boot_reflash_resources
	einfo "Installing (ins) u-boot_reflash_resources for ${board} into /boot/..."
	insinto /boot
		doins -r ${FILESDIR}/${board}/u-boot_reflash_resources
		elog "installed u-boot_reflash_resources"
	einfo "Installing (newenvd) config_protect_u-boot_reflash_resources..."
	newenvd "${FILESDIR}/config_protect_u-boot_reflash_resources" "99${PN}"
	elog "installed config_protect_u-boot_reflash_resources"

	# if selected by use flag, install kernel (now done by dependency on sys-kernel package above)
}

pkg_postinst() {
	elog "Installed ${PN}"
	elog "Please read provided instructions regarding how to reflash u-boot"
	elog ""
	elog "ver 0.0.1 was the initial ebuild"
	elog " 0.0.2 provides actual armbian-build u-boot reflash resources for each board"
	elog " 0.1.0 delivers armbian-build kernel, dtbs, overlays, if selected by use flag"
	elog " 0.2.0 installs only u-boot; moves kernel/dtbo to versioned sys-kernel package"
	elog " 0.2.1/2 adds/updates support for Rock 5c (rk3588s-rock-5c)"
	elog " 0.3.0 is a version bump/bugfix that adds support for Rock 5b (rk3588-rock-5b)"
	elog " 0.4.0 adds resources and a script for flashing rock-5b spi_loader images"
	elog " 0.4.1 provide refinements and bugfixes"
	elog " 0.4.2 adds rk3588-radxa-rock-5b+ and rk3588s-orangepi-5b"
	elog " 0.4.3 adds u-boot reflash resources for rk3588-radxa-rock-5b+"
	elog " -r1 documents verification of u-boot reflash procedure for rk3588-radxa-rock-5b+"
	elog " 0.4.4 adds rk3399-rock-4se"
	elog " 0.4.5 updates u-boot reflash for rk3399-rock-4se and rk3588s-orangepi-5b"
	elog ""
	elog "****************************************************************************"
	elog "*** CAUTION: only use u-boot-reflash tools if really needed, or to make  ***"
	elog "***    new boot media for a NEW system                                   ***"
	elog "***    Exercise caution - improper use could render system inoperable    ***"
	elog "****************************************************************************"
	elog ""
	elog "Please inspect your /boot setup and also validate files installed by"
	elog "  sys-boot/sbc-boot-config ; in particular verify the following --"
	elog "  /boot/joetooEnv.txt -- "
        elog "      dtb_prefix       (path to .dtb file, rel. to /boot/ [or link to it])"
        elog "      fdtfile          (name of .dtb file)"
        elog "      overlay_prefix   (string that begins relevant overlay filenames)"
        elog "      overlays         (list of overlay filenames to load [minus prefix])"
        elog "      imagefile        (name of kernel image file to load [or link to it])"
        elog "      initrdfile       (name of initramfs file to load [or link to it])"
        elog "      rootdev          (path, UUID, or PARTUUID identifying root device)"
        elog "      rootfstype       (normally ext4)"
	elog "Verify that these settings match the /boot file structure and vice versa ..."
	elog ""
	elog "Thanks for using ${PN}"
}
