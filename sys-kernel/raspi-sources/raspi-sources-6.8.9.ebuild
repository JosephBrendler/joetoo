# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# joe brendler  14 June  2024
#
# this is a complete rewrite, dropping the EGIT_REPO_URI method that too often times out
#
# To update, follow README instructions in /home/joe/raspi-sources to create a new
#   branch clone and then follow README-tar-command instructions to create a tbz2 archive.
# When you have new version-numbered tbz2 file, just copy this file to create a new ebuild
#   with the new version number

EAPI=8

DESCRIPTION="kernel sources for broadcom raspi SOC based single board computers (SBCs)"
HOMEPAGE="https://github.com/raspberrypi/linux"
HOMEPAGE+=" https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raspi56406.brendler/raspi-sources/linux-${PV}-raspi.tbz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm ~arm64"
IUSE="symlink"
RESTRICT="mirror"

IUSE="symlink config"

LICENSE="MIT"

#SLOT=0   ### defaults to multislot for kernel sources

pkg_setup() {
	ewarn "Now in pkg_setup()"
	ewarn ""
	ewarn "${PN} is *not* associated with the Gentoo Kernel Project"
	eward "${PN} simply installs the raspberry pi foundation's kernel sources"
	ewarn "If you need support, please contact the raspberrypi developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""

	einfo "S=${S}"
	einfo "DIRNAME=${DIRNAME}"
	einfo "BASENAME=${BASENAME}"
	My_P="linux-${PV}-raspi"
	einfo "D=${D}"
	einfo "T=${T}"
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
	einfo "Installing (ins) sources [ ${My_P} ] into /usr/src/ ..."
	insinto "/usr/src/"
	doins -r "${S}/${My_P}"
	elog "Installed sources [ ${My_P} ] into /usr/src/"
	if use symlink ; then
		einfo "symlink USE flag is set, installing symlink ..."
		dosym /usr/src/${My_P} /usr/src/linux
		elog "Installed symlink in /usr/src/  ${My_P} <-- linux"
	fi
	einfo "sys-apps/portage and some other packages want to inspect kernel"
	einfo "configuration by reading .config in /usr/src/linux/ ..."
	if use config; then
		# put config in sources
		einfo "Installing (ins) .config into /usr/src/${My_P}/"
		[ ! -e /proc/config.gz ] && modprobe configs
		zcat /proc/config.gz > ${T}/.config
		insinto "/usr/src/${My_P}"
		newins "${T}/.config" ".config"
		elog "Installed .config in /usr/src/${My_P}"
	else
		elog "use config not selected; not installing .config in sources"
	fi
}

pkg_postinst() {
	einfo "Now in pkg_postinst()"
	elog ""
	elog "This software in preliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
