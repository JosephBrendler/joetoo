# Copyright 2025-2055 Joe Brendler
# Distributed under the terms of the GNU General Public License v3
# as configured, open a set of ssh sessions in terminal windows on virtual desktops

EAPI=8

DESCRIPTION="kernel build script, incl support for xen dom0 or domU, or several SBC systems"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

IUSE=""

RESTRICT="mirror"

#REQUIRED_USE=""

S="${WORKDIR}/${PN}"

RDEPEND="
	dev-util/script_header_joetoo
	app-admin/eselect
	x11-misc/xdotool
	x11-base/xorg-server
	x11-libs/libX11
"

BDEPEND="${RDEPEND}"

src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "A=${A}"
	einfo "T=${T}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"

	# install scripts (exclude similarly named .eselect .conf files)
	elog "Installing (exe) scripts into /usr/sbin/ ..."
	target="/usr/sbin/"
	exeinto "${target}"
	for x in $(find ${S}/ -maxdepth 1 -type f -executable -name 'xdotool_*_window*' -printf '%f\n' | grep -v '\.') ; do
		einfo "Installing (newexe) ${x} ..."
		newexe "${S}/${x}" "${x}"
	done
	elog "Installed scripts in ${target}"

	# install example config file
	einfo "Installing (ins) example configuration file"
	target="/etc/${PN}/"
	insinto "${target}"
	einfo "Installing (ins) ${PN}-template.conf ..."
	newins "${S}/${PN}.conf" "${PN}-template.conf"
	elog "installed (newins) ${PN}-template.conf in ${target}"

	# install eselect module
	target="/usr/share/eselect/modules/"
	einfo "Installing (ins) the ${PN}.conf eselect module into ${target} ..."
	insinto "${target}"
	z="${PN}.eselect"
	newins "${S}/${z}" "${z}"
	elog "Installed ${PN}.conf eselect module."

	# install the current build number reference file
	einfo "Generating and installing (echo) build number reference file into /etc/${PN}/ ..."
	insinto "/etc/${PN}/"
	echo "# DO NOT EDIT" > ${D}/etc/${PN}/BUILD
	echo "# This file will be sourced by the kernelupdate script to assign the current build number" >> ${D}/etc/${PN}/BUILD
	echo "BUILD=${PV}" >> ${D}/etc/${PN}/BUILD
	elog "Installed build number reference file in /etc/${PN}/"

	# install an exclusion from config_protect-tion for BUILD
	einfo "Installing (envd) exclusion from config_protect for build number reference file"
	newenvd "${S}/config_protect_mask" "99${PN}-BUILD"
	elog "Installed config_protect_mask 99${PN}-BUILD"
}

pkg_postinst() {
	elog "S=${S}"
	elog "D=${D}"
	elog "A=${A}"
	elog "T=${T}"
	elog "CATEGORY=${CATEGORY}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "ver 0.0.1 is the initial alpha draft"
	elog " 0.0.2 adds config_protect_mask for BUILD"
	elog ""
	elog "Don't forget to use the ${PN} eselect module to choose a baseline (or modified)"
	elog "configuration file in /etc/${PN}"
	elog ""
	elog "This software is still evolving.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
