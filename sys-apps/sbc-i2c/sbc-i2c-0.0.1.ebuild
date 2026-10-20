# Copyright (c) 2022-2026 Joseph Brendler
# SPDX-License-Identifier: GPL-3.0-or-later
# Adapted from GenPi64 work by sakaki <sakaki@deciban.com>
# NO WARRANTY

EAPI=8

DESCRIPTION="udev rule to allow i2c group I2C access"
HOMEPAGE="https://github.com/joetoo"
#SRC_URI=""   # pkgcheck dislikes empty globals

S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"

KEYWORDS="~arm ~arm64"

#IUSE=""   # pkgcheck dislikes empty globals
RESTRICT="mirror"

#ACCT_DEPEND=""

RDEPEND="
	 acct-group/i2c
	>=virtual/udev-215
"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/99-i2c-group-access.rules"
}

pkg_postinst() {
	elog "Members of the i2c group may access I2C devices through the installed udev rule."
	elog "Add users to the i2c group if non-root I2C access is desired."
	elog ""
	elog "To use the i2c interface, ensure it is enabled in the board's"
	elog "boot/device-tree configuration (e.g. /boot/config.txt or /boot/joetooEnv.txt)"
	elog ""
	elog "Complete.  Thanks for using ${PN}"
}
