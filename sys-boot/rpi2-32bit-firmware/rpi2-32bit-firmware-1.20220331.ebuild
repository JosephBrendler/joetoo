# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Raspberry Pi boot loader and firmware, for 32-bit mode"
HOMEPAGE="https://github.com/raspberrypi/firmware"
UPSTREAM_PV="${PV/_p/+arm}"
UPSTREAM_PV="${UPSTREAM_PV/_p/+}"
DOWNLOAD_PV="${PV/_p/-arm}"
DOWNLOAD_PV="${DOWNLOAD_PV/_p/-}"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 raspberrypi-videocore-bin Broadcom"
SLOT="0"
KEYWORDS="~arm"
IUSE="+dtbo"
RESTRICT="mirror binchecks strip"

DEPEND=""
RDEPEND="
	!sys-boot/raspberrypi-firmware
	${DEPEND}"

S="${WORKDIR}/firmware-${DOWNLOAD_PV}"

pkg_preinst() {
	if ! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1; then
		ewarn "${ROOT%/}/boot is not mounted, the files might not be installed at the right place"
	fi
}

src_install() {
	cd boot
	insinto /boot
	doins *.elf
	# allow for the dtbos to be provided by the kernel package
	if use dtbo; then
		doins -r overlays
	fi
	doins *.bin
	doins *.dat
	doins *.broadcom
	# assume /boot/cmdline.txt and /boot/config.txt are
	# provided by rpi2-boot-config package;
	# assume kernel and dtbs are provided separately
	# e.g. by sys-kernel/bcm2709-rpi-2-b_kernel_image package
}
