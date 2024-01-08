# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="tinkerboard s boot files"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="
	${DEPEND}"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

pkg_preinst() {
	if ! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1; then
		ewarn "${ROOT%/}/boot is not mounted, the files might not be installed at the right place"
	fi
}

src_install() {
        # 'starter' versions of these files, will be CONFIG_PROTECTed
	dodir /boot
		for x in $( find ${FILESDIR}/ -maxdepth 1 | grep -v config_protect );
                do
			cp -av "${x}" "${D}/boot/"
		done
	newenvd "${FILESDIR}"/config_protect_boot 99${PN}_boot
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Installed boot files in /boot/ --"
		elog "Note:  config_protect_boot will protect u-boot files, but joetoo"
		elog "does not yet have u-boot development implemented for this board."
		elog ""
		elog "Thus, this ebuild does not yet deliver boot.cmd, boot.scr, nor the"
		elog "u-boot_reflash files needed for this board -- if needed, they can"
		elog "be retrieved from armbian/build output .deb files"
		elog ""
		elog "Thanks for using tinker-boot-config"
	fi
}
