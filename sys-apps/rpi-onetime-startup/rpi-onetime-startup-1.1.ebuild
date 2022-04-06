# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

KEYWORDS="~arm ~arm64"

DESCRIPTION="Run one-time startup script, if present"
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
	>=sys-apps/openrc-0.41
	>=app-shells/bash-4.0"

src_install() {
	newinitd "${FILESDIR}/init.d_${PN}-2" "${PN}"
	exeinto /boot
	newexe "${FILESDIR}/startup.sh-2" "startup.sh"
	newenvd "${FILESDIR}"/config_protect-1 99${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${PN}" default
		elog "The ${PN} service has been added to your default runlevel."
	fi
}
