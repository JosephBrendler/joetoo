# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="create initramfs for LUKS encrypted / lmv system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/mkinitramfs-5.7.9999.tbz2"

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"

KEYWORDS=""
IUSE="bogus"

RDEPEND=">=dev-util/script_header_brendlefly-0.3.1
	>=sys-apps/which-2.21
	>=app-misc/pax-utils-1.1.7
	>=sys-libs/glibc-2.23
	>=sys-apps/file-5.29"
DEPEND="${RDEPEND}"
#	bogus? ( >=dev-util/bogus-2.0 )"

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
	elog ""
	elog "mkinitramfs-5.4 was a significant rewrite of the package."
	elog "version 5.5 corrects errors due to new busybox limitations."
	elog ""
	elog "Please report any bugs you find to the maintainer."
	elog ""
	elog "Thank you for using mkinitramfs"
}
