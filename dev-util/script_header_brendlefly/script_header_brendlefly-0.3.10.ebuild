# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of my first ebuild with dependencies ...

EAPI=7

DESCRIPTION="A script header with easy-to-use formatting colors and misc functions"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/script_header_brendlefly-${PV}.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
#KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE="extended niopt"
RESTRICT="mirror"

RDEPEND="extended? ( dev-util/script_header_brendlefly_extended )
	niopt? ( dev-util/script_header_brendlefly_noninteractive )"
BDEPEND="${RDEPEND}"

src_install() {
	# install utility script header in /usr/local/sbin
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	dodir usr/local/sbin/
	einfo "About to execute command cp -R "${S}/${PN}" "${D}"/usr/local/sbin/"
	cp -v "${S}/${PN}" "${D}/usr/local/sbin/" || die "Install failed!"
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
	elog "Note: version 0.3.7 updates the swr() function, to use nmap after pur(),"
	elog "to determine when the ssh port is open, to enable you to ssh-when-ready"
	elog "to a target host"
	elog ""
	elog "Note: version 0.3.8 moves watchdistcc to a dev-util/joetoolkit script"
	elog "and moves functions fe() #find-ebuild and which() # full-path-of-executable"
	elog "to this package"
	elog ""
	elog "version 0.3.9 removes which(), moved to dev-util/joetoolkit"
	elog "version 0.3.10 updates checkboot() to work on x86, x86_64, armv7l, and aarch64"
	elog ""
	elog "Thank you for using script_header"

}
