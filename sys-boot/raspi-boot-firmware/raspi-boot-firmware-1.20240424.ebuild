# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Raspberry PI boot loader and firmware, for any of the versions I have"
HOMEPAGE="https://github.com/raspberrypi/firmware"

LICENSE="GPL-2 raspberrypi-videocore-bin Broadcom"
SLOT="0"
KEYWORDS="~arm ~arm64"

IUSE="bcm2709-rpi-2-b bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b +kernel +dtbo"

# require exactly one kind of board to be selected
REQUIRED_USE="
^^ ( bcm2709-rpi-2-b bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b )
"

RESTRICT="mirror binchecks strip"

DEPEND=""
RDEPEND="
	!sys-boot/raspberrypi-firmware
	${DEPEND}
"

S="${WORKDIR}/firmware-${DOWNLOAD_PV}"

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
	if use bcm2712-rpi-5-b ; then
		export board="bcm2712-rpi-5-b"
		export kernel_name="kernel_2712.img"
		my_arch="arm64"
	else if use bcm2711-rpi-4-b ; then
		export board="bcm2711-rpi-4-b"
		export kernel_name="kernel8.img"
		my_arch="arm64"
	else if use bcm2710-rpi-3-b-plus; then
		export board="bcm2710-rpi-3-b-plus"
		export kernel_name="kernel8.img"
		my_arch="arm64"
	else if use bcm2709-rpi-2-b; then
		export board="bcm2709-rpi-2-b"
		export kernel_name="kernel7.img"
		my_arch="arm"
	else
		export board=""
	fi; fi; fi; fi
	einfo "Assigned board: ${board}"
	export UPSTREAM_PV="${PV/_p/+${my_arch}}"
	export UPSTREAM_PV="${UPSTREAM_PV/_p/+}"
	export DOWNLOAD_PV="${PV/_p/-${my_arch}}"
	export DOWNLOAD_PV="${DOWNLOAD_PV/_p/-}"
	export SRC_URI="https://github.com/raspberrypi/firmware/archive/${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"

        einfo "S=${S}"
        einfo "D=${D}"
        einfo "P=${P}"
        einfo "PN=${PN}"
        einfo "PV=${PV}"
        einfo "PVR=${PVR}"
        einfo "RDEPEND=${RDEPEND}"
        einfo "DEPEND=${DEPEND}"
	einfo "UPSTREAM_PV=${UPSTREAM_PV}"
	einfo "DOWNLOAD_PV=${DOWNLOAD_PV}"
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

	# install kernel if use flag selected
	if use kernel; then
		doins "${kernel_name}"
	fi

	# allow for the dtbos to be provided by the kernel package
	if use dtbo; then
		doins -r overlays
	fi
}

pkg_postinst() {
        elog ""
        elog "${PN}-${PVR} installed"
        elog "This version is still preliminary. Please report bugs to the maintainer."
        elog ""
	elog "NOTE: /boot/cmdline.txt and /boot/config.txt are provided by sbc-boot-config"
	elog "NOTE: kernel, dtbs, and overlays may also be provided by e.g. sys-kernel/linux-${board}_kernel_image package"
        elog ""
        elog "Thank you for using ${PN}"
}
