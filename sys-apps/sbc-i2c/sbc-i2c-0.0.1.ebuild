# Copyright (c) 2022-2052 Joe Brendler
# Adapted from work abandoned by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

KEYWORDS="~arm ~arm64"

DESCRIPTION="udev rule to allow i2c group I2C access"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

ACCT_DEPEND="
	>=acct-group/i2c-0a
"
DEPEND="
	${ACCT_DEPEND}
	!sys-apps/rpi3-i2cdev
	>=sys-apps/openrc-0.41
	>=virtual/udev-215
	>=app-shells/bash-4.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/99-i2c-group-access.rules"
}

add_wheel_members_to_i2c_group() {
	local nextuser
	for nextuser in $(grep "^wheel:" /etc/group | cut -d: -f4 | tr "," " "); do
		usermod -a -G i2c ${nextuser}
	done
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Adding all members of wheel to the i2c group"
		add_wheel_members_to_i2c_group
	fi
	elog "Complete.  Thanks for using ${PN}"
}
