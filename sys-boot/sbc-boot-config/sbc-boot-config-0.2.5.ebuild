# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# License: GPL v3+
# NO WARRANTY
#
# NOTE: starting with version 0.2.3 this should not get installed for amlogic (libre computer) solitude boards
# (meson-sm1-s905d3-libretech-cc) since they have uefi on SPI NOR device and don't use joetoo's boot.cmd, etc
# to-do: migrate meson-g12b-a311d-libretech-cc (alta) and meson-gxl-s905x-libretech-cc-v2 (sweetpotato) similarly
# [update dev-sbc/sbc-headless-meta] and drop these board names from this ebuild
#
EAPI=8

DESCRIPTION="Boot configuration files for single board computers (sbc)s"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~arm64"
RESTRICT="mirror"

IUSE="
	bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-cm4-io bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-rock-4se rk3399-tinker-2
	rk3588-rock-5b rk3588-radxa-rock-5b+ rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	fsl-imx8mq-phanbell
	meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
"

REQUIRED_USE="
	^^ ( bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-cm4-io bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-rock-4se rk3399-tinker-2
	rk3588-rock-5b rk3588-radxa-rock-5b+ rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	fsl-imx8mq-phanbell
	meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
	)
"

DEPEND=""
RDEPEND="
	${DEPEND}"

S="${WORKDIR}/${PN}"

# borrow checkboot from script_header_joetoo so we don't have to source the whole thing in an ebuild
checkboot () {
[[ -z $(grep '[[:space:]]/boot[[:space:]]' /etc/fstab | grep -v '^#') ]] && return 2 ;
[[ ! -z $(findmnt -nl /boot) ]] && return 0 || return 1 ;
}

pkg_setup() {
	# if /boot is on a separate block device, and it is not mounted, try to mount it
	checkboot
	case $? in
		2 )  elog "Per checkboot, /boot is not supposed to be a mountpoint; continuing ..." ;;
		1 )  ewarn "Per checkboot, /boot is supposed to be mounted; but it is not" ;
			einfo "trying to mount it now" ;
			mount /boot || die "Failed to mount /boot" ;
			elog "Succeeded in mounting /boot ; continuing ..." ;;
		0 )  elog "Verified with checkboot, /boot is properly mounted; continuing ..." ;;
	esac

	# for sbc systems we need to know which board we are using
	if use bcm2712-rpi-cm5-cm5io ; then export board="bcm2712-rpi-cm5-cm5io"; export maker="raspi"
	elif use bcm2712-rpi-5-b ; then export board="bcm2712-rpi-5-b"; export maker="raspi"
	elif use bcm2711-rpi-cm4-io ; then export board="bcm2711-rpi-cm4-io"; export maker="raspi"
	elif use bcm2711-rpi-4-b ; then export board="bcm2711-rpi-4-b"; export maker="raspi"
	elif use bcm2710-rpi-3-b-plus; then export board="bcm2710-rpi-3-b-plus"; export maker="raspi"
	elif use bcm2710-rpi-3-b; then export board="bcm2710-rpi-3-b"; export maker="raspi"
	elif use bcm2709-rpi-2-b; then export board="bcm2709-rpi-2-b"; export maker="raspi"
	elif use bcm2708-rpi-b; then export board="bcm2708-rpi-b"; export maker="raspi"
	elif use rk3288-tinker-s; then export board="rk3288-tinker-s"; export maker="rockchip"
	elif use rk3399-rock-pi-4c-plus; then export board="rk3399-rock-pi-4c-plus"; export maker="rockchip"
	elif use rk3399-rock-4se; then export board="rk3399-rock-4se"; export maker="rockchip"
	elif use rk3399-tinker-2; then export board="rk3399-tinker-2"; export maker="rockchip"
	elif use rk3588-rock-5b; then export board="rk3588-rock-5b"; export maker="rockchip"
	elif use rk3588-radxa-rock-5b+; then export board="rk3588-radxa-rock-5b+"; export maker="rockchip"
	elif use rk3588s-orangepi-5; then export board="rk3588s-orangepi-5"; export maker="rockchip"
	elif use rk3588s-orangepi-5b; then export board="rk3588s-orangepi-5b"; export maker="rockchip"
	elif use rk3588s-rock-5c; then export board="rk3588s-rock-5c"; export maker="rockchip"
	elif use fsl-imx8mq-phanbell; then export board="fsl-imx8mq-phanbell"; export maker="nxp"
	elif use meson-gxl-s905x-libretech-cc-v2 ; then export board="meson-gxl-s905x-libretech-cc-v2"; export maker="amlogic"
	elif use meson-sm1-s905d3-libretech-cc ; then export board="meson-sm1-s905d3-libretech-cc"; export maker="amlogic"
	elif use meson-g12b-a311d-libretech-cc ; then export board="meson-g12b-a311d-libretech-cc"; export maker="amlogic"
	else export board=""; export maker=""
	fi
	einfo "Assigned board: ${board}   maker: ${maker}"
}

