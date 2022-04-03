# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Baseline packages for a headless server with gentoo-on-rpi-64bit"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+boot-fw +innercore +pigpio -pitop"
REQUIRED_USE="
	innercore"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0"

# to do: migrate required packages to joetoo so you don't need the genpi overlay
RDEPEND="
	${DEPEND}
	!dev-embedded/rpi3-64bit-meta
	!dev-embedded/rpi-64bit-meta
	boot-fw? (
		>=sys-boot/rpi3-64bit-firmware-1.20190819[pitop(-)?]
	)
	!boot-fw? (
		!sys-boot/rpi3-64bit-firmware
	)
	>=sys-firmware/brcm43430-firmware-20220402[43455-fix]
	>=net-wireless/rpi3-bluetooth-1.1-r7
	>=sys-apps/rpi3-init-scripts-1.1.5-r1
	>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
	>=sys-firmware/b43-firmware-5.100.138
	>=sys-firmware/bcm4340a1-firmware-1.1
	>=sys-firmware/bluez-firmware-1.2
	innercore? (
		>=joetoo-base/joetoo-meta-0.0.3c
		media-libs/raspberrypi-userland
		>=net-wireless/rpi3-wifi-regdom-1.1-r1
		>=sys-apps/rpi-i2c-1.0.0-r3
		>=sys-apps/rpi-onetime-startup-1.0-r4
		>=sys-apps/rpi-serial-1.0.0-r1
		>=sys-apps/rpi-spi-1.0.0-r2
		>=sys-apps/rpi-video-1.0.0-r1
		>=sys-apps/rng-tools-6.8
		>=sys-boot/rpi3-boot-config-1.0.9[pitop(-)?]
	)
	pigpio? (
		>=dev-libs/pigpio-71-r1
		>=sys-apps/rpi-gpio-1.0.1
	)
"

src_install() {
	# basic framework file to enable / disable USE flags for this package
	insinto "/etc/local.d/"
	newins "${FILESDIR}/raspi4_vpn.start" "raspi4_vpn.start"
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${PN}-2" "${PN}"
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
	elog "raspi64-headless-meta installed"
	elog "version 0.0.3a depends on joetoo-headless-mata"
	elog "and now drops lamp and nextcloud USE flags,"
	elog "and it adds local.d script for vpn & LEDs"
	elog "VPN will need keys and local/remote.conf links"
	elog ""
	elog "Thank you for using raspi64-headless-meta"
}
