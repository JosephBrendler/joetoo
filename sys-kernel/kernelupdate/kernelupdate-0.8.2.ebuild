# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# kernel builder program for joetoo systems

EAPI=8

DESCRIPTION="kernel build script, incl support for xen dom0 or domU, or several SBC systems"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

IUSE="
	+dom0 domU
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b
	bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b
	rk3288-tinker-s
	rk3399-tinker-2 rk3399-rock-pi-4c-plus rk3588s-orangepi-5 rk3588s-rock-5c
"

BOARDLIST="
	dom0 domU
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b
	bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b
	rk3288-tinker-s
	rk3399-tinker-2 rk3399-rock-pi-4c-plus rk3588s-orangepi-5 rk3588s-rock-5c
"

# dom0 is default above, but "at least one of" the options
REQUIRED_USE="
	|| ( ${BOARDLIST} )
	"

# required by Portage, as we have no SRC_URI...
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
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	einfo "BOARDLIST: [ ${BOARDLIST} ]"

	# install the kernelupdate script
	elog "Installing (exe) script ${PN} into /usr/sbin/ ..."
	exeinto "/usr/sbin/"
	newexe "${FILESDIR}/${PN}" "${PN}";
	elog "Installed script ${PN} in /usr/sbin/"
	# install the README-instructions file for getting sources
	einfo "Installing (ins) README-instructions and ebuild-template files into /etc/${PN}/ ..."
	insinto "/etc/${PN}/"
	for z in $(find ${FILESDIR}/ -type f -iname 'README*' -or -iname 'template*'); do
		x=$(basename ${z}) ;
		einfo "Installing (newins) ${x}..."
		newins "${FILESDIR}/${x}" "${x}" ;
		elog "Installed ${x} in /etc/${PN}/"
	done
	# install the raspi-sources-update-ebuild.sh
	einfo "Installing (exe) raspi-sources update-ebuild.sh into /etc/${PN}"
	exeinto "/etc/${PN}"
	newexe "${FILESDIR}/raspi-sources-update-ebuild.sh" "update-ebuild.sh"
	elog "Installed update-ebuild.sh script in /etc/${PN}/"

	# install config files only for those boards selected via use flags
	einfo "Installing (ins) configuration files for selected boards into /etc/${PN}/..."
	insinto "/etc/${PN}/"
	for board in ${BOARDLIST}; do
		if use ${board}; then
			elog "USE flag \"${board}\" selected ..."
			for x in $(find ${FILESDIR}/${board}/ -maxdepth 1 -type f); do
				y=$(basename ${x}) ;
				z=$(echo ${y} | sed "s|${FILESDIR}/${board}/||") ;
				einfo "Installing (ins) ${z}" ;
				newins "${FILESDIR}/${board}/${y}" "${z}" ;
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
	newins "${FILESDIR}/${z}" "${z}"
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
	newenvd "${FILESDIR}/config_protect_mask" "99${PN}-BUILD"
	elog "Installed config_protect_mask 99${PN}-BUILD"
	# install a template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild file
	einfo "Installing (ins) template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild ..."
	insinto "/etc/${PN}/"
	newins "${FILESDIR}/template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild" "template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild"
	elog "Installed template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild"
	# install a template metadata.xml file
	einfo "Installing (ins) template template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml ..."
	insinto "/etc/${PN}/"
	newins "${FILESDIR}/template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml" "template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml"
	elog "Installed template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml"
}

pkg_postinst() {
	elog "S=${S}"
	elog "D=${D}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog "FILESDIR=${FILESDIR}"
	elog "RDEPEND=${RDEPEND}"
	elog "DEPEND=${DEPEND}"
	elog "BOARDLIST=${BOARDLIST}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "Version 0.3.0 is the preliminary release of refactored, consolidated ${PN} tool"
	elog " 0.3.1 renames rk3399-tinker-2 and adds supporting files for orangepi 5/5b"
	elog " 0.3.2-8 provide bugfixes (dom0/U)"
	elog " 0.4.0,1 fixes ebuild naming for domU kernel images"
	elog " 0.4.2 adds support for original raspberry pi model b (bcm2708-rpi-b)"
	elog " 0.4.3 adds support for github credentials, to automate publishing"
	elog " 0.4.4 amends handling of dtb_folder and adds overlay_folder"
	elog " 0.4.5-6 are more selective about contents of dtb_folder and overlay_folder"
	elog " 0.4.7 amends kernel image deployment and generates BUILD number"
	elog " 0.4.8/9 refine overlay file selection and adds rpi kernel build reference info"
	elog " 0.4.10 adds boot-mount verification for dom0 kernel installation"
	elog " 0.4.11 amends kernel_image version number/name for domU"
	elog " 0.4.12 adds support for rpi 3 model b v1.2 32bit (bcm2710-rpi-3-b)"
	elog " 0.5.0 fixes a typo and changes to ssh authentication for github repos"
	elog " 0.5.1 adopts rk3399-rock-pi-4c-plus vice rk3399-rock-4c-plus"
	elog " 0.5.2 uses just one make for all targets, vice three (image, modules, dtbs)"
	elog " 0.6.0 is rewritten in vscode, to allow non-interactive option, etc."
	elog " 0.6.1 adds a method to obtain ssh key needed for git push"
	elog " 0.6.2 adds support for Rock 5c 64 bit (rk3588s-rock-5c)"
	elog " 0.6.3 moves ssh key load to publish function (did not work)"
	elog " 0.6.4 adds reusable ssh authentication socket to hold loaded ssh key(s)"
	elog " 0.7.0 reintroduces publish_ebuild (only for domU)"
	elog " 0.7.1 fixes a bug in display_config() [0.8 adopted script_header display_vars]"
	elog " 0.8.0 reintroduces publish_ebuild for all models except dom0"
	elog " 0.8.1 fixes bugs in publish_tarball, _ebuild to fix initial templates 0.0.0"
	elog ""
	elog "Don't forget to use the ${PN} eselect module to choose a baseline (or modified)"
	elog "configuration file in /etc/${PN}"
	elog ""
	elog "    *** Note: to have a build-host build a kernel for itself, use model=dom0 ***"
	elog "    *** (i.e. dom0 output is NOT cross-compiled and is installed at default  ***"
	elog "    ***  locations: /boot for kernel; /lib/modules/<version> for modules,    ***"
	elog "    ***  no device tree blobs (.dtb/.dtbo) are built for dom0 *(or domU),    ***"
	elog "    ***  and no ebuild is created for a dom0 product (unlike other models)   ***"
	elog ""
	elog "This software is still preliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
