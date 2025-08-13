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
	-sbc
	-bcm2712-rpi-cm5-cm5io -bcm2712-rpi-5-b -bcm2711-rpi-cm4-io -bcm2711-rpi-4-b -bcm2710-rpi-3-b-plus
	-bcm2710-rpi-3-b -bcm2709-rpi-2-b -bcm2708-rpi-b
	-rk3288-tinker-s
	-rk3399-rock-pi-4c-plus -rk3399-tinker-2 -rk3588-rock-5b -rk3588s-orangepi-5 -rk3588s-rock-5c
	-meson-gxl-s905x-libretech-cc-v2 -meson-sm1-s905d3-libretech-cc -meson-g12b-a311d-libretech-cc
	-fsl-imx8mq-phanbell
"

REQUIRED_USE="
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
	target="/etc/portage/binrepos.conf/"
	einfo "Installing (ins) files into ${target} ..."
	insinto "${target}"
	if use sbc; then
		case $board in
			"bcm2712-rpi-5-b"|"bcm2712-rpi-cm5-cm5io")
				newins "${FILESDIR}/etc_portage_binrepos_conf-rpi5_binhosts_conf_joetoo" "joetoo_rpi5_binhosts.conf" ;;
			"bcm2711-rpi-4-b"|"bcm2711-rpi-cm4-io")
				newins "${FILESDIR}/etc_portage_binrepos_conf-rpi4_binhosts_conf_joetoo" "joetoo_rpi4_binhosts.conf" ;;
			"bcm2710-rpi-3-b-plus")
				newins "${FILESDIR}/etc_portage_binrepos_conf-rpi3_binhosts_conf_joetoo" "joetoo_rpi3_binhosts.conf" ;;
			"bcm2709-rpi-2-b"|"bcm2710-rpi-3-b")
				newins "${FILESDIR}/etc_portage_binrepos_conf-rpi23A_binhosts_conf_joetoo" "joetoo_rpi23A_binhosts.conf" ;;
			"bcm2708-rpi-b")
				newins "${FILESDIR}/etc_portage_binrepos_conf-rpi1_binhosts_conf_joetoo" "joetoo_rpi1_binhosts.conf" ;;
			"rk3399-rock-pi-4c-plus"|"rk3399-tinker-2")
				newins "${FILESDIR}/etc_portage_binrepos_conf-rk3399_binhosts_conf_joetoo" "joetoo_rk3399_binhosts.conf" ;;
			"rk3588-rock-5b"|"rk3588s-orangepi-5"|"rk3588s-rock-5c")
				newins "${FILESDIR}/etc_portage_binrepos_conf-rk3588_binhosts_conf_joetoo" "joetoo_rk3588_binhosts.conf" ;;
			"fsl-imx8mq-phanbell"|"meson-gxl-s905x-libretech-cc-v2")
				newins "${FILESDIR}/etc_portage_binrepos_conf-sweetpototo_binhosts_conf_joetoo" "joetoo_sweetpotato_binhosts.conf" ;;
			"meson-sm1-s905d3-libretech-cc")
				newins "${FILESDIR}/etc_portage_binrepos_conf-solitude_binhosts_conf_joetoo" "joetoo_solitude_binhosts.conf" ;;
			"meson-g12b-a311d-libretech-cc")
				newins "${FILESDIR}/etc_portage_binrepos_conf-alta_binhosts_conf_joetoo" "joetoo_alta_binhosts.conf" ;;
			"rk3288-tinker-s")
				# nothing, yet - I only have one of these (and my tinker-s is retired)
				;;
			"generic-amd64")
				# nothing yet (several manually created)
				;;
		esac
	else
		# nothing, yet
		einfo "not an sbc install, no binhost configured for joetoo, yet"
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
	elog "Thank you for using ${PN}"
}
