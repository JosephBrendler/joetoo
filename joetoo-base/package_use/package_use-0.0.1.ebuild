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
	+grub
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
		if use bcm2712-rpi-cm5-cm5io ; then export board="bcm2712-rpi-cm5-cm5io" ; export maker="raspi"
		elif use bcm2712-rpi-5-b ; then export board="bcm2712-rpi-5-b" ; export maker="raspi"
		elif use bcm2711-rpi-cm4-io ; then export board="bcm2711-rpi-cm4-io" ; export maker="raspi"
		elif use bcm2711-rpi-4-b ; then export board="bcm2711-rpi-4-b" ; export maker="raspi"
		elif use bcm2710-rpi-3-b-plus ; then export board="bcm2710-rpi-3-b-plus" ; export maker="raspi"
		elif use bcm2710-rpi-3-b ; then export board="bcm2710-rpi-3-b" ; export maker="raspi"
		elif use bcm2709-rpi-2-b ; then export board="bcm2709-rpi-2-b" ; export maker="raspi"
		elif use bcm2708-rpi-b ; then export board="bcm2708-rpi-b" ; export maker="raspi"
		elif use rk3288-tinker-s ; then export board="rk3288-tinker-s" ; export maker="rockchip"
		elif use rk3399-rock-pi-4c-plus ; then export board="rk3399-rock-pi-4c-plus" ; export maker="rockchip"
		elif use rk3399-tinker-2 ; then export board="rk3399-tinker-2" ; export maker="rockchip"
		elif use rk3588-rock-5b ; then export board="rk3588-rock-5b" ; export maker="rockchip"
		elif use rk3588s-orangepi-5 ; then export board="rk3588s-orangepi-5" ; export maker="rockchip"
		elif use rk3588s-rock-5c ; then export board="rk3588s-rock-5c" ; export maker="rockchip"
		elif use fsl-imx8mq-phanbell ; then export board="fsl-imx8mq-phanbell" ; export maker="nxp"
		elif use meson-gxl-s905x-libretech-cc-v2 ; then export board="meson-gxl-s905x-libretech-cc-v2" ; export maker="amlogic"
		elif use meson-sm1-s905d3-libretech-cc ; then export board="meson-sm1-s905d3-libretech-cc" ; export maker="amlogic"
		elif use meson-g12b-a311d-libretech-cc ; then export board="meson-g12b-a311d-libretech-cc" ; export maker="amlogic"
		else export board="" ; export arch=""
		fi
	else
		einfo "USE sbc is NOT selected"
		export board="" ; export arch=""
	fi
	elog "pkg_setup complete. board = ${board}"
}

src_install() {
	target="/etc/portage/package.use/"
	einfo "Installing (ins) files into ${target} ..."
	insinto "${target}"
	# install the joetoo common USE flag file
	newins "${S}/package.use.joetoo.common" "joetoo_common"
	# prepare and install the cpu-flags and joetoo platform-specific USE flag file for this platform
	if use sbc ; then
		# install the joetoo 00cpu-flags USE flag file for this platform
		newins "${S}/package.use.00cpu-flags.${board}" "00cpu-flags" || \
			die "failed to install 00cpu-flags"
		elog "Installed ${target}/00cpu-flags"
		# prepare and install the board-specific platform package.use file
		einfo "copying platform_template to temporary scratch work space T: ${T} ..."
		cp ${S}/package.use.joetoo.platform_template ${T}/ || \
			die "failed to copy platform_template to $T"
		einfo "editing platform_template for board: ${board} ..."
		sed -i "s|<BOARD>|${board}|g" ${T}/package.use.joetoo.platform_template || \
			die "failed to edit board"
		einfo "editing platform_template for maker: ${maker} ..."
		sed -i "s|<MAKER>|${maker}|g" ${T}/package.use.joetoo.platform_template || \
			die "failed to edit maker"
		if [[ "${maker}" == "raspi" ]] ; then
			sed -i "s|armbian_kernel|kernel|g" ${T}/package.use.joetoo.platform_template || \
				die "failed to edit kernel for maker: ${maker}"
		fi
		if use grub ; then
			einfo "editing platform_template for grub ..."
			sed -i "s|<GRUB>|grub|g" ${T}/package.use.joetoo.platform_template || \
				die "failed to edit maker"
		else
			einfo "editing platform_template for -grub ..."
			sed -i "s|<GRUB>|-grub|g" ${T}/package.use.joetoo.platform_template || \
				die "failed to edit maker"
		fi
		einfo "Installing platform-specific (${maker} ${board}) package.use file"
		newins "${T}/package.use.joetoo.platform_template" "joetoo_${board}" || \
			die "failed to install package.use.joetoo.amd64"
		elog "Installed ${target}/joetoo_${board}"
	else
		# install the joetoo 00cpu-flags USE flag file for this platform
		newins "${S}/package.use.00cpu-flags.amd64" "00cpu-flags"
		# install the amd64 platform package.use file
		einfo "Installing amd64 platform package.use file"
		newins "${S}/package.use.joetoo.amd64" "joetoo_amd64" || \
			die "failed to install package.use.joetoo.amd64"
		elog "Installed ${target}/joetoo_amd64"
	fi
	# install the joetoo plasma USE flag file if needed
	if use plasma ; then
		newins "${S}/package.use.joetoo.plasma" "plasma" || \
			die "failed to install package.use.joetoo.plasma"
		elog "Installed ${target}/plasma"
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
