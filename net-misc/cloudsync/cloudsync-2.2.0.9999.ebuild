# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of my first ebuild with dependencies ...

EAPI=7

DESCRIPTION="A very light wrapper to rsync content, scripts, and binary packages on home net"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/cloudsync-${PV}.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86 ~arm"
#KEYWORDS=""

IUSE=""
RESTRICT="mirror"

RDEPEND="net-misc/rsync
	>=dev-util/script_header_brendlefly-0.3.0[niopt]"
BDEPEND="${RDEPEND}"

src_install() {
	# Note: utility script header still installs in /usr/local/sbin
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"
	# install utility in /usr/bin; .conf file in /etc/ ... note: both files, which
	# are named after ${PN} are also archived for distribution in a directory named ${PN}
	dodir usr/bin/
	einfo "About to execute command cp -R "${S}/${PN}/${PN}" "${D}"/usr/bin/"
	cp -v "${S}/${PN}/${PN}" "${D}/usr/bin/" || die "Install failed!"
	elog "${PN} installed in /usr/bin"
	dodir /etc/
	einfo "About to execute command cp -R "${S}/${PN}/${PN}.conf" "${D}"/etc/"
	cp -v "${S}/${PN}/${PN}.conf" "${D}/etc/" || die "Install failed!"
	elog "${PN}.conf installed in /etc"
	## Note: I don't think there's a function like do/newconfd available to help with this...
	elog ""
	elog "Starting with version 2.0, there are now distinct option flags for the"
	elog "push and pull (PUT and GET) functions. The default cloudsync.conf is"
	elog "distributed with both set FALSE.  To use cloudsync, you will need to"
	elog "either set PUT and/or GET to TRUE in your cloudsync.conf, or you will"
	elog "have to use the -p|--put and/or -g|--get flags among your commadn line"
	elog "option.  Also, keep this in mind if you run cloudsync as a cron job."
	elog ""
	elog "As of version 2.0.1, output generated by running cloudsync in a"
	elog "non-interactive shell should be decluttered of ascii color garbage"
	elog ""
	elog "Version 2.1.0 eliminated the variable MyPackageROOT in favor "
	elog "of reading the local PKGDIR variable directly from make.conf"
	elog ""
	elog "Version 2.2.0 corrected bugs in --exclude and updated cloudsync.conf"
	elog ""
	elog "Thank you for using cloudsync"

}