# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="Baseline packages for a headless single board computer (sbc)"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
IUSE="
	-boot-fw +innercore +gpio +joetoo
	bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus bcm2709-rpi-2-b
	rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2-s rk3588s-orangepi-5
"

REQUIRED_USE="
	innercore
	^^ ( bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus bcm2709-rpi-2-b
	rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2-s rk3588s-orangepi-5 )
"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

# keyword for arm or arm64 according to board selection
KEYWORDS="~arm ~arm64"

BDEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0
"

# to do: version 0.0.4 starts migration of required packages to joetoo
#   so you won't need the genpi overlay
RDEPEND="
	${BDEPEND}
	>=sys-firmware/b43-firmware-5.100.138
	innercore? (
		>=sys-kernel/linux-firmware-20220310
		>=sys-apps/rng-tools-6.8
		>=sys-apps/sbc-gpio-0.0.1
		>=sys-apps/sbc-spi-0.0.1
		bcm2712-rpi-5-b?  (
			>=dev-sbc/sbc-boot-config-0.0.1[bcm2712-rpi-5-b(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2711-rpi-4-b?   (
			>=dev-sbc/sbc-boot-config-0.0.1[bcm2711-rpi-4-b(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2710-rpi-3-b-plus?   (
			>=dev-sbc/sbc-boot-config-0.0.1[bcm2710-rpi-3-b-plus(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2709-rpi-2-b?   (
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			>=dev-sbc/sbc-boot-config-0.0.1[bcm2709-rpi-2-b(+)]
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		rk3288-tinker-s?  (
			>=dev-sbc/sbc-boot-config-0.0.1[rk3288-tinker-s(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3399-rock-pi-4c-plus?  (
			>=dev-sbc/sbc-boot-config-0.0.1[rk3399-rock-pi-4c-plus(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3399-tinker-2-s? (
			>=dev-sbc/sbc-boot-config-0.0.1[rk3399-tinker-2-s(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3588s-orangepi-5?    (
			>=dev-sbc/sbc-boot-config-0.0.1[rk3588s-orangepi-5(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
	)
	gpio? (
		>=dev-libs/libgpiod-2.1
	)
	joetoo? (
		>=joetoo-base/joetoo-meta-0.2.0
		>=dev-util/joetoolkit-0.3.3
		bcm2712-rpi-5-b?        ( >=dev-sbc/sbc-status-leds-0.0.1[bcm2712-rpi-5-b(+)] )
		bcm2711-rpi-4-b?        ( >=dev-sbc/sbc-status-leds-0.0.1[bcm2711-rpi-4-b(+)] )
		bcm2710-rpi-3-b-plus?   ( >=dev-sbc/sbc-status-leds-0.0.1[bcm2710-rpi-3-b-plus(+)] )
		bcm2709-rpi-2-b?        ( >=dev-sbc/sbc-status-leds-0.0.1[bcm2709-rpi-2-b(+)]  )
		rk3288-tinker-s?        ( >=dev-sbc/sbc-status-leds-0.0.1[rk3288-tinker-s(+)] )
		rk3399-rock-pi-4c-plus? ( >=dev-sbc/sbc-status-leds-0.0.1[rk3399-rock-pi-4c-plus(+)] )
		rk3399-tinker-2-s?      ( >=dev-sbc/sbc-status-leds-0.0.1[rk3399-tinker-2-s(+)] )
		rk3588s-orangepi-5?     ( >=dev-sbc/sbc-status-leds-0.0.1[rk3588s-orangepi-5(+)] )
	)
	boot-fw? (
		bcm2712-rpi-5-b?        ( >=sys-boot/rpi5-64bit-firmware-1.20230405 )
		bcm2711-rpi-4-b?        ( >=sys-boot/rpi3-64bit-firmware-1.20220331 )
		bcm2710-rpi-3-b-plus?   ( >=sys-boot/rpi3-64bit-firmware-1.20220331 )
		bcm2709-rpi-2-b?        ( >=sys-boot/rpi2-32bit-firmware-0.0.1 )
                rk3399-rock-pi-4c-plus? ( >=sys-boot/rock4c64-firmware-1.20230926 )
	)
"
# Note: boot-fw firmware packages for other rockchip boards not yet available

pkg_setup() {
# for sbc systems we need to know which board we are using
	if use bcm2712-rpi-5-b ; then
		export board="bcm2712-rpi-5-b"
	else if use bcm2711-rpi-4-b ; then
		export board="bcm2711-rpi-4-b"
	else if use bcm2710-rpi-3-b-plus; then
		export board="bcm2710-rpi-3-b-plus"
	else if use bcm2709-rpi-2-b; then
		export board="bcm2709-rpi-2-b"
	else if use rk3288-tinker-s; then
		export board="rk3288-tinker-s"
	else if use rk3399-rock-pi-4c-plus; then
		export board="rk3399-rock-pi-4c-plus"
	else if use rk3399-tinker-2-s; then
		export board="rk3399-tinker-2-s"
	else if use rk3588s-orangepi-5; then
		export board="rk3588s-orangepi-5"
	else
		export board=""
	fi; fi; fi; fi; fi; fi; fi; fi
	einfo "Assigned board: ${board}"
}

src_install() {
	elog "Installing (ins) into /etc/portage/"
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${board}-headless-meta" "package.use_${board}-headless-meta"
	elog "Installed (newins) package.use_${board}-headless-meta"

	insinto "/etc/portage/package.unmask/"
	newins "${FILESDIR}/package.unmask_${board}-headless-meta" "package.unmask_${board}-headless-meta"
	elog "Installed (newins) package.unmask_${board}-headless-meta"

	elog "Installing (exe) into /etc/local.d/"
	exeinto "/etc/local.d/"
	newexe "${FILESDIR}/cpu_gov.start" "/pu_gov.start"
	elog "Installed (newexe) cpu_gov.start"

	# config_protect this and other files in /etc/local.d
	newenvd "${FILESDIR}/config_protect" "99${PN}"


	# for a joetoo installation, include temp/freq monitoring tool
	if use joetoo ; then
		elog "USE joetoo selected; installing temp/freq monitor tool"
		elog "Installing (exe) into /usr/local/sbin/"
		exeinto "/usr/sbin/"
		newexe "${FILESDIR}/tempfreq_mon_${board}" "tempfreq_mon_${board}"
		elog "  Installed (newexe) tempfreq_mon_${board}"
		# note: use joetoo vpn/svc/temp now in dev-sbc/sbc-status-leds (above)
	else
		elog "USE joetoo NOT selected; NOT installing temp/freq monitoring tool"
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
	elog "${PN} installed for ${board}"
	elog "Depends on joetoo-meta by default (see joetoo USE flag) "
	elog ""
	elog "version 0.0.1 is the first consolidated ${PN} ebuild"
	elog ""
	elog "Thank you for using ${PN}"
}
