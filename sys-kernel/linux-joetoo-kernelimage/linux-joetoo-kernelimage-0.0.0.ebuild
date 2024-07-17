# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

DESCRIPTION="kernel image for ${BOARD} sbc"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm ~arm64 ~amd64"

IUSE="
	-raspi-sources -rockchip-sources
	+dtb +dtbo
	-symlink
	bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5
	domU
"

REQUIRED_USE="
	^^ (
		bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
		rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5
		domU
	)
	raspi-sources? ( !rockchip-sources )
	rockchip-sources? ( !raspi-sources )
"

RESTRICT="mirror"

RDEPEND="
	raspi-sources?    ( =sys-kernel/raspi-sources-${PV} )
	rockchip-sources? ( =sys-kernel/rockchip-sources-${PV} )
"

BDEPEND="${RDEPEND}"

BOARD="
	bcm2708-rpi-b? ( bcm2708-rpi-b )
"

pkg_setup() {
	einfo "Starting pkg_setup() ..."
	SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-${BOARD}_kernel_image-${PV}.tar.bz2"

}

pkg_preinst() {
	einfo "Starting pkg_preinst() ..."
	# if /boot is on a separate block device, and it is not mounted, try to>
	if grep -v '^#' /etc/fstab | grep boot >/dev/null 2>&1  && \
		! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1 ; then
		elog "${ROOT%/}/boot is not mounted, trying to mount it now..."
		! $(mount /boot) && \
			die "Failed to mount /boot" || \
			elog "Succeeded in mounting /boot ; continuing..."
	else
		elog "Verified /boot is mounted ; continuing..."
	fi
}

src_install() {
	einfo "Starting src_install() ..."
	einfo "BOARD=${BOARD}"
	einfo "SRC_URI=${SRC_URI}"
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "ED=${ED}"
	einfo "A=${A}"
	einfo "T=${T}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"
}

pkg_postinst() {
	elog "${P} installed for ${board}"
	elog "Depends on joetoo-meta by default (see joetoo USE flag) "
	elog ""
	elog "version 0.0.0 is a template for consolidated ${PN} ebuilds"
	elog ""
	elog "Thank you for using ${PN}"
}
