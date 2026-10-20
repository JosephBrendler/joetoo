# Copyright (c) 2022-2026 Joseph Brendler
# SPDX-License-Identifier: GPL-3.0-or-later
# Adapted from GenPi64 work by sakaki <sakaki@deciban.com>
# NO WARRANTY

EAPI=8

DESCRIPTION="udev rules to allow gpio group GPIO access"
HOMEPAGE="https://github.com/joetoo"
#SRC_URI=""   # pkgcheck dislikes empty globals

S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"

#KEYWORDS="~arm ~arm64"

#IUSE=""   # pkgcheck dislikes empty globals
RESTRICT="mirror"

#ACCT_DEPEND=""

RDEPEND="
	acct-group/gpio
	>=virtual/udev-215
"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/99-gpio-group-access.rules"
}

pkg_postinst() {
	elog "Members of the gpio group may access gpio devices through the installed udev rule."
	elog "Add users to the gpio group if non-root gpio access is desired."
	elog "Complete.  Thanks for using ${PN}"
}
