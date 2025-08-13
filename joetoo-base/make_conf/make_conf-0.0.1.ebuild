# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Baseline for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm ~amd64 ~arm64 arm amd64 arm64"
RESTRICT="mirror"

IUSE="
	+headless -plasma -gnome
	-sbc
	-bcm2712-rpi-cm5-cm5io -bcm2712-rpi-5-b -bcm2711-rpi-cm4-io -bcm2711-rpi-4-b -bcm2710-rpi-3-b-plus
	-bcm2710-rpi-3-b -bcm2709-rpi-2-b -bcm2708-rpi-b
	-rk3288-tinker-s
	-rk3399-rock-pi-4c-plus -rk3399-tinker-2 -rk3588-rock-5b -rk3588s-orangepi-5 -rk3588s-rock-5c
	-meson-gxl-s905x-libretech-cc-v2 -meson-sm1-s905d3-libretech-cc -meson-g12b-a311d-libretech-cc
	-fsl-imx8mq-phanbell
"

REQUIRED_USE="
	^^ ( headless plasma gnome )
	sbc? ( ^^ (
		bcm2712-rpi-cm5-cm5io
		bcm2712-rpi-5-b
		bcm2711-rpi-cm4-io
		bcm2711-rpi-4-b
		bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b
		bcm2709-rpi-2-b
		bcm2708-rpi-b
		rk3288-tinker-s
		rk3399-rock-pi-4c-plus
		rk3399-tinker-2
		rk3588-rock-5b
		rk3588s-orangepi-5
		rk3588s-rock-5c
		meson-gxl-s905x-libretech-cc-v2
		meson-sm1-s905d3-libretech-cc
		meson-g12b-a311d-libretech-cc
		fsl-imx8mq-phanbell
		)
	)
"

S="${WORKDIR}/${PN}"

RDEPEND=""

BDEPEND="${RDEPEND}"

pkg_setup() {
# for sbc systems we need to know which board we are using
	if use sbc ; then
		einfo "USE sbc is selected. Assigning board ..."
		if use bcm2712-rpi-cm5-cm5io ; then export board="bcm2712-rpi-cm5-cm5io"
		elif use bcm2712-rpi-5-b ; then export board="bcm2712-rpi-5-b"
		elif use bcm2711-rpi-cm4-io ; then export board="bcm2711-rpi-cm4-io"
		elif use bcm2711-rpi-4-b ; then export board="bcm2711-rpi-4-b"
		elif use bcm2710-rpi-3-b-plus ; then export board="bcm2710-rpi-3-b-plus"
		elif use bcm2710-rpi-3-b ; then export board="bcm2710-rpi-3-b"
		elif use bcm2709-rpi-2-b ; then export board="bcm2709-rpi-2-b"
		elif use bcm2708-rpi-b ; then export board="bcm2708-rpi-b"
		elif use rk3288-tinker-s ; then export board="rk3288-tinker-s"
		elif use rk3399-rock-pi-4c-plus ; then export board="rk3399-rock-pi-4c-plus"
		elif use rk3399-tinker-2 ; then export board="rk3399-tinker-2"
		elif use rk3588-rock-5b ; then export board="rk3588-rock-5b"
		elif use rk3588s-orangepi-5 ; then export board="rk3588s-orangepi-5"
		elif use rk3588s-rock-5c ; then export board="rk3588s-rock-5c"
		elif use fsl-imx8mq-phanbell ; then export board="fsl-imx8mq-phanbell"
		elif use meson-gxl-s905x-libretech-cc-v2 ; then export board="meson-gxl-s905x-libretech-cc-v2"
		elif use meson-sm1-s905d3-libretech-cc ; then export board="meson-sm1-s905d3-libretech-cc"
		elif use meson-g12b-a311d-libretech-cc ; then export board="meson-g12b-a311d-libretech-cc"
		else export board=""
		fi
	else
		einfo "USE sbc is NOT selected"
		export board="generic-amd64"
	fi
	elog "pkg_setup complete. board = ${board}"
}

