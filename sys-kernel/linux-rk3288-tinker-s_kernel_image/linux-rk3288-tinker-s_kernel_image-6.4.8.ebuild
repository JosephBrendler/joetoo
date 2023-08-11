# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="kernel image for my ASUS Tinkerboard S"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3288-tinker-s_kernel_image-6.4.8.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm"
IUSE="symlink"
RESTRICT="mirror"

RDEPEND="=sys-kernel/gentoo-sources-6.4.8"
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
		k=$(echo zImage-${PV}-gentoo)
		d=$(echo rk3288-tinker-s.dtb-${PV}-gentoo)
		[[ -L /boot/zImage ]] && kold=$(readlink /boot/zImage -f --canonicalize) || kold=$(echo zImage-$(uname -r))
		[[ -L /boot/rk3288-tinker-s.dtb ]] && dold=$(readlink /boot/rk3288-tinker-s.dtb -f --canonicalize) || dold=$(echo rk3288-tinker-s.dtb-$(uname -r))
		einfo "k = [${k}]"
		einfo "d = [${d}]"
		einfo "kold = [${kold}]"
		einfo "dold = [${dold}]"
		einfo "About to issue command: ln -snf ${kold} ${D}zImage.old "
		ln -snf "${kold}" "${D}"zImage.old
		einfo "About to issue command: ln -snf ${k} ${D}zImage "
		ln -snf "${k}" "${D}"zImage
		einfo "About to issue command: ln -snf ${dold} ${D}rk3288-tinker-s.dtb.old "
		ln -snf "${dold}" "${D}"rk3288-tinker-s.dtb.old
		einfo "About to issue command: ln -snf ${c} ${D}rk3288-tinker-s.dtb "
		ln -snf "${d}" "${D}"rk3288-tinker-s.dtb
		elog "Symlinks installed as requested"
	else
		ewarn "a symlink for your kernel has not been installed because of -symlink USE flag"
		elog ""
	fi
	elog "Thank you for using linux-rk3288-tinker-s_kernel_image"
}
