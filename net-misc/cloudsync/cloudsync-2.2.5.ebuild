# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of my first ebuild with dependencies ...

EAPI=7

DESCRIPTION="A very light wrapper to rsync content, scripts, and binary packages on home net"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

# updated to include PN 6/25/2025 for ver 2.2.2
S="${WORKDIR%/}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~amd64 arm ~arm arm64 ~arm64"

IUSE=""
RESTRICT="mirror"

RDEPEND="net-misc/rsync
	dev-util/script_header_joetoo[niopt]"
BDEPEND="${RDEPEND}"

src_install() {
	# Note: utility script header still installs in /usr/local/sbin
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	# install utility in /usr/bin; .conf file in /etc/
	dodir usr/bin/
	einfo "About to execute command cp -R "${S}/${PN}" "${D}"/usr/bin/"
	cp -v "${S}/${PN}" "${D}/usr/bin/" || die "Install failed!"
	elog "${PN} installed in /usr/bin"
	dodir /etc/
	einfo "About to execute command cp -R "${S}/${PN}.conf" "${D}"/etc/"
	cp -v "${S}/${PN}.conf" "${D}/etc/" || die "Install failed!"
	elog "${PN}.conf installed in /etc"
	elog ""

	elog "${P} installed"
	elog "version 2.0 config adds PUT/GET set false; use -p|-g cmdline opt to set"
	elog " 2.0.1 declutters output of ascii color garbage"
	elog " 2.1.0 reads the local PKGDIR variable directly from make.conf"
	elog " 2.2.0 corrects bugs in --exclude and updated cloudsync.conf"
	elog " 2.2.1 moves sources to net-misc category in myUtilities repo"
	elog " 2.2.2/3 change to /usr/sbin/script_header_joetoo"
	elog " 2.2.5 updates cloudsync.conf line joetoo-base/joetoo-common-meta"
	elog ""
	elog " 6.6.2 vice grep ^PORTDIR now source make.conf which may e.g. =\${ROOT}var/db/..."
	elog "Thank you for using ${PN}"
}