src_install() {
	target="/etc/portage/"
	einfo "Installing (ins) files into ${target} ..."
	insinto "${target}"
	if use sbc ; then
		# install both crossbuild and chroot versions of headless/desktop make.conf
		# (and use crossbuild version as initial make.conf for sbcs [assume crossbuilding])
		if use headless ; then
			# install headless versions
			newins "${S}/make.conf.headless.crossbuild.${board}" "make.conf.crossbuild" || \
				die "failed to install make.conf.crossbuild for headless sbc"
			elog "Installed make.conf.crossbuild for headless sbc"
			newins "${S}/make.conf.headless.chroot.${board}" "make.conf.chroot" || \
				die "failed to install make.conf.chroot for headless sbc"
			elog "Installed make.conf.chroot for headless sbc"
			newins "${S}/make.conf.headless.crossbuild.${board}" "make.conf" || \
				die "failed to install make.conf for headless sbc"
			elog "Installed make.conf for headless sbc"
		else
			# install desktop versions
			newins "${S}/make.conf.desktop.crossbuild.${board}" "make.conf.crossbuild" || \
				die "failed to install make.conf.crossbuild for desktop sbc"
			elog "Installed make.conf.crossbuild for desktop sbc"
			newins "${S}/make.conf.desktop.chroot.${board}" "make.conf.chroot" || \
				die "failed to install make.conf.chroot for desktop sbc"
			elog "Installed make.conf.chroot for desktop sbc"
			newins "${S}/make.conf.desktop.crossbuild.${board}" "make.conf.crossbuild" || \
				die "failed to install make.conf for desktop sbc"
			elog "Installed make.conf for desktop sbc"
		fi
	else
		# install both crossbuild and chroot versions of headless/desktop make.conf
		# (and use chroot version as initial make.conf for non-sbcs [assume not crossbuilding])
		if use headless ; then
			# install headless versions
			newins "${S}/make.conf.headless.crossbuild.${board}" "make.conf.crossbuild" || \
				die "failed to install make.conf.crossbuild for headless non-sbc"
			elog "Installed make.conf.crossbuild for headless non-sbc"
			newins "${S}/make.conf.headless.chroot.${board}" "make.conf.chroot" || \
				die "failed to install make.conf.chroot for headless non-sbc"
			elog "Installed make.conf.chroot for headless non-sbc"
			newins "${S}/make.conf.headless.chroot.${board}" "make.conf" || \
				die "failed to install make.conf for headless non-sbc"
			elog "Installed make.conf for headless non-sbc"
		else
			# install desktop versions
			newins "${S}/make.conf.desktop.crossbuild.${board}" "make.conf.crossbuild" || \
				die "failed to install make.conf.crossbuild for desktop non-sbc"
			elog "Installed make.conf.crossbuild for desktop non-sbc"
			newins "${S}/make.conf.desktop.chroot.${board}" "make.conf.chroot" || \
				die "failed to install make.conf.chroot for desktop non-sbc"
			elog "Installed make.conf.chroot for desktop non-sbc"
			newins "${S}/make.conf.desktop.chroot.${board}" "make.conf.crossbuild" || \
				die "failed to install make.conf.crossbuild for desktop non-sbc"
			elog "Installed make.conf for desktop non-sbc"
		fi
		newins "${S}/etc_portage_make_conf_joetoo_amd64" "make.conf"
	fi
	elog "Done installing (ins) files into ${target} ..."
}


pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "board=${board}"
	einfo "arch=${arch}"
	elog ""
	elog "${P} installed"
	elog "Please report bugs to the maintainer."
	elog ""
	elog "version_history can be found in the ebuild files directory."
	elog " 0.0.1 is the first separate ebuild for ${PN}"
	elog ""
	if use gnome; then
		ewarn "USE = gnome was specified, but is not implemented yet..."
		elog "USE = gnome was specified, but is not implemented yet..."
		elog ""
	fi
	elog ""
	elog "Thank you for using ${PN}"
}
