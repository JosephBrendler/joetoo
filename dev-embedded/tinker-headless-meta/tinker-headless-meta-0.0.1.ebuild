# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="Baseline packages for a headless server with gentoo on tinker s (32 bit)"
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
		>=sys-boot/tinker-boot-config-0.0.1
	)
	gpio ? (
		>=dev-libs/libgpiod-2.1
	)
	joetoo? (
		>=joetoo-base/joetoo-meta-0.2.0
		>=dev-util/joetoolkit-0.3.3
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
	elog "Installing (ins) into /etc/portage/"
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${PN}" "${PN}"
	elog "Installed (newins) package.use_${PN} as ${PN}"
	insinto "/etc/portage/package.unmask/"
	newins "${FILESDIR}/package.unmask_${PN}" "${PN}"
	elog "Installed (newins) package.unmask_${PN} as ${PN}"
	# for a joetoo installation, include vpn.start and vpn/service/temp monitoring tools
	if use joetoo ; then
		elog "USE joetoo selected; installing local.d and vpn/led/temp mon tools"
		# vpn.start tool for rc service "local"
		elog "Installing (ins) into /etc/local.d/"
		insinto "/etc/local.d/"
		# this is stable but /sys/class/gpio is to be deprecated, so LEDs wont work on pi5
		newins "${FILESDIR}/tinker_vpn.start.old" "tinker_vpn.start.old"
		elog "  Installed (newins) tinker_vpn.start.old"
		# 5 is better (still tuning)
		newins "${FILESDIR}/tinker_vpn.start" "tinker_vpn.start"
		elog "  Installed (newins) tinker_vpn.start"
		elog "Installing (exe) into /usr/local/sbin/"
		exeinto "/usr/local/sbin/"
		# pi5 periodic monitor/LED set tools for vpn/temp/svcs
		for x in $(find ${FILESDIR}/ -iname *watch*)
		do
			newexe "${x}" "$(basename $x)" ;
			elog "  Installed (newexe) $(basename $x)" ;
		done
		# check cpu temp and frequency (monitor with "watch tinker_mon")
		newexe "${FILESDIR}/tinker_mon" "tinker_mon"
		elog "  Installed (newexe) tinker_mon"
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
	elog "tinker-headless-meta installed"
	elog "Depends on joetoo-meta by default (see joetoo USE flag) "
	elog "Includes a local.d script for vpn & LEDs and vpn/svc/temp monitor tools"
	elog "VPN will need keys and local/remote.conf links"
	elog ""
	elog "version 0.0.1 first ebuild for tinker-headless-meta"
	elog ""
	elog "Thank you for using tinker-headless-meta"
}
