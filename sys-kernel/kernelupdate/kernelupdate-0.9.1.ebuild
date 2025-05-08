# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# kernel builder program for joetoo systems

EAPI=8

DESCRIPTION="kernel build script, incl support for xen dom0 or domU, or several SBC systems"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${P}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

IUSE="
	domU
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b
	bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b
	rk3288-tinker-s
	rk3399-tinker-2 rk3399-rock-pi-4c-plus rk3588s-orangepi-5 rk3588s-rock-5c
"

BOARDLIST="
	domU
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b
	bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b
	rk3288-tinker-s
	rk3399-tinker-2 rk3399-rock-pi-4c-plus rk3588s-orangepi-5 rk3588s-rock-5c
"

# "at least one of" the BOARDLIST options
REQUIRED_USE="
	|| ( ${BOARDLIST} )
	"

S="${WORKDIR}"

RDEPEND="
	>=dev-util/script_header_brendlefly-0.4.5
	>=sys-devel/crossdev-20230321
	>=dev-util/joetoolkit-0.1.5
	>=joetoo-base/joetoo-meta-0.0.4b
	>=app-admin/eselect-1.4.27-r1
	>=dev-util/pkgdev-0.2.11
"

DEPEND="${RDEPEND}"

# Install for selected board(s) from above different choices, like joetoo-meta does via pkg_setup(),
# but note that where joetoo-meta is "exactly-one-of" board, this is "at-least-one-of"...
# Therefor, need to do in src_install and use for loop to install selected boards
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
	einfo "FILESDIR=${FILESDIR}"
	einfo "BOARDLIST: [ ${BOARDLIST} ]"

	# install the kernelupdate script
	elog "Installing (exe) script ${PN} into /usr/sbin/ ..."
	exeinto "/usr/sbin/"
	newexe "${S}/${PN}/${PN}" "${PN}";
	elog "Installed script ${PN} in /usr/sbin/"
	# install the README-instructions file for getting sources
	einfo "Installing (ins) README-instructions and ebuild-template files into /etc/${PN}/ ..."
	insinto "/etc/${PN}/"
	for z in $(find ${S}/${PN} -type f -iname 'README*' -or -iname 'template*'); do
		x=$(basename ${z}) ;
		einfo "Installing (newins) ${x}..."
		newins "${z}" "${x}" ;
		elog "Installed ${x} in /etc/${PN}/"
	done
	# install the raspi-sources-update-ebuild.sh
	einfo "Installing (exe) raspi-sources update-ebuild.sh into /etc/${PN}"
	exeinto "/etc/${PN}"
	newexe "${S}/${PN}/raspi-sources-update-ebuild.sh" "update-ebuild.sh"
	elog "Installed update-ebuild.sh script in /etc/${PN}/"

	# install config files only for those boards selected via use flags
	einfo "Installing (ins) configuration files for selected boards into /etc/${PN}/..."
	insinto "/etc/${PN}/"
	for board in ${BOARDLIST}; do
		if use ${board}; then
			elog "USE flag \"${board}\" selected ..."
			for x in $(find ${S}/${PN}/${board}/ -maxdepth 1 -type f); do
				y=$(basename ${x}) ;
				z=$(echo ${y} | sed "s|${S}/${PN}/${board}/||") ;
				einfo "Installing (ins) ${z}" ;
				newins "${S}/${PN}/${board}/${y}" "${z}" ;
				elog "Installed ${z} in /etc/${PN}/"
			done
			elog "Done installing config files"
		else
			elog "USE flag \"${board}\" not selected; ${board} configs not installed"
		fi
	done
	# install the joetoo kernelupdate.conf eselect module
	einfo "Installing (ins) the ${PN}.conf eselect module into /usr/share/eselect/modules/ ..."
	insinto "/usr/share/eselect/modules/"
	z="${PN}.eselect"
	newins "${S}/${PN}/${z}" "${z}"
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
	newenvd "${S}/${PN}/config_protect_mask" "99${PN}-BUILD"
	elog "Installed config_protect_mask 99${PN}-BUILD"
	# install a template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild file
	einfo "Installing (ins) template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild ..."
	insinto "/etc/${PN}/"
	newins "${S}/${PN}/template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild" "template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild"
	elog "Installed template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild"
	# install a template metadata.xml file
	einfo "Installing (ins) template template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml ..."
	insinto "/etc/${PN}/"
	newins "${S}/${PN}/template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml" "template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml"
	elog "Installed template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml"
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
	elog "FILESDIR=${FILESDIR}"
	elog "BOARDLIST=${BOARDLIST}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "Version 0.8.0 reintroduces publish_ebuild for all models except dom0"
	elog " 0.8.1 fixes bugs in publish_tarball, _ebuild to fix initial templates 0.0.0"
	elog " 0.8.2 incorporates display_vars() from script_header in display_config()"
	elog " 0.8.3 reformats make_me and provides easier cut/paste line for manual build"
	elog " 0.9.0 sources from myUtilities, drops dom0, adds KERNEL_DIR, KBUILD_OUTPUT"
	elog " 0.9.1 fixes bug in git cmd sequence, to add new template's hash file"
	elog ""
	elog "Don't forget to use the ${PN} eselect module to choose a baseline (or modified)"
	elog "configuration file in /etc/${PN}"
	elog ""
	elog "This software is still evolving.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
