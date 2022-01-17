# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of my first ebuild with dependencies ...

EAPI=6

DESCRIPTION="A very light wrapper to rsync content, scripts, and binary packages on home net"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/cloudsync-2.0.0.9999.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86 ~arm"
#KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE=""

RDEPEND="net-misc/rsync
	>=dev-util/script_header_brendlefly-0.1.2-r2"
DEPEND="${RDEPEND}"

src_install() {
	# install utility script header in /usr/local/sbin
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	# install utility in /usr/local/bin; .conf file in /etc/ ... note: both files, which
	# are named after ${PN} are also archived for distribution in a directory named ${PN}
	dodir usr/local/bin/
	dodir /etc/
	einfo "About to execute command cp -R "${S}/${PN}/${PN}" "${D}"usr/local/bin/"
	cp -v "${S}/${PN}/${PN}" "${D}usr/local/bin/" || die "Install failed!"
	elog "${PN} installed in /usr/local/bin"
	einfo "About to execute command cp -R "${S}/${PN}/${PN}.conf" "${D}"etc/"
	cp -v "${S}/${PN}/${PN}.conf" "${D}etc/" || die "Install failed!"
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
	elog "Thank you for using cloudsync"

}
