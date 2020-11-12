# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of my first ebuild with dependencies ...

EAPI=6

DESCRIPTION="A script header with easy-to-use formatting colors and misc functions"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/script_header_brendlefly-0.3.6.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
#KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE="extended niopt"

RDEPEND="extended? ( dev-util/script_header_brendlefly_extended )
	niopt? ( dev-util/script_header_brendlefly_noninteractive )"
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
	einfo "About to execute command cp -R "${S}/${PN}" "${D}"usr/local/sbin/"
	cp -v "${S}/${PN}" "${D}usr/local/sbin/" || die "Install failed!"
	elog "${PN} installed in /usr/local/sbin. Employ its functions by sourcing"
	elog "(e.g. # source /usr/local/sbin/script_header_brendlefly)"
	elog ""
	elog "Note: if you enabled the \"extended\" USE flag, then you may"
	elog "also source and employ the extended function set"
	elog "(e.g. # source /usr/local/sbin/script_header_brendlefly_extended)"
	elog ""
	elog "After sourcing, use the commands \"summarize_me\" and "
	elog "\"summarize_my_extension\" repectively for useful summary"
	elog "information about each package"
	elog ""
	elog "Note: version 0.2.0 introduces a new color() function which may be"
	elog "used to set foreground and background colors. It also includes a"
	elog "reverse video definition \"\${RVon}\""
	elog ""
	elog "Note: beginning with version 0.2.11, the binary search bs() and"
	elog "countdown() functions have been removed.  They can now be sourced"
	elog "with script_header_brendlefly_extended-0.1.2"
	elog ""
	elog "Note: beginning with version 0.3.0, you can check for an interactive"
	elog "shell with the checkshell() function, which will reset color if the"
	elog "current shell is not interactive"
	elog ""
	elog "Note: version 0.3.6 introduces the swr() function, which uses the"
	elog "pur() function to enable you to ssh-when-ready to a target host"
	elog ""
	elog "Thank you for using script_header"
}
