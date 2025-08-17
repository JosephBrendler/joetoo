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
	meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
	+armbian_kernel +dtbo joetoo-fw
"

# require exactly one kind of board to be selected
REQUIRED_USE="
        ^^ ( meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc )
"

RESTRICT="mirror binchecks strip"

S="${WORKDIR}/"


# armbian kernel and dtbos, if requested, will be installed by sys-kernel package
# Note: starting with 0.0.4, the armbian uefi-arm64 kernel is used for meson-sm1-s905d3-libretech-cc
# it should work for these others, too, since they are also uefi enabled
BDEPEND="
	armbian_kernel? (
		meson-gxl-s905x-libretech-cc-v2?  ( sys-kernel/linux-meson-gxl-s905x-libretech-cc-v2_armbian_kernel_image[dtbo=] )
		meson-sm1-s905d3-libretech-cc?  ( sys-kernel/linux-arm64-uefi_armbian_kernel_image[dtbo=] )
		meson-g12b-a311d-libretech-cc?  ( sys-kernel/linux-meson-g12b-a311d-libretech-cc_armbian_kernel_image[dtbo=] )
	)
"

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
	if use meson-gxl-s905x-libretech-cc-v2 ; then export board="meson-gxl-s905x-libretech-cc-v2"
	elif use meson-sm1-s905d3-libretech-cc ; then export board="meson-sm1-s905d3-libretech-cc"
	elif use meson-g12b-a311d-libretech-cc ; then export board="meson-g12b-a311d-libretech-cc"
	fi
	einfo "Assigned board: ${board}"

	einfo "S and D are used; here they are ..."
	einfo "  S=${S}"
	einfo "  D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "  PN=${PN}"
	einfo "  PV=${PV}"
	einfo "  PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"
	einfo "board=${board}"
}

src_install() {
	# install u-boot_reflash_resources
	if use joetoo-fw ; then
		einfo "Installing (ins) u-boot_reflash_resources for ${board} into /boot/..."
		insinto /boot
			doins -r ${FILESDIR}/${board}/u-boot_reflash_resources
			elog "installed u-boot_reflash_resources"
		einfo "Installing (newenvd) config_protect_u-boot_reflash_resources..."
		newenvd "${FILESDIR}/config_protect_u-boot_reflash_resources" "99${PN}"
		elog "installed config_protect_u-boot_reflash_resources"
	else
		elog "USE joetoo-fw not set; not installing"
	fi
}

pkg_postinst() {
	elog "Installed ${PN}"
	elog "Please read provided instructions regarding how to reflash u-boot"
	elog ""
	elog "ver 0.0.1 was the initial ebuild, supporting meson-gxl-s905x-libretech-cc-v2"
	elog " 0.0.2 adds support for meson-g12b-a311d-libretech-cc (alta)"
	elog " 0.0.3 adds support for meson-sm1-s905d3-libretech-cc (solitude)"
	elog " 0.0.4 introduces the armbian uefi-arm64 kernel for solitude"
	elog " 0.0.4 also adds USE joetoo-fw (and makes it optional)"
	elog ""
	elog "****************************************************************************"
	elog "*** CAUTION: only use u-boot-reflash toosl if really needed, or to make  ***"
	elog "***    new boot media for a NEW system                                   ***"
	elog "***    Exercise caution - improper use could render system inoperable    ***"
	elog "****************************************************************************"
	elog ""
	elog "Please inspect your /boot setup and inspect in particular--"
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
