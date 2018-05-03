# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of one of my first ebuilds

EAPI=6

inherit eutils

DESCRIPTION="Extends script_header_brendlefly with line/box drawing functions"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/script_header_brendlefly_noninteractive-0.0.1.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
#KEYWORDS=""

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	# install utility script header in /usr/local/sbin
	elog "S=${S}"
	elog "D=${D}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog ""
	dodir usr/local/sbin/
	elog "About to execute command cp -R "${S}"/* "${D}"usr/local/sbin/"
	cp -v "${S}/${PN}" "${D}usr/local/sbin/" || die "Install failed!"
	elog "script_header_brendlefly_noninteractive has been installed in ${D}/usr/local/sbin/"
	elog "After sourcing script_header_brendlefly you may source this header"
	elog "to employ its functions."
	elog ""
	elog "Note: as of version 0.0.1, the only function is checkshell() which will reset"
	elog "colors if the current shell is not interactive"
	elog ""
	elog "Thank you for using scriptheader"
}
