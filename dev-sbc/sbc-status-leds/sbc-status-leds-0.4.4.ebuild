# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="joetoo program to run and configure sbc status leds"
HOMEPAGE="https://github.com/joetoo"
#SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${P}.tbz2" ## let -r1 get same source
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~amd64 arm ~arm arm64 ~arm64"
IUSE="
	bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-cm4-io bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-rock-4se rk3399-tinker-2
	rk3588-rock-5b rk3588-radxa-rock-5b+ rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	fsl-imx8mq-phanbell
	meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
	x4-n100
"
# required: one and only one of --
REQUIRED_USE="
	^^ (
		bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-cm4-io bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
		rk3288-tinker-s
		rk3399-rock-pi-4c-plus rk3399-rock-se rk3399-tinker-2
		rk3588-rock-5b rk3588-radxa-rock-5b+ rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
		fsl-imx8mq-phanbell
		meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
		x4-n100
	)
"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

BDEPEND=""

RDEPEND="
	${BDEPEND}
	>=dev-libs/libgpiod-1.6
	>=app-admin/eselect-1.4.27-r1
	x4-n100? (
		>=sys-devel/bc-1.08.1
		>=dev-util/serialtalk-1.2-r1
		dev-sbc/reflash_rp2
		)
"
# serialtalk now, not setserial
# >=sys-apps/setserial-2.17-r6

pkg_setup() {
	# for sbc systems we need to know which board we are using
	einfo "Assigning board..."
	if use bcm2712-rpi-cm5-cm5io ; then export board="bcm2712-rpi-cm5-cm5io"
	elif use bcm2712-rpi-5-b ; then export board="bcm2712-rpi-5-b"
	elif use bcm2711-rpi-cm4-io ; then export board="bcm2711-rpi-cm4-io"
	elif use bcm2711-rpi-4-b ; then export board="bcm2711-rpi-4-b"
	elif use bcm2710-rpi-3-b-plus; then export board="bcm2710-rpi-3-b-plus"
	elif use bcm2710-rpi-3-b; then export board="bcm2710-rpi-3-b"
	elif use bcm2709-rpi-2-b; then export board="bcm2709-rpi-2-b"
	elif use bcm2708-rpi-b; then export board="bcm2708-rpi-b"
	elif use rk3288-tinker-s; then export board="rk3288-tinker-s"
	elif use rk3399-rock-pi-4c-plus; then export board="rk3399-rock-pi-4c-plus"
	elif use rk3399-rock-4se; then export board="rk3399-rock-4se"
	elif use rk3399-tinker-2; then export board="rk3399-tinker-2"
	elif use rk3588-rock-5b; then export board="rk3588-rock-5b"
	elif use rk3588-radxa-rock-5b+; then export board="rk3588-radxa-rock-5b+"
	elif use rk3588s-orangepi-5; then export board="rk3588s-orangepi-5"
	elif use rk3588s-orangepi-5b; then export board="rk3588s-orangepi-5b"
	elif use rk3588s-rock-5c; then export board="rk3588s-rock-5c"
	elif use fsl-imx8mq-phanbell; then export board="fsl-imx8mq-phanbell"
	elif use meson-gxl-s905x-libretech-cc-v2; then export board="meson-gxl-s905x-libretech-cc-v2"
	elif use meson-sm1-s905d3-libretech-cc; then export board="meson-sm1-s905d3-libretech-cc"
	elif use meson-g12b-a311d-libretech-cc; then export board="meson-g12b-a311d-libretech-cc"
	elif use x4-n100; then export board="x4-n100"
	else export board=""
	fi
	einfo "board: ${board}"
}

