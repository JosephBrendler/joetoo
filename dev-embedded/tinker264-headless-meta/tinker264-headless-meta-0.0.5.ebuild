# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="Baseline packages for a headless server with gentoo on tinker 2 s (64 bit)"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="-boot-fw +innercore +gpio +joetoo"
REQUIRED_USE="
	innercore"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

BDEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0"

# to do: version 0.0.4 starts migration of required packages to joetoo
#   so you won't need the genpi overlay
RDEPEND="
	${BDEPEND}
	>=sys-firmware/b43-firmware-5.100.138
	innercore? (
		>=sys-kernel/linux-firmware-20220310
		>=sys-apps/rng-tools-6.8
		>=sys-boot/tinker264-boot-config-0.0.1
	)
	gpio? (
		>=dev-libs/libgpiod-2.1
	)
	joetoo? (
		>=joetoo-base/joetoo-meta-0.2.0
		>=dev-embedded/sbc_status_leds-0.0.1
		>=dev-util/joetoolkit-0.3.3
	)
"

src_install() {
	elog "Installing (ins) into /etc/portage/"
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${PN}" "${PN}"
	elog "Installed (newins) package.use_${PN} as ${PN}"
	insinto "/etc/portage/package.unmask/"
	newins "${FILESDIR}/package.unmask_${PN}" "${PN}"
	elog "Installed (newins) package.unmask_${PN} as ${PN}"

	# for a joetoo installation, include vpn.start and vpn/service/temp monitoring tools
	if use joetoo ; then
		elog "USE joetoo selected; installing temp mon tools"
		# config_protect this and other files in /etc/local.d
		newenvd "${FILESDIR}/"config_protect 99${PN}
		elog "Installing (exe) into /usr/local/sbin/"
		exeinto "/usr/sbin/"
		# check cpu temp and frequency (monitor with "watch tinker264c_mon")
		newexe "${FILESDIR}/tinker264_mon" "tinker264_mon"
		elog "  Installed (newexe) tinker264_mon"
	else
		elog "USE joetoo NOT selected; NOT installing local.d and vpn/led/temp mon tools"
	fi
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	elog ""
	elog "tinker264-headless-meta installed"
	elog "Depends on joetoo-meta by default (see joetoo USE flag) "
	elog "Includes a local.d script for vpn & LEDs"
	elog "VPN will need keys and local/remote.conf links"
	elog ""
	elog "version 0.0.3 provides bug fixes, vpn tools and monitoring"
	elog ""
	elog "Thank you for using tinker264-headless-meta"
}
