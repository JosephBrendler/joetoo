# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# kernel builder program for joetoo systems

EAPI=8

DESCRIPTION="kernel build script, incl support for xen dom0 or domU, or several SBC systems"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

IUSE="
	domU
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b
	bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2711-rpi-cm4-io bcm2712-rpi-5-b bcm2712-rpi-cm5-cm5io
	rk3288-tinker-s
	rk3399-tinker-2 rk3399-rock-4se rk3399-rock-pi-4c-plus
	rk3588-rock-5b rk3588-radxa-rock-5b+ rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	fsl-imx8mq-phanbell
	meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
"

BOARDLIST="
	domU
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b
	bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2711-rpi-cm4-io bcm2712-rpi-5-b bcm2712-rpi-cm5-cm5io
	rk3288-tinker-s
	rk3399-tinker-2 rk3399-rock-4se rk3399-rock-pi-4c-plus
	rk3588-rock-5b rk3588-radxa-rock-5b+ rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	fsl-imx8mq-phanbell
	meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
"

# "at least one of" the BOARDLIST options
REQUIRED_USE="
	|| ( ${BOARDLIST} )
	"

S="${WORKDIR}/${PN}"

RDEPEND="
	dev-util/script_header_joetoo[extended]
	>=sys-devel/crossdev-20230321
	>=dev-util/joetoolkit-0.1.5
	>=joetoo-base/joetoo-platform-meta-0.0.1
	>=joetoo-base/joetoo-common-meta-0.0.1
	>=app-admin/eselect-1.4.27-r1
	>=dev-util/pkgdev-0.2.11
"

DEPEND="${RDEPEND}"

# Install for selected board(s) from above different choices, like joetoo-platform-meta does via pkg_setup(),
# but note that where joetoo-platform-meta is "exactly-one-of" board, this is "at-least-one-of"...
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
	einfo "BOARDLIST: [ ${BOARDLIST} ]"

	# install the kernelupdate script
	elog "Installing (exe) script ${PN} into /usr/sbin/ ..."
	exeinto "/usr/sbin/"
	newexe "${S}/${PN}" "${PN}";
	elog "Installed script ${PN} in /usr/sbin/"

	# install the README-instructions file for getting sources
	einfo "Installing (ins) README-instructions and ebuild-template files into /etc/${PN}/ ..."
	insinto "/etc/${PN}/"
	for z in $(find ${S} -type f -iname 'README*' -or -iname 'template*'); do
		x=$(basename ${z}) ;
		einfo "Installing (newins) ${x}..."
		newins "${z}" "${x}" ;
		elog "Installed ${x} in /etc/${PN}/"
	done

# this raspi-sources-update-ebuild.sh is deprecated ... ignore it
	# install the raspi-sources-update-ebuild.sh
#	einfo "Installing (exe) raspi-sources update-ebuild.sh into /etc/${PN}"
#	exeinto "/etc/${PN}"
#	newexe "${S}/raspi-sources-update-ebuild.sh" "update-ebuild.sh"
#	elog "Installed update-ebuild.sh script in /etc/${PN}/"

	# install config files only for those boards selected via use flags
	einfo "Installing (ins) configuration files for selected boards into /etc/${PN}/..."
	insinto "/etc/${PN}/"
	for board in ${BOARDLIST}; do
		if use ${board}; then
			elog "USE flag \"${board}\" selected ..."
			for x in $(find ${S}/${board}/ -maxdepth 1 -type f); do
				y=$(basename ${x}) ;
				z=$(echo ${y} | sed "s|${S}/${board}/||") ;
				einfo "Installing (ins) ${z}" ;
				newins "${S}/${board}/${y}" "${z}" ;
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
	newins "${S}/${z}" "${z}"
	elog "Installed ${PN}.conf eselect module."

	# install the current build number reference file
	einfo "Generating and installing (echo) build number reference file into /etc/${PN}/ ..."
	insinto "/etc/${PN}/"
	echo "# DO NOT EDIT" > ${D}/etc/${PN}/BUILD
	echo "# This file will be sourced by the kernelupdate script to assign the current build number" >> ${D}/etc/${PN}/BUILD
	echo "BUILD=${PV}" >> ${D}/etc/${PN}/BUILD
	elog "Installed build number reference file in /etc/${PN}/"

	# install the BPN reference file to support future local command line opts and usage
	einfo "Generating and installing (echo) BPN reference file into /etc/${PN}/ ..."
	insinto "/etc/${PN}/"
	echo "# DO NOT EDIT" > ${D}/etc/${PN}/BPN
	echo "# This file will be sourced by the kernelupdate script to support future local cmdline opts and usage" >> ${D}/etc/${PN}/BUILD
	echo "BPN=${PN}" >> ${D}/etc/${PN}/BPN
	elog "Installed BPN reference file in /etc/${PN}/"

# I don't have any local./local.cmdline_arguments and local.cmdline_compound_arguments
# for kernelupdate (yet) -- it just uses the basic cli opts -i,n,r,s,v,q
# put this here to activate when needed
	# also install local.cmdline_arguments, local.cmdline_compound_arguments, local.usage
#	newins "${S}/local.cmdline_arguments" "local.cmdline_arguments"  || die "Install failed!"
#	elog "Done installing local.cmdline_arguments"
#	newins "${S}/local.cmdline_compound_arguments" "local.cmdline_compound_arguments"  || die "Install faile>
#	elog "Done installing local.cmdline_compound_arguments"
# an empty local.usage exists for now (should have no effect), so install it
	newins "${S}/local.usage" "local.usage"  || die "Install failed!"
	elog "Done installing local.usage"

	# install an exclusion from config_protect-tion for BUILD
	einfo "Installing (envd) exclusion from config_protect for build number reference file"
	newenvd "${S}/config_protect_mask" "99${PN}-BUILD"
	elog "Installed config_protect_mask 99${PN}-BUILD"

	# install a template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild file
	einfo "Installing (ins) template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild ..."
	insinto "/etc/${PN}/"
	newins "${S}/template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild" "template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild"
	elog "Installed template_linux-MODEL_joetoo_kernelimage-0.0.0.ebuild"

	# install a template metadata.xml file
	einfo "Installing (ins) template template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml ..."
	insinto "/etc/${PN}/"
	newins "${S}/template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml" "template_linux-MODEL_joetoo_kernelimage-0.0.0.metadata.xml"
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
	elog "BOARDLIST=${BOARDLIST}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "This ebuild's version_history is located at its FILESDIR"
	elog "Ver 0.10.0 uses script_header_joetoo_extended cli opts and run_sequence, adds rock5b+"
	elog " 0.10.1 adds commit-signing key cache step and updates README instructions"
	elog " 0.10.2 adds rk3399-rock-4se and updates config files"
	elog " 0.10.3-4 begin migration of kernel tarballs from github to raspi56403"
	elog " 0.10.5-6 add safeguards on rm and chown commands in the script"
	elog " 0.10.7-9 provides refinements and bugfixes"
	elog ""
	elog "Don't forget to use the ${PN} eselect module to choose a baseline (or modified)"
	elog "configuration file in /etc/${PN}"
	elog ""
	elog "This software is still evolving.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