src_install() {
	target="/etc/${PN}/"
	elog "Installing (ins) into ${target}"
	# install only the one .conf file needed
	insinto "${target}"
	newins "${S}/${PN}/${PN}-${board}.conf" "${PN}-${board}.conf"
	elog "  Installed (doins) ${PN}-${board}.conf"
	# install the symlink to this .conf file
	dosym "/etc/${PN}/${PN}-${board}.conf" "/etc/${PN}/${PN}.conf"
	elog "  Installed (dosym) ${PN}-${board}.conf"

	target="/etc/cron.d/"
	elog "Installing (ins) joetoo ${PN}.crontab file into ${target}"
	insinto "${target}"
	newins "${S}/${PN}/${PN}.crontab" "${PN}.crontab"
	elog "Installed (newins) ${PN}.crontab"

	target="/usr/sbin/"
	elog "Installing (exe) into ${target}"
	exeinto "${target}"
	if use x4-n100 ; then
		# install with regular names so the crontab will work unmodified, etc
		newexe "${S}/${PN}/x4-n100-${PN}" "${PN}"
		elog "Installed (newexe) x4-n100 version of ${PN}"
		newexe "${S}/${PN}/x4-n100-test-${PN}" "test-${PN}"
		elog "Installed (newexe) x4-n100 version of test-${PN}"
	else
		newexe "${S}/${PN}/${PN}" "${PN}"
		elog "Installed (newexe) ${PN}"
		newexe "${S}/${PN}/test-${PN}" "test-${PN}"
		elog "Installed (newexe) test-${PN}"
	fi

	if use x4-n100 ; then
		target="/etc/local.d/"
		elog "Installing (exe) into ${target}"
		exeinto "${target}"
		newexe "${S}/${PN}/etc_local-d_reflash_rp2-start" "reflash_rp2.start"
		elog "Installed (newexe) ${target%/}/reflash_rp2.start for x4-n100"
		newexe "${S}/${PN}/etc_local-d_serial_port_kick-start" "serial_port_kick.start"
		elog "Installed (newexe) ${target%/}/serial_port_kick.start for x4-n100"
	fi

	target="/usr/share/eselect/modules/"
	elog "Installing the joetoo ${PN}.conf eselect module in ${target}"
	dodir "${target}"
	z="${PN}.eselect"
	einfo "About to execute command cp -v ${S}/${PN}/${z} ${D}${target%/}/${z};"
	cp -v "${S}/${PN}/${z}" "${D}${target%/}/${z}";
	elog "Done installing the joetoo ${PN}.conf eselect module."
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "board=${board}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "You can create additional configurations in /etc/${PN}"
	elog "Use eselect ${PN} to pick one of them"
	elog ""
	elog "version_history is located in the ebuild's $FILESDIR"
	elog " 0.2.2 supports x4-n100 (amd64) sbc w onboard RP2040 microcontroller"
	elog " 0.2.3 provides bug fixes for x4-n100"
	elog " 0.2.4 takes temp from highest of multiple thermal zones"
	elog " 0.2.5 adds serialtalk to reset serial port for x4-n100; code update"
	elog " 0.2.6 makes the number of blinks configurable"
	elog " 0.2.7 moves serialtalk reset to /etc/local.d/serial_port_kick.start"
	elog " 0.3.0 moves sources to myUtilities and adds spt for rk3588-rock-5b"
	elog " 0.3.1 fixes missing .start files for x4"
	elog " 0.3.2 adds spt for bcm2711-rpi-cm4-io and bcm2712-rpi-cm5-cm5io"
	elog " 0.3.3 adds spt for meson-gxl-s905x-libretech-cc-v2 (sweet potato)"
	elog " 0.3.4 adds spt for fsl-imx8mq-phanbell (tinker edge t)"
	elog " 0.4.0 adds spt for meson-g12b-a311d-libretech-cc (alta)"
	elog " 0.4.1 adds spt for meson-sm1-s905d3-libretech-cc (solitude)"
	elog " 0.4.2 adds spt for rk3588-radxa-rock-5b+ and rk3588s-orangepi-5b"
	elog " 0.4.3 updates gpioset syntax"
	elog " 0.4.4 adds spt for rk3399-rock-se"
	elog ""
	if use x4-n100 ; then
		elog "USE x4-n100 selected.  Note that x4-n100-sbc-status-leds writes"
		elog "status data to a serial port (/dev/ttyS4) assuming that a"
		elog "firware program (e.g. pwm_status.c) has been compiled and flashed"
		elog "to the rp2040.  You must do so if that has not yet been done."
		elog "To Do: put such rp2040 firmware e.g. pwn_status.c in a package"
		elog "For now, see this wiki page:"
		elog "   https://wiki.gentoo.org/wiki/User:Brendlefly62/Radxa_x4_N100_sbc_with_RP2040"
	fi
	elog ""
	elog "Thank you for using ${PN}"
}
