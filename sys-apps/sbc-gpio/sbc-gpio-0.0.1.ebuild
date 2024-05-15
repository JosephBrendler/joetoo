# Copyright (c) 2022-2052 Joe Brendler
# Adapted from abandoned work of sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

KEYWORDS="~arm ~arm64"

DESCRIPTION="udev rules to allow gpio group GPIO access"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

ACCT_DEPEND="
	>=acct-group/gpio-0a
"
DEPEND="
	${ACCT_DEPEND}
	>=virtual/udev-215
	>=app-shells/bash-4.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/99-gpio-group-access.rules"
}

add_wheel_members_to_gpio_group() {
	local nextuser
	for nextuser in $(grep "^wheel:" /etc/group | cut -d: -f4 | tr "," " "); do
		usermod -a -G gpio ${nextuser}
	done
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Adding all members of wheel to the gpio group"
		add_wheel_members_to_gpio_group
	fi
}
