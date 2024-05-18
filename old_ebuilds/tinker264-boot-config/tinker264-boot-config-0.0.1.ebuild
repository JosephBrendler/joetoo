# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Tinkerboard 2 S u-boot files for 64-bit mode"
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
	dodir /boot
		for x in $(find ${FILESDIR}/ -maxdepth 1 -type f | grep -v config_protect);
                do
			z=$(echo $(basename ${x}) | sed "s|rk3399-tinker-2-s_||");
			cp -v "${x}" "${D}/boot/${z}"
		done
	dodir /boot/u-boot_reflash
		for x in $(find ${FILESDIR}/rk3399-tinker-2-s_u-boot_reflash/ -maxdepth 1 -type f);
		do
			cp -v "${x}" "${D}/boot/u-boot_reflash/$(basename ${x})"
		done
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
