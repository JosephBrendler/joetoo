# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="create initramfs for LUKS encrypted / lmv system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/mkinitramfs-5.1-201701091530.tbz2"

#PN="mkinitramfs"
#PV="5.1"
#PR=1

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="bogus"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	# install utility scripts and baseline initramfs sources in /usr/src
	dodir /usr/src/${PN}
	cp -R "${S}/" "${D}/usr/src/" || die "Install failed!"
	einfo "Thank you for using mkinitramfs by Joe Brendler"
}
