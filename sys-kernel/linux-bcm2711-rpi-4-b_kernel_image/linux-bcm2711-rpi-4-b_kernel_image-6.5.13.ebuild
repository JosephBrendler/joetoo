# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="kernel image for my raspberry pi 4 model B embedded system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2711-rpi-4-b_kernel_image-6.5.1.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm"
IUSE="symlink"
RESTRICT="mirror"

RDEPEND="=sys-kernel/gentoo-sources-6.5.1"
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
		k=$(echo Image-${PV}-gentoo)
		d=$(echo bcm2711-rpi-4-b.dtb-${PV}-gentoo)
		[[ -L /boot/Image ]] && kold=$(readlink /boot/Image -f --canonicalize) || kold=$(echo Image-$(uname -r))
		[[ -L /boot/bcm2711-rpi-4-b.dtb ]] && dold=$(readlink /boot/bcm2711-rpi-4-b.dtb -f --canonicalize) || dold=$(echo bcm2711-rpi-4-b.dtb-$(uname -r))
		einfo "k = [${k}]"
		einfo "d = [${d}]"
		einfo "kold = [${kold}]"
		einfo "dold = [${dold}]"
		einfo "About to issue command: ln -snf ${kold} ${D}Image.old "
		ln -snf "${kold}" "${D}"Image.old
		einfo "About to issue command: ln -snf ${k} ${D}Image "
		ln -snf "${k}" "${D}"Image
		einfo "About to issue command: ln -snf ${dold} ${D}bcm2711-rpi-4-b.dtb.old "
		ln -snf "${dold}" "${D}"bcm2711-rpi-4-b.dtb.old
		einfo "About to issue command: ln -snf ${c} ${D}bcm2711-rpi-4-b.dtb "
		ln -snf "${d}" "${D}"bcm2711-rpi-4-b.dtb
		elog "Symlinks installed as requested"
	else
		ewarn "a symlink for your kernel has not been installed because of -symlink USE flag"
		elog ""
	fi
	elog "Thank you for using linux-bcm2711-rpi-4-b_kernel_image"
}
