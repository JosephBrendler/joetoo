# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the my first ebuild with dependencies ...

EAPI=6

DESCRIPTION="A script header with easy-to-use formatting colors and functions"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/script_header_brendlefly-0.0.2.tbz2"

S="${WORKDIR}/work/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
#KEYWORDS=""

# fix later - this is to automatically also pull in dev-util/script-header-brendlefly-extended
IUSE="extended"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	# install utility script header in /usr/local/sbin
	dodir /usr/local/sbin/
	cp -R "${S}" "${D}/usr/local/sbin/" || die "Install failed!"
	einfo "Thank you for using scriptheader"
	elog "This is a test of the elog function"
}
