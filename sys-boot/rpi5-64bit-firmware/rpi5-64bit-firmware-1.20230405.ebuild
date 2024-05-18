# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY
#
# to update for new upstream PV --
#  mkdir scratch; cd scratch
#  git clone https://github.com/raspberrypi/firmware
#  cd firmware
#  git tag
# (select latest stable version - "1.20230405" as of 12/02/2023)
#

EAPI=8

DESCRIPTION="Raspberry PI boot loader and firmware, for 64-bit mode Pi 5"
HOMEPAGE="https://github.com/raspberrypi/firmware"
UPSTREAM_PV="${PV/_p64/+arm64}"
UPSTREAM_PV="${UPSTREAM_PV/_p/+}"
DOWNLOAD_PV="${PV/_p64/-arm64}"
DOWNLOAD_PV="${DOWNLOAD_PV/_p/-}"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 raspberrypi-videocore-bin Broadcom"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+dtbo"
RESTRICT="mirror binchecks strip"

DEPEND=""
RDEPEND="
	!sys-boot/raspberrypi-firmware
	${DEPEND}"

S="${WORKDIR}/firmware-${DOWNLOAD_PV}"

elog "PV=${PV}"
elog "UPSTREAM_PV=${UPSTREAM_PV}"
elog "DOWNLOAD_PV=${DOWNLOAD_PV}"
elog "WORKDIR=${WORKDIR}"
elog "S=${S}"

pkg_preinst() {
	if ! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1; then
		ewarn "${ROOT%/}/boot is not mounted, the files might not be installed at the right place"
	fi
}

src_install() {
	# replicate actions instructed at "Populate boot" section of
	#   https://wiki.gentoo.org/wiki/Raspberry_PI_Install_Guide
	cd boot
	insinto /boot
	doins *
	# assume /boot/cmdline.txt and /boot/config.txt now
	# provided by rpi5-boot-config package, which
	# config-protects them;
	# to-do: provide kernel and dtbs separately
	# e.g. by sys-kernel/bcmrpi5-kernel-bin package or such
}
