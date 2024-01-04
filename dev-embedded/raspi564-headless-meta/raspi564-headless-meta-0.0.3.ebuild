# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Baseline packages for a headless Pi 5 server with gentoo-on-rpi-64bit"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+boot-fw +innercore +gpio +joetoo"
REQUIRED_USE="
	innercore"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0"

# to do: version 0.0.4 starts migration of required packages to joetoo
#   so you won't need the genpi overlay
RDEPEND="
	${DEPEND}
	!dev-embedded/rpi3-64bit-meta
	!dev-embedded/rpi-64bit-meta
	boot-fw? (
		>=sys-boot/rpi5-64bit-firmware-1.20190819
	)
	!boot-fw? (
		!sys-boot/rpi5-64bit-firmware
	)
	>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
	>=sys-firmware/b43-firmware-5.100.138
	innercore? (
		media-libs/raspberrypi-userland
		>=sys-kernel/linux-firmware-20220310
		>=sys-apps/rpi-gpio-1.0.1
		>=sys-apps/rpi-i2c-1.0.1
		>=sys-apps/rpi-spi-1.0.1
		>=net-wireless/rpi3-wifi-regdom-1.1-r1
		>=sys-apps/rpi-serial-1.0.0-r1
		>=sys-apps/rpi-video-1.0.0-r1
		>=sys-apps/rng-tools-6.8
		>=sys-boot/rpi5-boot-config-1.0.0
	)
	gpio? (
		>=dev-libs/libgpiod-2.1
	)
	joetoo? (
		>=joetoo-base/joetoo-meta-0.0.3c
	)
"
# removed from innercore? ()
#		>=sys-apps/rpi-onetime-startup-1.0-r4
# removed from RDEPEND
#	>=sys-apps/rpi3-init-scripts-1.1.5-r1
# removed pigpio to add gpio (pigs deprecated)
#	>=dev-libs/pigpio-79

src_install() {
	# basic framework file to enable / disable USE flags for this package
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${PN}" "${PN}"
	insinto "/etc/portage/package.unmask/"
	newins "${FILESDIR}/package.unmask_${PN}" "${PN}"
	# for a joetoo installation, include vpn.start and vpn/service/temp monitoring tools
	if use joetoo ; then
		# vpn.start tool for rc service "local"
		insinto "/etc/local.d/"
		# 4 is stable but pigs is deprecated, so LEDs wont work on pi5
		newins "${FILESDIR}/raspi4_vpn.start" "raspi4_vpn.start"
		# 5 is better but experimental (know to change ip when re-establishing vpn)
		newins "${FILESDIR}/raspi5_vpn.start" "raspi5_vpn.start"
		exeinto "/usr/local/sbin/"
		# pi5 periodic monitor/LED set tools for vpn/temp/svcs
		for x in $(find ${FILESDIR} -iname pi5*) ; do newexe "${x}" "$(basename $x)" ; done
		# check cpu temp and frequency (monitor with "watch raspi_mon")
		newexe "${FILESDIR}/raspi_mon" "raspi_mon"
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
	elog "raspi564-headless-meta installed"
	elog ""
	elog "version 0.0.1 is the first ebuild for Pi 5"
	elog "version 0.0.2 added pi5 vpn.start & vpn/temp/svc monitor tools, for USE joetoo"
	elog "  and substituted USE gpio for pigpio (pigs deprecated; uses libgpiod)"
	elog "  raspi4_vpn.start is stable but pigs is deprecated, so LEDs wont work on pi5"
	elog "  raspi5_vpn.start is experimental (known to change ip when re-establishing vpn)"
	elog ""
	elog "Thank you for using raspi564-headless-meta"
}
