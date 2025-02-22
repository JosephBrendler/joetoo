# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="joetoo program to run and configure sbc status leds"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"
IUSE="
	bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 rk3588s-rock-5c
"

REQUIRED_USE="
	^^ (
		bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
		rk3288-tinker-s
		rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 rk3588s-rock-5c
	)
"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

BDEPEND="
	>=dev-libs/libgpiod-2.1
	>=app-admin/eselect-1.4.27-r1
"

# to do: version 0.0.4 starts migration of required packages to joetoo
#   so you won't need the genpi overlay
RDEPEND="
	${BDEPEND}
"

pkg_setup() {
	# for sbc systems we need to know which board we are using
	einfo "USE sbc is selected. Assigning board..."
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
	else
		export board=""
	fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi
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
	newexe "${FILESDIR}/${PN}" "${PN}"
	elog "Installed (newexe) ${PN}"
	newexe "${FILESDIR}/test-${PN}" "test-${PN}"
	elog "Installed (newexe) test-${PN}"

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
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"
	einfo "board=${board}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "You can create additional configurations in /etc/${PN}"
	elog "Use eselect ${PN} to pick one of them"
	elog ""
	elog ""
	elog "version 0.0.1 is the initial build"
	elog " 0.0.2 refactors for rk3399-tinker-2 board name"
	elog " 0.0.3 adds code to check and if needed, restart network interface(s)"
	elog " 0.0.4 adds support for original rpi model b (bcm2708-rpi-b)"
	elog " 0.0.5 changes yellow service-check led, now off = good on = problem"
	elog " 0.1.0 makes all checks optional (sent in .conf)"
	elog " 0.1.1 adds support for rpi 3 model b v1.2 (32bit) (bcm2710-rpi-3-b)"
	elog " 0.1.2/3 adds/updates support for Rock 5c (64bit) (rk3588s-rock-5c)"
	elog " 0.2.0 fixes vpn check/restart algorithm"
	elog ""
	elog "Thank you for using ${PN}"
}