newins_all() {
	selector="$1"
	for x in $(find ${S}/${board}/ -iname "${selector}"); do
		z="$(basename ${x})" ;
		newins "${x}" "${z}" ;
		elog "Installed (ins) ${z} into /boot/"
	done ;
}

src_install() {
# 'starter' versions of these files, will be CONFIG_PROTECTed
	einfo "Installing (ins) configuration files into /boot"
	insinto "/boot/"
	case ${maker} in
		"raspi" )
			einfo "Installing (ins) raspberry board .txt config files into /boot" ;
			# install cmdline.txt, config.txt and any other (e.g. README.txt) .txt files
			newins_all "*.txt" ;
			newenvd "${S}/config_protect-raspi" "99${PN}" ;;
		"rockchip"|"amlogic"|"nxp" )
			# install boot.cmd, boot.scr, and any other boot.* files
			einfo "Installing (ins) ${maker} board boot config files to /boot" ;
			newins_all "boot.*" ;
			# install joetooEnv.txt and any other (e.g. README.txt) .txt files
			einfo "Installing (ins) ${maker} board .txt config files to /boot" ;
			newins_all "*.txt" ;
			newenvd "${S}/config_protect-${maker}" "99${PN}" ;;
		* ) die "invalid maker assignment; board: [${board}] maker: [${maker}]"
	esac
}

pkg_postinst() {
	elog "${P} Installed boot config files in /boot/ --"
	elog ""
	elog "ver 0.0.1 was the initial ebuild; see FILESDIR/version_history"
	elog " 0.2.0 updates checkboot; starts migration of FILESDIR to myUtilities repo"
	elog " 0.2.1 adds support for meson-g12b-a311d-libretech-cc (alta)"
	elog " 0.2.2 adds support for meson-sm1-s905d3-libretech-cc (solitude)"
	elog " 0.2.3 provides refinements and bugfixes"
	elog " 0.2.4 adds rk3588-radxa-rock-5b+ and rk3588s-orangepi-5b"
	elog " 0.2.5 adds rk3399-rock-4se"
	elog ""
	case ${maker} in
		"raspi" )
			elog "  cmdline.txt -- kernel command line parameters" ;
			elog "  config.txt -- bootloader and overlay configuration options" ;
			elog "  https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md" ;
			elog "  https://www.raspberrypi.org/documentation/configuration/config-txt/README.md" ;;
		"rockchip"|"amlogic"|"nxp" )
			elog "  boot.scr -- compiled u-boot script (do not modify)." ;
			elog "  boot.cmd -- code from which boot.scr is compiled (do not modify)" ;
			elog "  joetooEnv.txt -- user-configurable u-boot environment variables" ;
			elog "  https://docs.u-boot.org/en/latest/" ;;
	esac
	elog ""
	elog "Thanks for using ${PN}"
}
