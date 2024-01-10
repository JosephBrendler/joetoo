# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="11"

inherit kernel-2
detect_version
detect_arch

PYTHON_COMPAT=( python{3_10,3_11,3_12} )

inherit git-r3 distutils-r1

EGIT_REPO_URI="https://github.com/raspberrypi/linux.git"
EGIT_BRANCH="rpi-6.2.y"
EGIT_COMMIT="4c7938b86db7dfccbfd4d2a840091cbb7fbf2e9f"

# default to off because mpst raspis have vfat boot partition which can't support symlink
IUSE="-symlink"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"

DESCRIPTION="Raspberry Pi kernel sources"
HOMEPAGE="https://github.com/raspberrypi/linux"
HOMEPAGE+=" and https://dev.gentoo.org/~mpagano/genpatches"

KEYWORDS="~arm64"

LICENSE="MIT"

SLOT=0

pkg_setup() {
	ewarn ""
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the raspberrypi developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "EGIT_REPO_URI=${EGIT_REPO_URI}"
	einfo "EGIT_BRANCH=${EGIT_BRANCH}"
	einfo "EGIT_COMMIT=${EGIT_COMMIT}"

	git-r3_fetch ${EGIT_REPO_URI} ${EGIT_BRANCH} ${EGIT_COMMIT}

	# install sources
#	dodir /usr/src/linux-${PV}  && einfo "Created /usr/src/linux-${PV} with dodir"
#	einfo 'About to issue command: cp -R '${S}'/ '${D}'/usr/src/linux-${PV}/'
#		cp -R "${S}/" "${D}/usr/src/linux-${PV}/'" || die "Install failed!"
#	elog ""
#	elog "${PN} installed in ${D}/usr/src/linux-${PV}/"
}

pkg_postinst() {
        kernel-2_pkg_postinst
        einfo "For more info on this patchset, and how to report problems, see:"
        einfo "${HOMEPAGE}"
}

pkg_postrm() {
        kernel-2_pkg_postrm
	elog ""
	elog "This software in preliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}





