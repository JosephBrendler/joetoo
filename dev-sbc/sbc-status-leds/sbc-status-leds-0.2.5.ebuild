# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="joetoo program to run and configure sbc status leds"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~amd64 arm ~arm arm64 ~arm64"
IUSE="
	bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 rk3588s-rock-5c
	x4-n100
"
# required: one and only one of --
REQUIRED_USE="
	^^ (
		bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
		rk3288-tinker-s
		rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 rk3588s-rock-5c
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
		>=sys-apps/setserial-2.17-r6
		)
"

pkg_setup() {
	# for sbc systems we need to know which board we are using
	einfo "Assigning board..."
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
	else if use rk3588s-rock-5c; then
		export board="rk3588s-rock-5c"
	else if use x4-n100; then
		export board="x4-n100"
	else
		export board=""
	fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi
	einfo "board: ${board}"
}

src_install() {
	elog "Installing (ins) into /etc/${PN}/"
	# install only the one .conf file needed
	insinto "/etc/${PN}/"
	newins "${FILESDIR}/${PN}-${board}.conf" "${PN}-${board}.conf"
	elog "  Installed (doins) ${PN}-${board}.conf"
	# install the symlink to this .conf file
	dosym "/etc/${PN}/${PN}-${board}.conf" "/etc/${PN}/${PN}.conf"
	elog "  Installed (dosym) ${PN}-${board}.conf"

	elog "Installing the joetoo ${PN}.crontab file..."
	insinto "/etc/cron.d/"
	newins "${FILESDIR}/${PN}.crontab" "${PN}.crontab"
	elog "Installed (newins) ${PN}.crontab"

	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	if use x4-n100 ; then
		# install with regular names so the crontab will work unmodified, etc
		newexe "${FILESDIR}/x4-n100-${PN}" "${PN}"
		elog "Installed (newexe) x4-n100 version of ${PN}"
		newexe "${FILESDIR}/x4-n100-test-${PN}" "test-${PN}"
		elog "Installed (newexe) x4-n100 version of test-${PN}"
	else
		newexe "${FILESDIR}/${PN}" "${PN}"
		elog "Installed (newexe) ${PN}"
		newexe "${FILESDIR}/test-${PN}" "test-${PN}"
		elog "Installed (newexe) test-${PN}"
	fi

	elog "Installing the joetoo ${PN}.conf eselect module..."
	dodir "/usr/share/eselect/modules/"
	z="${PN}.eselect"
	einfo "About to execute command cp -v ${FILESDIR}/${z} ${D}/usr/share/eselect/modules/${z};"
	cp -v "${FILESDIR}/${z}" "${D}/usr/share/eselect/modules/${z}";
	elog "Done installing the joetoo ${PN}.conf eselect module."
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
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
	elog " 0.2.5 adds setserial to reset serial port for x4-n100"
	elog ""
	if use x4-n100 ; then
		elog "USE x4-n100 selected.  Note that x4-n100-sbc-status-leds writes"
		elog "status data to a serial port (/dev/ttyS4) assuming that a"
		elog "firware program (e.g. pwn_status.c) has been compiled and flashed"
		elog "to the rp2040.  You must do so if that has not yet been done."
		elog "To Do: put such rp2040 firmware e.g. pwn_status.c in a package"
		elog "For now, see this wiki page:"
		elog "   https://wiki.gentoo.org/wiki/User:Brendlefly62/Radxa_x4_N100_sbc_with_RP2040"
	fi
	elog ""
	elog "Thank you for using ${PN}"
}
