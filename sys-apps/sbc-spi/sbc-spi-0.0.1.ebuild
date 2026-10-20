# Copyright (c) 2022-2026 Joseph Brendler
# SPDX-License-Identifier: GPL-3.0-or-later
# Adapted from GenPi64 work by sakaki <sakaki@deciban.com>
# NO WARRANTY

EAPI=8

DESCRIPTION="udev rule to allow spi group SPI access"
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
	acct-group/spi
	>=virtual/udev-215
"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/99-spi-group-access.rules"
}

pkg_postinst() {
	elog "Members of the spi group may access SPI devices through the installed udev rule."
	elog "Add users to the spi group if non-root SPI access is desired."
	elog ""
	elog "To use the SPI interface, ensure it is enabled in the board's"
	elog "boot/device-tree configuration (e.g. /boot/config.txt or /boot/joetooEnv.txt)"
	elog ""
	elog "Complete.  Thanks for using ${PN}"
}
