# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# (baseline support for a headless server [sakaki's X, networkmanager no longer default
#  and systemd USE removed; sakaki didn't support it anyway])
# License: GPL v3+
# NO WARRANTY

EAPI=8

KEYWORDS="~arm64"

DESCRIPTION="Misc init scripts for the gentoo-on-rpi3-64bit image"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RESTRICT="mirror"
AR_SVCNAME="autoexpand-root"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-apps/openrc-0.41
	>=app-shells/bash-4.0"

src_install() {
	newinitd "${FILESDIR}/init.d_autoexpand_root-4" "${AR_SVCNAME}"
	newins "${FILESDIR}/50-hostname-mode-none.conf-1" "50-hostname-mode-none.conf"
	insinto "/etc/sysctl.d"
	newins "${FILESDIR}/35-low-memory-cache-settings.conf-1" "35-low-memory-cache-settings.conf"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${AR_SVCNAME}" boot
		elog "The first-boot root partition resizing service has been activated."
		elog "To have it run (which also force-sets the root and demouser"
		elog "passwords, create (touch) the sentinel file /boot/autoexpand_root_partition."
		elog "To do the same (but skipping the autoexpand step) create"
		elog "(touch) the file /boot/autoexpand_root_none instead."
		elog "To disable entirely, run:"
		elog "  rc-update del ${AR_SVCNAME} boot"
	fi
}

