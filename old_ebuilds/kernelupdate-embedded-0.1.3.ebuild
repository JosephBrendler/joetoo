# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# kernel builder program for embedded systems (tinkerboard s)

EAPI=8

DESCRIPTION="kernel builder program for embedded systems (tinkerboard s)"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~arm ~amd64 ~arm64"

IUSE="+rk3288-tinker-s rk3288-tinker bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b rk3399-rock-pi-4c-plus"
BOARDLIST="rk3288-tinker-s rk3288-tinker bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b rk3399-rock-pi-4c-plus"

# tinker-s is default above, but "at least one of" the options
REQUIRED_USE="
	|| ( ${BOARDLIST=} )
	"
#	|| ( rk3288-tinker-s rk3288-tinker bcm2710-rpi-3-b-plus bcm2711-rpi-4-b bcm2712-rpi-5-b rk3399-rock-pi-4c-plus )
#	"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND="
	>=sys-devel/crossdev-20230321
	>=dev-util/joetoolkit-0.1.5
	>=joetoo-base/joetoo-meta-0.0.4b
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

	# basic set of utilities for joetoo
	elog "Installing script ${PN} and README file..."
	dodir "/usr/sbin/"
	for x in $(find ${FILESDIR}/ -maxdepth 1 -type f);
	do
		z=$(echo ${x} | sed "s|${FILESDIR}/||");
		einfo "About to execute command cp -v "${x}" "${D}"/usr/sbin/"${z}";"
		cp -v "${x}" "${D}/usr/sbin/${z}";
	done
	elog "done installing script and README"

	elog "Installing configuration files for selected boards..."
	dodir "/etc/${PN}/"
	for board in ${BOARDLIST};
	do
		if use ${board}; then
			elog "USE flag \"${board}\" selected ..."
			dodir "/etc/${PN}/${board}/"
			for x in $(find ${FILESDIR}/${board}/ -maxdepth 1 -type f);
			do
				z=$(echo ${x} | sed "s|${FILESDIR}/${board}/||");
				einfo "About to execute command cp -v "${x}" "${D}"/etc/${PN}/"${z}";"
				cp -v "${x}" "${D}/etc/${PN}/${z}";
			done
			elog "done"
		else
			elog "USE flag \"${board}\" not selected; ${board} configs not copied"
		fi
	done
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
	elog ""
	elog "${PN} installed"
	elog ""
	elog "Version 0.0.5 incorporates ${PN}.conf file(s) and generalizes for multiple models"
	elog "Version 0.0.6 enables use of multiple .conf files and provides examples for models"
	elog "  tinkerboard-s and Pi4b.  You can use/modify, and symlink the one you want"
	elog "  to ${PN}.conf in /etc/${PN}/"
	elog ""
	elog "Version 0.1.0 adds Rock4cplus, Pi 3b+, Pi 5b, and consolidates src_install() "
	elog "Versions 0.1.1-3 provide bugfixes"
	elog ""
	elog "This software is still prliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
