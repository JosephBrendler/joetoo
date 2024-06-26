# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# kernel builder program for embedded systems (tinkerboard s)

EAPI=8

DESCRIPTION="kernel build script, incl support for xen dom0 or domU, or several SBC systems"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~arm ~amd64 ~arm64"

IUSE="
	+dom0 domU
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b
	rk3288-tinker-s rk3399-tinker-2 rk3399-rock-4c-plus rk3588s-orangepi-5
"

BOARDLIST="
	dom0 domU
	bcm2708-rpi-b bcm2709-rpi-2-b bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b
	rk3288-tinker-s rk3399-tinker-2 rk3399-rock-4c-plus rk3588s-orangepi-5
"

# dom0 is default above, but "at least one of" the options
REQUIRED_USE="
	|| ( ${BOARDLIST} )
	"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND="
	>=sys-devel/crossdev-20230321
	>=dev-util/joetoolkit-0.1.5
	>=joetoo-base/joetoo-meta-0.0.4b
	>=app-admin/eselect-1.4.27-r1
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
	einfo "About to execute command newexe ${FILESDIR}/${PN} ${PN}"
	newexe "${FILESDIR}/${PN}" "${PN}";
	elog "Done installing script ${PN}"
	# install the README-instructions file for getting sources
	elog "Installing (ins) README-instructions and ebuild-template files into /etc/${PN}..."
	insinto "/etc/${PN}/"
	for z in $(find ${FILESDIR}/ -type f -iname 'README*' -or -iname 'template*'); do
		x=$(basename ${z}) ;
		einfo "About to execute command newins ${FILESDIR}/${x} ${x}..."
		newins "${FILESDIR}/${x}" "${x}" ;
		einfo "done inserting ${x}"
	done
	# install the raspi-sources-update-ebuild.sh
	elog "Installing (exe) raspi-sources update-ebuild.sh into /etc/${PN}"
	exeinto "/etc/${PN}"
	einfo "About to execute command newexe ${FILESDIR}/raspi-sources-update-ebuild.sh update-ebuild.sh"
	newexe "${FILESDIR}/raspi-sources-update-ebuild.sh" "update-ebuild.sh"
	elog "Done installing update-ebuild.sh script"

	# install config files only for those boards selected via use flags
	elog "Installing (ins) configuration files for selected boards into /etc/${PN}/..."
	insinto "/etc/${PN}/"
	for board in ${BOARDLIST}; do
		if use ${board}; then
			elog "USE flag \"${board}\" selected ..."
			for x in $(find ${FILESDIR}/${board}/ -maxdepth 1 -type f); do
				y=$(basename ${x}) ;
				z=$(echo ${y} | sed "s|${FILESDIR}/${board}/||") ;
				einfo "About to execute command newins ${x} ${z}" ;
				newins "${FILESDIR}/${board}/${y}" "${z}" ;
				einfo "done installing ${z}"
			done
			elog "done installing config files"
		else
			elog "USE flag \"${board}\" not selected; ${board} configs not installed"
		fi
	done
	# install the joetoo kernelupdate.conf eselect module
	elog "Installing (ins) the ${PN}.conf eselect module into /usr/share/eselect/modules/ ..."
	insinto "/usr/share/eselect/modules/"
	z="${PN}.eselect"
	einfo "About to execute command newins ${FILESDIR}/${z} ${z}"
	newins "${FILESDIR}/${z}" "${z}"
	elog "Done installing the kernelupdate.conf eselect module."

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
	elog "${PN} installed"
	elog ""
	elog "Version 0.3.0 is the preliminary release of refactored, consolidated ${PN} tool"
	elog "Version 0.3.1 renames rk3399-tinker-2 and adds supporting files for orangepi 5/5b"
	elog "Version 0.3.2-8 provide bugfixes (dom0/U)"
	elog "Version 0.4.0,1 fixes ebuild naming for domU kernel images"
	elog "Version 0.4.2 adds support for original raspberry pi model b (bcm2708-rpi-b)"
	elog "Version 0.4.3 adds support for github credentials, to automate publishing"
	elog "Version 0.4.4 amends handling of dtb_folder and adds overlay_folder"
	elog "Version 0.4.5-6 are more selective about contents of dtb_folder and overlay_folder"
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
