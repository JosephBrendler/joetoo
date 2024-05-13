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
IUSE="-boot-fw +innercore -gpio +joetoo"
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
	)
	joetoo? (
		>=joetoo-base/joetoo-meta-0.2.0
	)
"
#		>=sys-boot/tinker264-boot-config-0.0.1
#	boot-fw? (
#		>=sys-boot/rock4c64-firmware-1.20230926
#	)
#	!boot-fw? (
#		!sys-boot/rock4c64-firmware
#	)
#	gpio? (
# not yet sure what to do here
#		>=dev-libs/pigpio-79
#	)
# ----[ from innercore ]-----
# boot-config may be moved to kernel package
# not yet sure what to do with the rest of these
#		>=sys-apps/rpi-gpio-1.0.1
#		>=sys-apps/rpi-i2c-1.0.1
#		>=sys-apps/rpi-spi-1.0.1
#		>=net-wireless/rpi3-wifi-regdom-1.1-r1
#		>=sys-apps/rpi-onetime-startup-1.0-r4
#		>=sys-apps/rpi-serial-1.0.0-r1
#		>=sys-apps/rpi-video-1.0.0-r1


src_install() {
	# basic framework file to enable / disable USE flags for this package
	insinto "/etc/local.d/"
	newins "${FILESDIR}/tinker264_vpn.start" "tinker264_vpn.start"
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${PN}" "${PN}"
	insinto "/etc/portage/package.unmask/"
	newins "${FILESDIR}/package.unmask_${PN}" "${PN}"
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
	elog "version 0.0.2 introduces nuoromis infrastructure related code"
	elog ""
	elog "Thank you for using tinker264-headless-meta"
}
