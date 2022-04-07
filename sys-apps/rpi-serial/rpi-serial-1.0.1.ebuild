# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

KEYWORDS="~arm ~arm64"

DESCRIPTION="udev rule to create appropriate serial port device alias(es)"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=virtual/udev-215
	>=app-shells/bash-4.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/99-serial-port-aliases.rules"
}

