# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

model="rk3399-rock-4c-plus"
image="Image"

DESCRIPTION="kernel image for my Radxa Rock 4c Plus SBC"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-${model}_kernel_image-${PV}.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm"
IUSE="symlink"
RESTRICT="mirror"

# to do - implement a sources package for this SBC
BDEPEND=""
RDEPEND="${BDEPEND}"

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
		k=$(echo ${image}-${PV}-gentoo)
		d=$(echo ${model}.dtb-${PV}-gentoo)
		# to do - deak with this when links don't exist
		[[ -L /boot/${image} ]] && kold=$(readlink /boot/${image} -f --canonicalize)
		[[ -L /boot/${model}.dtb ]] && dold=$(readlink /boot/${model}.dtb -f --canonicalize)
		einfo "k = [${k}]"
		einfo "d = [${d}]"
		einfo "kold = [${kold}]"
		einfo "dold = [${dold}]"
		einfo "About to issue command: ln -snf ${kold} ${D}${image}.old "
		ln -snf "${kold}" "${D}"${image}.old
		einfo "About to issue command: ln -snf ${k} ${D}${image} "
		ln -snf "${k}" "${D}"${image}
		einfo "About to issue command: ln -snf ${dold} ${D}${model}.dtb.old "
		ln -snf "${dold}" "${D}"${model}.dtb.old
		einfo "About to issue command: ln -snf ${d} ${D}${model}.dtb "
		ln -snf "${d}" "${D}"${model}.dtb
		elog "Symlinks installed as requested"
	else
		ewarn "a symlink for your kernel has not been installed because of -symlink USE flag"
		elog ""
	fi
	elog "Thank you for using linux-${model}_kernel_image"
}
