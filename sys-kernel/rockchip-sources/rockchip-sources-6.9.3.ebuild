# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# joe brendler  29 January 2024
#
# Note: this is not like raspi-sources (which is git)
# to examine before building an ebuild, and to get sources for the kernelupdate script --
# cd /home/joe/rockchip-sources
# rm -rf linux
# browse https://cdn.kernel.org/ and pick a version
# wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${PN}.tar.xz
# tar xvpf linux-${PN}.tar.xz
# cd linux
# make kernelversion  ## verify it matches, and now use as ${PN} for new ebuild
# (copy latest ebuild to a new filename with this new version as ${PN})
#

EAPI=8
MyV=$(ver_cut 1)
DESCRIPTION="kernel sources for rockchip SOC based single board computers (SBCs)"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://cdn.kernel.org/pub/linux/kernel/v${MyV}.x/linux-${PV}.tar.xz"

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
	ewarn "${PN} installs raw kernel sources directly from cdn.kernel.org"
	ewarn "If you need support, please contact upstream kernel developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""

	einfo "S=${S}"
	My_P="linux-${PV}"
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
