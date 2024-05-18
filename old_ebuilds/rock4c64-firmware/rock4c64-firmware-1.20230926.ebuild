# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Raspberry PI boot loader and firmware, for 64-bit mode"
HOMEPAGE="https://github.com/raspberrypi/firmware"
UPSTREAM_PV="${PV/_p64/+arm64}"
UPSTREAM_PV="${UPSTREAM_PV/_p/+}"
DOWNLOAD_PV="${PV/_p64/-arm64}"
DOWNLOAD_PV="${DOWNLOAD_PV/_p/-}"
# To do - find upstream for firmware
#SRC_URI="https://github.com/raspberrypi/firmware/archive/${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI=""

LICENSE="GPL-2 raspberrypi-videocore-bin Broadcom"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+dtbo"
#RESTRICT="mirror binchecks strip"    #???
RESTRICT="mirror"

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
		newins "${FILESDIR}/placeholder" firmware_placeholder
# To do
	# allow for the dtbos to be provided by the kernel package
#	if use dtbo; then
#		doins -r /boot/dtb/rockchip/overlay
#	fi
}
