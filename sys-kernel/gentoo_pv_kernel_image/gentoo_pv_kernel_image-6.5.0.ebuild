# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="kernel image for my gentoo pv VMs"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/gentoo_pv_kernel_image-6.5.0.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm ~x86 ~amd64"
IUSE="symlink"
RESTRICT="mirror"

RDEPEND="=sys-kernel/gentoo-sources-6.5.0"
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
	elog "kernel image has been copied to /boot/ and modules"
	elog "have been copied to /lib/modules/"
	elog ""
	# conditionally install the symlink
	if use symlink ; then
		k=$(echo vmlinuz-${PV}-gentoo)
		c=$(echo config-${PV}-gentoo)
		s=$(echo System.map-${PV}-gentoo)
		[[ -L /boot/vmlinuz ]] && kold=$(readlink /boot/vmlinuz -f --canonicalize) || kold=$(echo vmlinuz-$(uname -r))
		[[ -L /boot/config ]] && cold=$(readlink /boot/config -f --canonicalize) || cold=$(echo config-$(uname -r))
		[[ -L /boot/System.map ]] && sold=$(readlink /boot/System.map -f --canonicalize) || sold=$(echo System.map-$(uname -r))
		einfo "k = [${k}]"
		einfo "c = [${c}]"
		einfo "s = [${s}]"
		einfo "kold = [${kold}]"
		einfo "cold = [${cold}]"
		einfo "sold = [${sold}]"
		einfo "About to issue command: ln -snf ${kold} ${D}vmlinuz.old "
		ln -snf "${kold}" "${D}"vmlinuz.old
		einfo "About to issue command: ln -snf ${k} ${D}vmlinuz "
		ln -snf "${k}" "${D}"vmlinuz
		einfo "About to issue command: ln -snf ${cold} ${D}config.old "
		ln -snf "${cold}" "${D}"config.old
		einfo "About to issue command: ln -snf ${c} ${D}config "
		ln -snf "${c}" "${D}"config
		einfo "About to issue command: ln -snf ${sold} ${D}System.map.old "
		ln -snf "${sold}" "${D}"System.map.old
		einfo "About to issue command: ln -snf ${s} ${D}System.map "
		ln -snf "${s}" "${D}"System.map
		elog "Symlinks installed as requested"
	else
		ewarn "a symlink for your kernel has not been installed because of -symlink USE flag"
		elog ""
	fi
	elog "Thank you for using gentoo_pv_kernel_image"
}
