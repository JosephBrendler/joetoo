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
	bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus bcm2709-rpi-2-b
	rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2-s rk3588s-orangepi-5
"

REQUIRED_USE="
	^^ (
		bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus bcm2709-rpi-2-b
		rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2-s rk3588s-orangepi-5
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
        if use sbc ; then
                einfo "USE sbc is selected. Assigning board..."
                if use bcm2712-rpi-5-b ; then
                        export board="bcm2712-rpi-5-b"
                else if use bcm2711-rpi-4-b ; then
                        export board="bcm2711-rpi-4-b"
                else if use bcm2710-rpi-3-b-plus; then
                        export board="bcm2710-rpi-3-b-plus"
                else if use bcm2709-rpi-2-b; then
                        export board="bcm2709-rpi-2-b"
                else if use rk3288-tinker-s; then
                        export board="rk3288-tinker-s"
                else if use rk3399-rock-pi-4c-plus; then
                        export board="rk3399-rock-pi-4c-plus"
                else if use rk3399-tinker-2-s; then
                        export board="rk3399-tinker-2-s"
                else if use rk3588s-orangepi-5; then
                        export board="rk3588s-orangepi-5"
                else
                        export board=""
                fi; fi; fi; fi; fi; fi; fi; fi
                einfo "board: ${board}"
        fi
}

src_install() {
	elog "Installing (ins) into /etc/sbc-status-leds/"
	# install only the one .conf file needed
	insinto "/etc/sbc-status-leds/"
	newins "${FILESDIR}/sbc-status-leds-${board}.conf" "sbc-status-leds-${board}.conf"
	elog "  Installed (newins) sbc-status-leds-${board}.conf"
	# install the symlink to this .conf file
	dosym "sbc-status-leds-${board}.conf" "sbc-status-leds.conf"

	elog "Installing the joetoo sbc-status-leds.crontab file..."
	insinto "/etc/cron.d/"
	newins "${FILESDIR}/${PN}.crontab" "${PN}.crontab"
	elog "Installed (newins) ${PN}.crontab"

	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	newexe "${FILESDIR}/${PN}" "${PN}"
	elog "Installed (newexe) ${PN}"
	newexe "${FILESDIR}/test-${PN}" "test-${PN}"
	elog "Installed (newexe) test-${PN}"

	elog "Installing the joetoo sbc-status-leds.conf eselect module..."
	dodir "/usr/share/eselect/modules/"
	z="sbc-status-leds.eselect"
	einfo "About to execute command cp -v ${FILESDIR}/${z} ${D}/usr/share/eselect/modules/${z};"
	cp -v "${FILESDIR}/${z}" "${D}/usr/share/eselect/modules/${z}";
	elog "Done installing the joetoo sbc-status-leds.conf eselect module."
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
	elog ""
	elog "${PN} installed"
	elog ""
	elog "You can create additional configurations in /etc/sbc-status-leds"
	elog "Use eselect sbc-status-leds to pick one of them"
	elog ""
	elog ""
	elog "version 0.0.1 is the initial build"
	elog ""
	elog "Thank you for using ${PN}"
}
