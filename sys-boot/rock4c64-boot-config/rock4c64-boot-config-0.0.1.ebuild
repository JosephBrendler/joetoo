# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Rock 4c Plus u-boot files for 64-bit mode"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"
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
	insinto /boot
		newins "${FILESDIR}/rk3399-rock-pi-4c-plus_boot.scr" boot.scr
		newins "${FILESDIR}/rk3399-rock-pi-4c-plus_boot.cmd" boot.cmd
		newins "${FILESDIR}/rk3399-rock-pi-4c-plus_joetooEnv.txt" joetooEnv.txt
		newins "${FILESDIR}/rk3399-rock-pi-4c-plus_u-boot_reflash" u-boot_reflash
	newenvd "${FILESDIR}"/config_protect_boot 99${PN}_boot
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Installed initial u-boot files in /boot/ --"
		elog "  boot.scr -- compiled u-boot script (do not modify)."
		elog "  boot.cmd -- code from which boot.scr is compiled (do not modify)"
		elog "  joetooEnv.txt -- user-configurable u-boot environment variables"
		elog "  u-boot_reflash/ -- instructions and files needed to reflash u-boot"
		elog ""
		elog "Thanks for using rock4c64-boot-config"
	fi
}
