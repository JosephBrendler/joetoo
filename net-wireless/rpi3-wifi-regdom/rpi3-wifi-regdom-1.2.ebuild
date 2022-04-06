# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

KEYWORDS="~arm ~arm64"

DESCRIPTION="Service to setup WiFi regulatory domain on RPi3"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=net-wireless/iw-4.9
	>=sys-apps/openrc-0.41
	>=app-shells/bash-4.0"

src_install() {
	newinitd "${FILESDIR}/init.d_${PN}-1" "${PN}"
	newconfd "${FILESDIR}/conf.d_${PN}-1" "${PN}"
	insinto "/etc/modprobe.d"
	newins "${FILESDIR}/modprobe.d_${PN}-1" "${PN}.conf"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${PN}" default
		elog "The ${PN} service has been added to your default runlevel."
		elog "Please check /etc/conf.d/${PN}, and set an"
		elog "appropriate ISO / IEC 3166 alpha2 country code therein."
	fi
}
