# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Raspberry Pi {config,cmdline}.txt, for 32-bit mode"
HOMEPAGE="https://github.com/joetoo"
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
	insinto /boot
	# 'starter' versions of these files, will be CONFIG_PROTECTed
	newins "${FILESDIR}/config.txt" config.txt
	newins "${FILESDIR}/cmdline.txt" cmdline.txt
	newenvd "${FILESDIR}"/config_protect 99${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Starter versions of /boot/config.txt and /boot/cmdline.txt"
		elog "have been installed. Modify them as required."
		elog "See e.g.:"
		elog "  https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md"
		elog "  https://www.raspberrypi.org/documentation/configuration/config-txt/README.md"
	fi
}
