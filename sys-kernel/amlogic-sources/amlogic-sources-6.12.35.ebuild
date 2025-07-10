# Copyright 2025-2055 joe brendler
# Distributed under the terms of the GNU General Public License v3
# joe brendler  7 July 2025
#
# To update, follow README instructions in /home/joe/amlogic-sources to create a new
#   branch clone and then create a tbz2 archive and just copy this file to create a new ebuild
#   with the new version number

EAPI=8

DESCRIPTION="kernel sources for libre computer amlogic SOC based single board computers (SBCs)"
HOMEPAGE="https://github.com/libre-computer-project/libretech-linux/tree/master"
HOMEPAGE+=" https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raspi56406.brendler/amlogic-sources/linux-${PV}-amlogic.tbz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="${PV}"

KEYWORDS="~arm ~arm64"
IUSE="symlink config"
RESTRICT="mirror"

#SLOT=0   ### defaults to multislot for kernel sources

pkg_setup() {
	ewarn "Now in pkg_setup()"
	ewarn ""
	ewarn "${PN} is *not* associated with the Gentoo Kernel Project"
	ewarn "${PN} simply installs the Libre Computer Project's Amlogic kernel sources"
	ewarn "If you need support, please contact the Libre Computer developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""

	My_P="linux-${PV}-amlogic"

	einfo "S=${S}"
	einfo "D=${D}"
	einfo "T=${T}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "A=${A}"
	einfo "My_P=${My_P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "WORKDIR=${WORKDIR}"
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
		zcat /proc/config.gz > ${T}/.config || ewarn 'failed to zcat /proc/config.gz > ${T}/.config'
		insinto "/usr/src/${My_P}"
		newins "${T}/.config" ".config"
		elog "Installed .config in /usr/src/${My_P}"
	else
		elog "use config not selected; not installing .config in sources"
	fi
}

pkg_postinst() {
	einfo "${P} installation complete. Now in pkg_postinst()"
	elog ""
	elog "This software in preliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
