# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="kernel image for my raspberry pi 4 model B embedded system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2711-rpi-4-b_kernel_image-${PV}.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm"
IUSE="-symlink +sources"
RESTRICT="mirror"

RDEPEND="
	sources? ( =sys-kernel/raspi-sources-${PV} )
"

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
	if use symlink ; then
		elog "  (USE=\"symlink\") (set)"
	else
		elog "  (USE=\"-symlink\") (unset)"
	fi
	# install kernel and associated modules
	dodir / && einfo "Created / with dodir"
	dodir /boot && einfo "Created /boot with dodir"
	dodir /lib && einfo "Created /lib with dodir"
	einfo 'About to issue command: cp -R '${S}'boot '${D}
	cp -R "${S}boot" "${D}" || die "Install failed!"
	einfo 'About to issue command: cp -R '${S}'lib '${D}
	cp -R "${S}lib" "${D}" || die "Install failed!"
	elog ""
	elog "kernel image and dtb file have been copied to /boot/ and modules"
	elog "have been copied to /lib/modules/"
	elog ""
	# conditionally install the symlink
	if use symlink ; then
		elog "USE symlinks was set, but that doesn't work yet"
		elog ""
	else
		ewarn "a symlink for your kernel has not been installed because of -symlink USE flag"
		elog ""
	fi
	elog "Thank you for using linux-bcm2711-rpi-4-b_kernel_image"
}
