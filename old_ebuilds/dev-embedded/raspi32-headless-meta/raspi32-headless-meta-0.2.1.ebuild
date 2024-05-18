# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Baseline packages for a headless Pi2 server with gentoo on rpi 32bit"
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
	boot-fw? (
		>=sys-boot/rpi2-32bit-firmware-1.20190819
	)
	!boot-fw? (
		!sys-boot/rpi2-32bit-firmware
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
		>=sys-boot/rpi2-boot-config-0.0.1
	)
	gpio? (
		>=dev-libs/libgpiod-2.1
	)
	joetoo? (
		>=joetoo-base/joetoo-meta-0.0.3c
		>=dev-util/joetoolkit-0.3.3
	)
"
# Note: joetoo will include openvpn and symlinks for it, etc.

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
		# optional vpn workaround is available...
		newins "${FILESDIR}/raspi2_vpn.start" "raspi2_vpn.start"
		elog "  Installed (newins) raspi2_vpn.start"
		# config_protect this and other files in /etc/local.d
		newenvd "${FILESDIR}/"config_protect 99${PN}
		elog "Installing (exe) into /usr/local/sbin/"
		exeinto "/usr/local/sbin/"
		# pi34 periodic monitor/LED set tools for vpn/temp/svcs
		for x in $(find ${FILESDIR}/ -iname *watch*)
		do
			newexe "${x}" "$(basename $x)" ;
			elog "  Installed (newexe) $(basename $x)" ;
		done
		# check cpu temp and frequency (monitor with "watch raspi_mon")
		newexe "${FILESDIR}/raspi_mon" "raspi_mon"
		elog "  Installed (newexe) raspi_mon"
		# pi2 cron job
		insinto "/etc/cron.d/"
		newins "${FILESDIR}/pi2_vst_watch_for_led_cron" "pi2_vst_watch_for_led_cron"
		elog "  Installed (newins) pi2_vst_watch_for_led_cron"
	else
		elog "USE joetoo NOT selected; NOT installing local.d and vpn/led/temp mon tools"
	fi
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "ED=${ED}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	elog ""
	elog "raspi32-headless-meta installed"
	elog ""
	elog "version 0.0.1 depends on joetoo-meta"
	elog "and includes local.d script for vpn & LEDs"
	elog "VPN will need keys and local/remote.conf links"
	elog ""
	elog "version 0.2.1 converts to cron job and gentoo openvpn.local/remote,"
	elog "  with workaround option, and it fixes temp threshold at 60 C"
	elog ""
	elog "run (e.g.) /etc/init.d/cronie restart to start the new cron jobs"
	elog ""
	elog "Thank you for using raspi32-headless-meta"
}
