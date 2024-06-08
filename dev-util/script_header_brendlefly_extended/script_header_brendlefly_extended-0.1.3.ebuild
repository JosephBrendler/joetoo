# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of one of my first ebuilds

EAPI=8

#inherit eutils

DESCRIPTION="Extends script_header_brendlefly with line/box drawing functions"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${P}.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
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
	elog "script_header_brendlefly_extended has been installed in ${D}/usr/local/sbin/"
	elog "After sourcing script_header_brendlefly you may source this header"
	elog "to employ its functions.  Run \"summarize_my_extension\" to list"
	elog "and see examples of this."
	elog ""
	elog "Note: beginning with version 0.1.2, the binary search bs() function and the"
	elog "countdown() function are now part of this (_extended) package rather than"
	elog "the basic script_header_brendlefly-0.2.11 or later."
	elog ""
	elog "Thank you for using scriptheader"
}
