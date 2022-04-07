# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned after 20w0 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

KEYWORDS="~arm ~arm64"

DESCRIPTION="Startup script to enable on-demand CPU frequency scaling on RPi3"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="-systemd"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-apps/openrc-0.41
	>=app-shells/bash-4.0"

src_install() {
	newinitd "${FILESDIR}/init.d_rpi3-ondemand-2" "rpi3-ondemand"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} || ${REPLACING_VERSIONS} < 1.1.0 ]]; then
		elog "Note: Migrated from genpi64 to joetoo beginning"
		elog "with version 1.1.2"
		elog ""
		elog "Please run:"
		elog "  rc-update add rpi3-ondemand sysinit"
		elog "to enable on-demand CPU frequency scaling"
	fi
}

