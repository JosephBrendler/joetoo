# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="create initramfs for LUKS encrypted / lmv system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/mkinitramfs-5.3.0.tbz2"

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~arm"
IUSE="bogus"

RDEPEND=">=dev-util/script_header_brendlefly-0.1.2-r2
	>=sys-libs/glibc-2.23"
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

	# install utility scripts and baseline initramfs sources in /usr/src
	dodir /usr/src/${PN} && einfo "Created /usr/src/${PN} with dodir"
	einfo 'About to issue command: cp -R '${S}'/ '${D}'/usr/src/'
	cp -R "${S}/" "${D}/usr/src/" || die "Install failed!"
	elog "Thank you for using mkinitramfs"
}
