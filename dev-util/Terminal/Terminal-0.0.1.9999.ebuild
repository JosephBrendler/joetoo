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
#KEYWORDS=""
IUSE="examples"

RDEPEND=""
DEPEND="${RDEPEND}"

src_compile() {
	elog 'About to issue command: emake DESTDIR="${D}"'
	emake DESTDIR="${D}"
}

src_install() {
	elog "S=${S}"
	elog "D=${D}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog "RDEPEND=${RDEPEND}"
	elog "DEPEND=${DEPEND}"
	elog "KEYWORDS=${KEYWORDS}"
	elog "IUSE=${IUSE}"
	if use examples ; then
		elog "  (USE=\"examples\") (set)"
	else
		elog "  (USE=\"-examples\") (unset)"
	fi
	elog ""

	# install the shared object library in /usr/lib/
	dodir /usr/lib/ && elog "Created ${D}/usr/lib/ with dodir"
	dodir /usr/local/bin/ && elog "Created ${D}/usr/local/bin/ with dodir"
	dodir /usr/include/ && elog "Created ${D}/usr/include/ with dodir"
	# Instead of using emake DESTDIR="${D}" install, which causes sandbox errors because"
	# the Makefile writes directly to the live filesystem, just copy the file(s)
	elog 'About to issue command: cp -R '${S}'/libTerminal.so '${D}'/usr/lib/'
	cp -v "${S}/libTerminal.so" "${D}/usr/lib/" || die "Install failed!"
	elog "The shared object file libTerminal.so has been installed in /usr/lib/"
	elog ""
	elog 'About to issue command: cp -R '${S}'/Terminal.h '${D}'/usr/include/'
	cp -v "${S}/Terminal.h" "${D}/usr/include/" || die "Install failed!"
	elog ""
	elog 'About to issue command: cp -R '${S}'/colorHeader.h '${D}'/usr/include/'
	cp -v "${S}/colorHeader.h" "${D}/usr/include/" || die "Install failed!"
	elog "Terminal.h and colorHeader.h have been installed in /usr/include/"
	elog ""

	# conditionally install the example executables in /usr/local/bin/
	if use examples ; then
		elog 'About to issue command: cp -R '${S}'/terminalLibTest '${D}'/usr/local/bin/'
		cp -v "${S}/terminalLibTest" "${D}/usr/local/bin/" || die "Install failed!"
		elog 'About to issue command: cp -R '${S}'/progress '${D}'/usr/local/bin/'
		cp -v "${S}/progress" "${D}/usr/local/bin/" || die "Install failed!"
		elog 'About to issue command: cp -R '${S}'/progress-example.sh '${D}'/usr/local/bin/'
		cp -v "${S}/progress-example.sh" "${D}/usr/local/bin/" || die "Install failed!"
		elog "The example executables terminalLibTest and progress"
		elog "have been installed in /usr/local/bin/"
		elog ""
	else
		ewarn "The example executables terminalLibTest and progress"
		ewarn "were not installed because of -examples USE flag"
		elog ""
	fi

	elog "Thank you for using Terminal"
	elog ""
}
