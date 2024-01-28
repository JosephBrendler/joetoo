# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="kernel image for my raspberry pi 3 model B+ embedded system(s)"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2710-rpi-3-b-plus_kernel_image-${PV}.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm"
IUSE="symlink"
RESTRICT="mirror"

RDEPEND="=sys-kernel/raspi-sources-${PV}"
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
		k=$(echo Image-${PV}-raspi)
		d=$(echo bcm2710-rpi-3-b-plus.dtb-${PV}-raspi)
		[[ -L /boot/Image ]] && kold=$(readlink /boot/Image -f --canonicalize) || kold=$(echo Image-$(uname -r))
		[[ -L /boot/bcm2710-rpi-3-b-plus.dtb ]] && dold=$(readlink /boot/bcm2710-rpi-3-b-plus.dtb -f --canonicalize) || dold=$(echo bcm2710-rpi-3-b-plus.dtb-$(uname -r))
		einfo "k = [${k}]"
		einfo "d = [${d}]"
		einfo "kold = [${kold}]"
		einfo "dold = [${dold}]"
		einfo "About to issue command: ln -snf ${kold} ${D}Image.old "
		ln -snf "${kold}" "${D}"Image.old
		einfo "About to issue command: ln -snf ${k} ${D}Image "
		ln -snf "${k}" "${D}"Image
		einfo "About to issue command: ln -snf ${dold} ${D}bcm2710-rpi-3-b-plus.dtb.old "
		ln -snf "${dold}" "${D}"bcm2710-rpi-3-b-plus.dtb.old
		einfo "About to issue command: ln -snf ${c} ${D}bcm2710-rpi-3-b-plus.dtb "
		ln -snf "${d}" "${D}"bcm2710-rpi-3-b-plus.dtb
		elog "Symlinks installed as requested"
	else
		ewarn "a symlink for your kernel has not been installed because of -symlink USE flag"
		elog ""
	fi
	elog "Thank you for using linux-bcm2710-rpi-3-b-plus_kernel_image"
}
