# Copyright (c) brendlefly joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Baseline packages for a headless server with gentoo-on-rpi-64bit"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="innercore +boot-fw +lamp +nextcloud"
REQUIRED_USE="
	innercore
	nextcloud? ( lamp )"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=sys-apps/openrc-0.42.1-r2[swclock-fix(-)]
	>=app-shells/bash-5.0"

# assumes you have the genpi overlay as well as joetoo
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
	>=net-wireless/rpi3-bluetooth-1.1-r7
	>=sys-apps/rpi3-init-scripts-1.1.5-r1
	>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
	>=sys-firmware/b43-firmware-5.100.138
	>=sys-firmware/bcm4340a1-firmware-1.1
	>=sys-firmware/bluez-firmware-1.2
	>=sys-firmware/brcm43430-firmware-20190812-r1[43455-fix]
	innercore? (
		>=app-admin/logrotate-3.15.1
		>=app-admin/sudo-1.8.29-r2
		>=app-admin/syslog-ng-3.24.1
		>=app-crypt/gnupg-2.2.19
		>=app-editors/nano-4.6
		>=app-portage/eix-0.33.9
		>=app-portage/gentoolkit-0.4.6
		>=app-text/tree-1.8.0
		>=dev-libs/elfutils-0.178
		>=dev-vcs/git-2.24.1
		>=media-libs/raspberrypi-userland-1.20191214
		>=net-misc/chrony-3.5-r2
		>=net-misc/dhcpcd-8.1.2
		>=net-misc/networkmanager-1.18.4-r1
		>=sys-apps/util-linux-2.34-r3
		>=net-wireless/rfkill-0.5-r1
		>=net-wireless/rpi3-wifi-regdom-1.1-r1
		>=net-wireless/wireless-tools-30_pre9
		>=net-wireless/wpa_supplicant-2.9-r1
		>=sys-apps/file-5.37-r1
		>=sys-apps/mlocate-0.26-r2
		>=sys-apps/rpi-gpio-1.0.0-r1
		>=sys-apps/rpi-i2c-1.0.0-r3
		>=sys-apps/rpi-onetime-startup-1.0-r4
		>=sys-apps/rpi-serial-1.0.0-r1
		>=sys-apps/rpi-spi-1.0.0-r2
		>=sys-apps/rpi-video-1.0.0-r1
		>=sys-apps/rng-tools-6.8
		>=sys-apps/usbutils-012
		>=sys-boot/rpi3-boot-config-1.0.9[pitop(-)?]
		>=sys-devel/distcc-3.3.3
		>=sys-fs/dosfstools-4.1
		>=sys-fs/eudev-3.2.9
		>=sys-process/cronie-1.5.5
		dev-lang/python:3.7[pgo(-)]
		>=app-misc/screen-4.7.0
		>=dev-libs/pigpio-71-r1
		>=net-analyzer/nmap-7.80
		>=net-analyzer/tcpdump-4.9.3
		>=net-vpn/networkmanager-openvpn-1.8.10
		>=net-vpn/openvpn-2.4.7-r1
		>=sys-apps/smartmontools-7.0-r1
		>=sys-fs/ncdu-1.14.1
		>=sys-fs/zerofree-1.0.4
		>=sys-power/powertop-2.10
		>=sys-process/htop-2.2.0
		>=sys-process/iotop-0.6
	)
"

src_install() {
	# basic framework file to enable / disable USE flags for this package
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
	elog "version 0.0.1 is preliminary. please report bugs to the maintainer."
	elog ""
	elog "Thank you for using raspi64-headless-meta"
}
