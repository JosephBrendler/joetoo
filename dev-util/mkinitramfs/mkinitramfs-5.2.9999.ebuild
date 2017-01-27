# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the my first 9999 (bleeding edge) version ebuild

EAPI=6

DESCRIPTION="create initramfs for LUKS encrypted / lmv system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/mkinitramfs-5.2.9999.tbz2"

#PN="mkinitramfs"
#PV="5.2.9999"
#PR=""

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"

KEYWORDS=""
IUSE="bogus"

RDEPEND="dev-util/script_header_brendlefly"
DEPEND="${RDEPEND} 
	bogus? ( >=dev-util/bogus-2.0 )"

src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	# install utility scripts and baseline initramfs sources in /usr/src
	dodir /usr/src/${PN} && einfo "Created /usr/src/${PN} with dodir"
	einfo 'About to issue command: cp -R '${S}'/ '${D}'/usr/src/'
	cp -R "${S}/" "${D}/usr/src/" || die "Install failed!"
	einfo "Thank you for using mkinitramfs"
	elog "This is a test of the elog function"
}

