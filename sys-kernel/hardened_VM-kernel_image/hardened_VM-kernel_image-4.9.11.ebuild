# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="kernel image for my hardened gentoo VMs"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/hardened_VM-kernel_image-4.9.11.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm ~x86 ~amd64"
IUSE="symlink"

RDEPEND="=sys-kernel/hardened-sources-4.9.11"
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
	dodir /lib64 && einfo "Created /lib64 with dodir"
	einfo 'About to issue command: cp -R '${S}'boot '${D}
	cp -R "${S}boot" "${D}" || die "Install failed!"
	einfo 'About to issue command: cp -R '${S}'lib64 '${D}
	cp -R "${S}lib64" "${D}" || die "Install failed!"
	elog ""
	elog "kernel image has been copied to /boot/ and modules"
	elog "have been copied to /lib/modules/"
	elog ""
    # conditionally install the symlink
    if use symlink ; then
        elog "TO DO: here is where I would create the symlink..."
    else
        ewarn "a symlink for your kernel has not been installed because of -symlink USE flag"
        elog ""
    fi
	elog "Thank you for using vm-kernel-image"
}
