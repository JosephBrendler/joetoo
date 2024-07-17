# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

DESCRIPTION="kernel image for ${BOARD} sbc"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="arm arm64 amd64 ~arm ~arm64 ~amd64"

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
	raspi-sources?    ( !rockchip-sources )
	rockchip-sources? ( !raspi-sources )
	domU?             ( !rockchip-sources !raspi-sources )
"

RESTRICT="mirror"

RDEPEND="
	raspi-sources?    ( =sys-kernel/raspi-sources-${PV} )
	rockchip-sources? ( =sys-kernel/rockchip-sources-${PV} )
	domU?             ( =sys-kernel/gentoo-sources-${PV} )
"

BDEPEND="${RDEPEND}"

SRC_URI="
	domU?                   ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-domU_kernel_image-${PV}.tar.bz2 )
	bcm2708-rpi-b?          ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2708-rpi-b_kernel_image-${PV}.tar.bz2 )
	bcm2709-rpi-2-b?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2709-rpi-2-b_kernel_image-${PV}.tar.bz2 )
	bcm2710-rpi-3-b?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2710-rpi-3-b_kernel_image-${PV}.tar.bz2 )
	bcm2710-rpi-3-b-plus?   ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2710-rpi-3-b-plus_kernel_image-${PV}.tar.bz2 )
	bcm2711-rpi-4-b?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2711-rpi-4-b_kernel_image-${PV}.tar.bz2 )
	bcm2712-rpi-5-b?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2712-rpi-5-b_kernel_image-${PV}.tar.bz2 )
	rk3288-tinker-s?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3288-tinker-s_kernel_image-${PV}.tar.bz2 )
	rk3399-rock-pi-4c-plus? ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3399-rock-pi-4c-plus_kernel_image-${PV}.tar.bz2 )
"

# NOTE: joetoo kernels for these boards don't yet work...
#	rk3399-tinker-2? ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3399-tinker-2_kernel_image-${PV}.tar.bz2 )
#	rk3588s-orangepi-5? ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3588s-orangepi-5_kernel_image-${PV}.tar.bz2 )

einfo "SRC_URI=${SRC_URI}"

pkg_setup() {
	einfo "Starting pkg_setup ..."
	# for sbc systems we need to know which board we are using
	if use bcm2712-rpi-5-b ; then
		export board="bcm2712-rpi-5-b"
	else if use bcm2711-rpi-4-b ; then
		export board="bcm2711-rpi-4-b"
	else if use bcm2710-rpi-3-b-plus; then
		export board="bcm2710-rpi-3-b-plus"
	else if use bcm2710-rpi-3-b; then
		export board="bcm2710-rpi-3-b"
	else if use bcm2709-rpi-2-b; then
		export board="bcm2709-rpi-2-b"
	else if use bcm2708-rpi-b; then
		export board="bcm2708-rpi-b"
	else if use rk3288-tinker-s; then
		export board="rk3288-tinker-s"
	else if use rk3399-rock-pi-4c-plus; then
		export board="rk3399-rock-pi-4c-plus"
	else if use rk3399-tinker-2; then
		export board="rk3399-tinker-2"
	else if use rk3588s-orangepi-5; then
		export board="rk3588s-orangepi-5"
	else
		export board=""
	fi; fi; fi; fi; fi; fi; fi; fi; fi; fi
	einfo "Assigned board: ${board}"
}

pkg_preinst() {
	einfo "Starting pkg_preinst ..."
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
	einfo "Starting src_install ..."
	einfo "SRC_URI=${SRC_URI}"
	einfo "board=${board}"
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
	einfo "Starting pkg_postinst ..."
	elog "${P} installed for ${board}"
	elog ""
	elog "version 0.0.0 is a template for consolidated ${PN} ebuilds"
	elog ""
	elog "Thank you for using ${PN}"
}
