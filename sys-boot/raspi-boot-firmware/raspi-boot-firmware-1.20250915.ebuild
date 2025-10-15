# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# License: GPL v3+
# NO WARRANTY
#
# Maintenance notes:
# (1) browse homepage https://github.com/raspberrypi/firmware/ choose branch = stable and look at tags
# (2) select the most recent tag as the new PV --
#     (e.g. 1.20250915 at https://github.com/raspberrypi/firmware/tree/1.20250915)
# (3) copy this ebuild (as is) from previous to this new PV
#     (the ebuild constructs the SRC_URI and WORKDIR from this PV)
# (4) note that if PV does not contain "_p" there is no subsitution performed in either assignment below
#     (thus, SRC_URI=

EAPI=8

DESCRIPTION="Raspberry PI boot loader and firmware, for any of the versions I have"
HOMEPAGE="https://github.com/raspberrypi/firmware"

LICENSE="GPL-2 raspberrypi-videocore-bin Broadcom"
SLOT="0"
KEYWORDS="arm ~arm arm64 ~arm64"

IUSE="
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b
	bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2711-rpi-cm4-io bcm2712-rpi-5-b bcm2712-rpi-cm5-cm5io
	+kernel +dtbo"

# require exactly one kind of board to be selected
REQUIRED_USE="
	^^ ( bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b
	bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2711-rpi-cm4-io bcm2712-rpi-5-b bcm2712-rpi-cm5-cm5io )
"

# this doesn't do anything, anymore - but it used to be necessary
#MY_ARCH="
#	bcm2708-rpi-b?         ( arm )
#	bcm2709-rpi-2-b?       ( arm )
#	bcm2710-rpi-3-b?       ( arm )
#	bcm2710-rpi-3-b-plus?  ( arm64 )
#	bcm2711-rpi-4-b?       ( arm64 )
#	bcm2711-rpi-cm4-io?    ( arm64 )
#	bcm2712-rpi-5-b?       ( arm64 )
#	bcm2712-rpi-cm5-cm5io? ( arm64 )
#"
#UPSTREAM_PV="${PV/_p/+${MY_ARCH}}"
#UPSTREAM_PV="${UPSTREAM_PV/_p/+}"
#DOWNLOAD_PV="${PV/_p/-${MY_ARCH}}"
#DOWNLOAD_PV="${DOWNLOAD_PV/_p/-}"

# '->' operator = download the file from the URL on the left and save it to the filename on the right
#SRC_URI="https://github.com/raspberrypi/firmware/archive/${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror binchecks strip"

DEPEND=""
RDEPEND="
	!sys-boot/raspberrypi-firmware
	${DEPEND}
"

#S="${WORKDIR}/firmware-${DOWNLOAD_PV}"
S="${WORKDIR}/firmware-${PV}"

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
	if use bcm2712-rpi-cm5-cm5io ; then
		export board="bcm2712-rpi-cm5-cm5io"
		export kernel_name="kernel_2712.img"
		export uname_string="uname_string_2712"
	else if use bcm2712-rpi-5-b ; then
		export board="bcm2712-rpi-5-b"
		export kernel_name="kernel_2712.img"
		export uname_string="uname_string_2712"
	else if use bcm2711-rpi-cm4-io ; then
		export board="bcm2711-rpi-cm4-io"
		export kernel_name="kernel8.img"
		export uname_string="uname_string8"
	else if use bcm2711-rpi-4-b ; then
		export board="bcm2711-rpi-4-b"
		export kernel_name="kernel8.img"
		export uname_string="uname_string8"
	else if use bcm2710-rpi-3-b-plus; then
		export board="bcm2710-rpi-3-b-plus"
		export kernel_name="kernel8.img"
		export uname_string="uname_string8"
	else if use bcm2710-rpi-3-b; then
		export board="bcm2710-rpi-3-b"
		export kernel_name="kernel7.img"
		export uname_string="uname_string7"
	else if use bcm2709-rpi-2-b; then
		export board="bcm2709-rpi-2-b"
		export kernel_name="kernel7.img"
		export uname_string="uname_string7"
	else if use bcm2708-rpi-b; then
		export board="bcm2708-rpi-b"
		export kernel_name="kernel.img"
		export uname_string="uname_string"
	fi; fi; fi; fi; fi; fi; fi; fi
	einfo "Assigned board: ${board}"

        einfo "S=${S}"
        einfo "D=${D}"
        einfo "P=${P}"
        einfo "PN=${PN}"
        einfo "PV=${PV}"
        einfo "PVR=${PVR}"
#        einfo "RDEPEND=${RDEPEND}"
#        einfo "DEPEND=${DEPEND}"
#	einfo "UPSTREAM_PV=${UPSTREAM_PV}"
#	einfo "DOWNLOAD_PV=${DOWNLOAD_PV}"
	einfo "SRC_URI=${SRC_URI}"
	einfo "board=${board}"
	einfo "kernel_name=${kernel_name}"
	einfo "uname_string=${uname_string}"
}

src_install() {
	cd boot
	einfo "Now installing (ins) boot firmware into /boot"
	insinto /boot

	# install all of the basic boot code and licences
	for x in elf bin dat broadcom linux; do
		einfo "installing *.${x}..."
		for y in *.${x}; do
			doins *.${x}
			elog "installed ${y}"
		done
	done

	# install the device tree blob for this board
	einfo "installing ${board}.dtb..."
	doins "${board}.dtb"
	elog "installed ${board}.dtb"

	# install device tree blob overlays, if use flag selected
	if use dtbo; then
		doins -r overlays
	fi

	# install kernel and associated modules, if use flag selected
	if use kernel; then
		einfo "installing ${kernel_name}"
		doins "${kernel_name}"
		elog "installed ${kernel_name}"
		# now install matching modules; first get version string for this board
		version_string="$(cat ../extra/${uname_string} | awk '{print $3}')"
		einfo "version_string=${version_string}"
		cd ../modules
		einfo "Now installing (ins) modules for ${kernel_name} into /lib/modules/"
		insinto /lib/modules/
		doins -r ${version_string}
	fi
}

pkg_postinst() {
        elog ""
        elog "${P} installed"
	elog "board=${board}"
	elog "kernel_name=${kernel_name}"
	elog "uname_string=${uname_string}"
        elog ""
        elog "This software is evolving.  Please report bugs to the maintainer."
        elog ""
        elog "version number ${PV} is drawn from upstream. 1.20240424 was the first in joetoo"
        elog " 20240611 - update to add support for rpi 3 B v1.2 32 bit (bcm2710-rpi-3-b)"
	elog " 20250430 - routine update; subsequent added support for CM4, CM5 with IO boards"
	elog " 20250915 - routine update; begin ebuild cleanup"
	elog ""
	elog "NOTE: /boot/cmdline.txt and /boot/config.txt are provided by sbc-boot-config"
	elog "NOTE: kernel, dtbs, and overlays may also be provided by e.g. sys-kernel/linux-${board}_kernel_image package"
        elog ""
        elog "Thank you for using ${PN}"
}
