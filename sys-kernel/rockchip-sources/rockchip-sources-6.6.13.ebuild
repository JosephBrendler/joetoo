# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# joe brendler  29 January 2024
#
# Note: this is not like raspi-sources (which is git)
# to examine before building an ebuild...
# cd /home/joe/rockchip-sources
# rm -rf linux
# wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${PN}.tar.xz
# tar xvpf linux-${PN}.tar.xz
# cd linux
# make kernelversion  ## copy to use as ${PN}
#

EAPI=8
MyV=$(ver_cut 1)
DESCRIPTION="kernel sources for ASUS tinkerboard embedded system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://cdn.kernel.org/pub/linux/kernel/v${MyV}.x/linux-${PV}.tar.xz"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm ~arm64"
IUSE="symlink"
RESTRICT="mirror"

IUSE="-symlink"

LICENSE="MIT"

SLOT=0

pkg_setup() {
	ewarn "Now in pkg_setup()"
	ewarn ""
	ewarn "${PN} is *not* associated with the Gentoo Kernel Project"
	ewarn "${PN} installs raw kernel sources directly from cdn.kernel.org"
	ewarn "If you need support, please contact upstream kernel developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""

	einfo "S=${S}"
	My_P="linux-${PV}-tinker"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "My_P=${My_P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "WORKDIR=${WORKDIR}"
	einfo "ED=${ED}"
	einfo ""
	einfo "Done pkg_setup()"
}

src_install() {
	einfo "Now in src_install()"
	einfo "About to install sources in /usr/src/${My_P}/..."
	dodir /usr/src/
	cp -R ${S}/${MyP}/* ${D}/usr/src/
}

pkg_postinst() {
	einfo "Now in pkg_postinst()"
	elog ""
	elog "This software in preliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
