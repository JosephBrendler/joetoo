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
IUSE=""

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

src_install() {
	elog "Installing (ins) into /etc/sbc_status_leds/"
	insinto "/etc/sbc_status_leds/"
	for x in $(find ${FILESDIR}/ -iname ${PN}*.conf)
	do
		newins "${x}" "$(basename $x)" ;
		elog "  Installed (newins) $(basename $x)" ;
	done

	elog "Installing the joetoo sbc_status_leds.crontab file..."
	insinto "/etc/cron.d/"
	newins "${FILESDIR}/${PN}.crontab" "${PN}.crontab"
	elog "Installed (newins) ${PN}.crontab"

	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	newexe "${FILESDIR}/${PN}" "${PN}"
	elog "Installed (newexe) ${PN}"
	newexe "${FILESDIR}/test_${PN}" "test_${PN}"
	elog "Installed (newexe) test_${PN}"

	elog "Installing the joetoo sbc_status_leds.conf eselect module..."
	dodir "/usr/share/eselect/modules/"
	z="sbc_status_leds.eselect"
	einfo "About to execute command cp -v ${FILESDIR}/${z} ${D}/usr/share/eselect/modules/${z};"
	cp -v "${FILESDIR}/${z}" "${D}/usr/share/eselect/modules/${z}";
	elog "Done installing the joetoo sbc_status_leds.conf eselect module."
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
	elog "Remember to use eselect sbc_status_leds to configure"
	elog ""
	elog "version 0.0.1 is the initial build"
	elog ""
	elog "Thank you for using ${PN}"
}
