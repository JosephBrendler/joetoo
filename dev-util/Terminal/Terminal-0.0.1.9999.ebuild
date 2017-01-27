# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the my first 9999 (bleeding edge) version ebuild

EAPI=6

DESCRIPTION="c++ shared obj lib for ANSI & UNICODE terminal control, w/ optional examples"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/Terminal-0.0.1.tbz2"

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"

#KEYWORDS="~amd64 ~x86 ~arm"
KEYWORDS=""
IUSE="examples"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	einfo "KEYWORDS=${KEYWORDS}"
	einfo "IUSE=${IUSE}"
	if use examples ; then
		einfo "  (USE=\"examples\")"
	else
		einfo "  (USE=\"-examples\")"
	fi

	# install the shared object library in /usr/lib/
	dodir /usr/lib/ && einfo "Created /usr/lib/ with dodir"
	dodir /usr/local/bin/ && einfo "Created /usr/local/bin/ with dodir"
	einfo 'About to issue command: emake DESTDIR="${D}"'
	emake DESTDIR="${D}"
	einfo 'About to issue command: emake DESTDIR="${D}" install'
	emake DESTDIR="${D}" install
	elog "The shared object file libTerminal.so has been installed in /usr/lib/"

	# conditionally install the example executables in /usr/local/bin/
	if use examples ; then
		einfo 'About to issue command: emake DESTDIR="${D}" examples_install'
		emake DESTDIR="${D}" examples_install
		elog "The example executables terminalLibTest and progress"
		elog "have been installed in /usr/local/bin/"
	else
		elog "The example executables terminalLibTest and progress"
		elog "were not installed because of -examples USE flag"
	fi

	elog "Thank you for using Terminal"
}

