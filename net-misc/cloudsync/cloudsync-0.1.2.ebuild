# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of my first ebuild with dependencies ...

EAPI=6

DESCRIPTION="A very light wrapper to rsync content, scripts, and binary packages on home net"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/cloudsync-0.1.2.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
#KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE=""

RDEPEND="net-misc/rsync"
DEPEND="${RDEPEND}"

src_install() {
	# install utility script header in /usr/local/sbin
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	dodir usr/local/sbin/
	dodir /etc/
	einfo "About to execute command cp -R "${S}/*" "${D}"usr/local/sbin/"
	cp -v "${S}/*" "${D}usr/local/sbin/" || die "Install failed!"
	elog "${PN} installed in /usr/local/sbin"
	einfo "About to execute command cp -R "${S}/${PN}.conf" "${D}"etc/"
	cp -v "${S}/${PN}.conf" "${D}etc/" || die "Install failed!"
	elog "${PN}.conf installed in /etc"
## Note: I don't think there's a function like do/newconfd available to help with this...
	elog "The package is released for testing (~), but this ebuild is beta"
	elog ""
	elog "Thank you for using cloudsync"

}
