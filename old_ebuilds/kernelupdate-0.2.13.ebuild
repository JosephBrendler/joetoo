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

IUSE="+dom0 domU rk3288-tinker-s rk3399-tinker2-s rk3399-rock-4c-plus bcm2709-rpi-2-b bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b"
BOARDLIST="dom0 domU rk3288-tinker-s rk3399-tinker2-s rk3399-rock-4c-plus bcm2709-rpi-2-b bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b"

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
	elog "Installing (ins) README-instructions files into /etc/${PN}..."
	insinto "/etc/${PN}/"
	for z in $(find ${FILESDIR}/ -iname README* -type f); do
		x=$(basename ${z}) ;
		einfo "About to execute command newins ${FILESDIR}/${x} ${x}..."
		newins "${FILESDIR}/${x}" "${x}" ;
		einfo "done inserting ${x}"
	done

	# install config files only for those boards selected via use flags
	elog "Installing (ins) configuration files for selected boards into /etc/${PN}/..."
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
	elog "Version 0.0.5 incorporated ${PN}.conf file(s) and generalized for multiple models"
	elog "Version 0.0.6 enabled use of multiple .conf files and provided examples for models"
	elog "Version 0.1.0 added Rock4cplus, Pi 3b+, Pi 5b, and consolidated src_install() "
	elog "Version 0.1.1-4 provided bugfixes"
	elog "Version 0.1.5 installed README-instructions in /etc/${PN}/ vs /usr/sbin/"
	elog "Version 0.2.0 split publish tarball and ebuild functions, either being skipable"
	elog "  also made makeopts and features .conf variables and command sequence resumable"
	elog "Version 0.2.1 added support for bcm2709-rpi-2-b (Raspberry Pi 2 B)"
	elog "Version 0.2.2 provided bugfixes"
	elog "Version 0.2.3 added a .conf eselect module"
	elog "Version 0.2.4 removed pre-pub steps (skip publish_tarball if user uploads w git-desktop)"
	elog "Version 0.2.5 added support for rk3399-tinker-2-s and tuned up dtb/overlay installation"
	elog "Version 0.2.6 generalized to support dom0/U and renamed from kernelupdate-embedded"
	elog "Version 0.2.7-9 provided bugfixes for dom0/U and dropped the term embedded"
	elog "Version 0.2.10 refactors for newexe and newins ebuild commands"
	elog ""
	elog "This software is still preliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
