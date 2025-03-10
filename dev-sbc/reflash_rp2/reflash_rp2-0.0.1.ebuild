# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=8

inherit linux-info

DESCRIPTION="joetoo program to flash a program to the RP2040 microcontroller on a Radxa X4 SBC"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${P}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~amd64"
IUSE="+serial +stress"

RESTRICT="mirror"

REQUIRED_USE=""

S="${WORKDIR}"

BDEPEND="
	>=sys-devel/crossdev-20241215
"

# libgpiod is used to toggle the X4's internal gpio pins, putting the RP2040 in usb-storage mode
# (not to be confused with using the RP2040 to controlling external gpio pins on the SBC)
RDEPEND="
	${BDEPEND}
	>=dev-libs/libgpiod-1.6.4
	>=app-admin/eselect-1.4.27-r1
	serial? (
		>=dev-python/pyserial-3.5-r2
		>=dev-python/pip-25.0.1-r1
		>=net-dialup/minicom-2.9
	)
	>=app-benchmarks/stress-1.0.7
"

src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "A=${A}"
	einfo "T=${T}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"

	# Install config files and README
	elog "Installing (ins) into /etc/${PN}/"
	# install the .conf files for each USE'd board in ${boards}
	insinto "/etc/${PN}/"
	for x in ${S}/${PN}/configs/${PN}_*.conf ; do
		y=$(basename ${x})
		newins "${x}" "${y}"
		elog "  Installed (newins) ${y})"
	done
	# install README and BUILD files in /etc/${PN}
	newins "${FILESDIR}/README" "README"
	elog "  Installed (newins) README"
	echo "BUILD=${PVR}" > ${T}/BUILD
	newins "${T}/BUILD" "BUILD"
	elog "  Installed (newins) BUILD"

	# Install executables (but not scripts in sub-directories)
	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	for x in $(find ${S}/${PN}/ -maxdepth 1 -type f -executable); do
		y=$(basename $x)
		newexe "${x}" "${y}"
		elog "Installed (newexe) ${y}"
	done

	# Install eselect module
	elog "Installing the joetoo ${PN}.conf eselect module..."
	insinto "/usr/share/eselect/modules/"
	newins "${S}/${PN}/${PN}.eselect" "${PN}.eselect"
	elog "Done installing the joetoo ${PN}.conf eselect module."

}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "You can create additional configurations in /etc/${PN}"
	elog "Use eselect ${PN} to pick one of them"
	elog ""
        elog "See documentation at:"
        elog " https://wiki.gentoo.org/wiki/User:Brendlefly62/Radxa_x4_N100_sbc_with_RP2040/Use_the_RP2040_Microcontroller"
        elog "Which also references:"
        elog " https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf"
        elog " https://datasheets.raspberrypi.org/pico/getting-started-with-pico.pdf"
        elog " https://www.youtube.com/watch?v=rUkpIG_3D9k"
        elog " https://github.com/raspberrypi/pico-sdk#quick-start-your-own-project"
        elog " https://forums.gentoo.org/viewtopic-t-1134474-start-0.html"
        elog " https://forums.gentoo.org/viewtopic-p-8734951.html?sid=e340ef1c346252d518007863854b9ba6"
        elog " https://github.com/raspberrypi/pico-examples"
        elog " https://docs.radxa.com/en/x/x4/software/c_sdk_examples"
        elog " https://docs.radxa.com/en/x/x4/software/flash?flash_way=Software"
        elog " https://wiki.gentoo.org/wiki/Pip"
        elog " https://wiki.gentoo.org/wiki/ARM"
	elog ""
	elog "ver 0.0.1 is the initial build"
	elog ""
	elog "Thank you for using ${PN}"
}
