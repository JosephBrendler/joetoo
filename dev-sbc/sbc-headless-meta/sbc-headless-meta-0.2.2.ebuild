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
	+innercore +gpio +joetoo +boot-fw -kernelimage
	bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 rk3588s-rock-5c
"

REQUIRED_USE="
	innercore
	^^ ( bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 rk3588s-rock-5c )
"

RESTRICT=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

# keyword for arm or arm64 according to board selection
KEYWORDS="~arm ~arm64"

BDEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0
"

RDEPEND="
	${BDEPEND}
	>=sys-firmware/b43-firmware-5.100.138
	innercore? (
		>=sys-kernel/linux-firmware-20220310
		>=sys-apps/rng-tools-6.8
		>=sys-apps/sbc-gpio-0.0.1
		>=sys-apps/sbc-spi-0.0.1
		bcm2712-rpi-5-b?  (
			>=sys-boot/sbc-boot-config-0.0.1[bcm2712-rpi-5-b(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2711-rpi-4-b?   (
			>=sys-boot/sbc-boot-config-0.0.1[bcm2711-rpi-4-b(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2710-rpi-3-b-plus?   (
			>=sys-boot/sbc-boot-config-0.0.1[bcm2710-rpi-3-b-plus(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2710-rpi-3-b?   (
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			>=sys-boot/sbc-boot-config-0.0.1[bcm2710-rpi-3-b(+)]
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2709-rpi-2-b?   (
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			>=sys-boot/sbc-boot-config-0.0.1[bcm2709-rpi-2-b(+)]
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2708-rpi-b?   (
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			>=sys-boot/sbc-boot-config-0.0.1[bcm2708-rpi-b(+)]
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		rk3288-tinker-s?  (
			>=sys-boot/sbc-boot-config-0.0.1[rk3288-tinker-s(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3399-rock-pi-4c-plus?  (
			>=sys-boot/sbc-boot-config-0.0.1[rk3399-rock-pi-4c-plus(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3399-tinker-2? (
			>=sys-boot/sbc-boot-config-0.0.1[rk3399-tinker-2(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3588s-orangepi-5?    (
			>=sys-boot/sbc-boot-config-0.0.1[rk3588s-orangepi-5(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3588s-rock-5c?       (
			>=sys-boot/sbc-boot-config-0.0.1[rk3588s-rock-5c(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
	)
	gpio? (
		>=dev-libs/libgpiod-2.1
	)
	joetoo? (
		>=dev-util/joetoolkit-0.3.3
		bcm2712-rpi-5-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2712-rpi-5-b(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2712-rpi-5-b(+)]
		)
		bcm2711-rpi-4-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2711-rpi-4-b(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2711-rpi-4-b(+)]
		)
		bcm2710-rpi-3-b-plus? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2710-rpi-3-b-plus(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2710-rpi-3-b-plus(+)]
		)
		bcm2710-rpi-3-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2710-rpi-3-b(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2710-rpi-3-b(+)]
		)
		bcm2709-rpi-2-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2709-rpi-2-b(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2709-rpi-2-b(+)]
		)
		bcm2708-rpi-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2708-rpi-b(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2708-rpi-b(+)]
		)
		rk3288-tinker-s? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3288-tinker-s(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),rk3288-tinker-s(+)]
		)
		rk3399-rock-pi-4c-plus? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3399-rock-pi-4c-plus(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),rk3399-rock-pi-4c-plus(+)]
		)
		rk3399-tinker-2? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3399-tinker-2(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),rk3399-tinker-2(+)]
		)
		rk3588s-orangepi-5? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3588s-orangepi-5(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),rk3588s-orangepi-5(+)]
		)
		rk3588s-rock-5c? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3588s-rock-5c(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),rk3588s-rock-5c(+)]
		)
	)
	boot-fw? (
		bcm2712-rpi-5-b?        ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2712-rpi-5-b(+)] )
		bcm2711-rpi-4-b?        ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2711-rpi-4-b(+)] )
		bcm2710-rpi-3-b-plus?   ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2710-rpi-3-b-plus(+)] )
		bcm2710-rpi-3-b?        ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2710-rpi-3-b(+)] )
		bcm2709-rpi-2-b?        ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2709-rpi-2-b(+)] )
		bcm2708-rpi-b?          ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2708-rpi-b(+)] )
		rk3288-tinker-s?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3288-tinker-s(+)] )
		rk3399-rock-pi-4c-plus? ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3399-rock-pi-4c-plus(+)] )
		rk3399-tinker-2?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3399-tinker-2(+)] )
		rk3588s-orangepi-5?     ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588s-orangepi-5(+)] )
		rk3588s-rock-5c?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588s-rock-5c(+)] )
	)
	kernelimage? (
		bcm2712-rpi-5-b?        ( sys-kernel/linux-joetoo-kernelimage[bcm2712-rpi-5-b(+)] )
		bcm2711-rpi-4-b?        ( sys-kernel/linux-joetoo-kernelimage[bcm2711-rpi-4-b] )
		bcm2710-rpi-3-b-plus?   ( sys-kernel/linux-joetoo-kernelimage[bcm2710-rpi-3-b-plus(+)] )
		bcm2710-rpi-3-b?        ( sys-kernel/linux-joetoo-kernelimage[bcm2710-rpi-3-b(+)] )
		bcm2709-rpi-2-b?        ( sys-kernel/linux-joetoo-kernelimage[bcm2709-rpi-2-b(+)] )
		bcm2708-rpi-b?          ( sys-kernel/linux-joetoo-kernelimage[bcm2708-rpi-b(+)] )
		rk3288-tinker-s?        ( sys-kernel/linux-joetoo-kernelimage[rk3288-tinker-s(+)] )
		rk3399-rock-pi-4c-plus? ( sys-kernel/linux-joetoo-kernelimage[rk3399-rock-pi-4c-plus(+)] )
		rk3399-tinker-2?        ( sys-kernel/linux-joetoo-kernelimage[rk3399-tinker-2(+)] )
		rk3588s-orangepi-5?     ( sys-kernel/linux-joetoo-kernelimage[rk3588s-orangepi-5(+)] )
		rk3588s-rock-5c?        ( sys-kernel/linux-joetoo-kernelimage[rk3588s-rock-5c(+)] )
	)
"

pkg_setup() {
# for sbc systems we need to know which board we are using
	if use bcm2712-rpi-5-b ; then
		export board="bcm2712-rpi-5-b"
	else if use bcm2711-rpi-4-b ; then
		export board="bcm2711-rpi-4-b"
	else if use bcm2710-rpi-3-b-plus; then
		export board="bcm2710-rpi-3-b-plus"
	else if use bcm2710-rpi-3-b; then
		export board="bcm2710-rpi-3-b"
	else if use bcm2709-rpi-2-b; then
		export board="bcm2709-rpi-2-b"
	else if use bcm2708-rpi-b; then
		export board="bcm2708-rpi-b"
	else if use rk3288-tinker-s; then
		export board="rk3288-tinker-s"
	else if use rk3399-rock-pi-4c-plus; then
		export board="rk3399-rock-pi-4c-plus"
	else if use rk3399-tinker-2; then
		export board="rk3399-tinker-2"
	else if use rk3588s-orangepi-5; then
		export board="rk3588s-orangepi-5"
	else if use rk3588s-rock-5c; then
		export board="rk3588s-rock-5c"
	else
		export board=""
	fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi
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
	newexe "${FILESDIR}/cpu_gov.start" "cpu_gov.start"
	elog "Installed (newexe) cpu_gov.start"

	# config_protect this and other files in /etc/local.d
	newenvd "${FILESDIR}/config_protect" "99${PN}"


	# for a joetoo installation, include temp/freq monitoring tool
	if use joetoo ; then
		elog "USE joetoo selected"
		einfo "Installing (exe) tempfreq monitoring tool into /usr/sbin/"
		exeinto "/usr/sbin/"
		newexe "${FILESDIR}/tempfreq_mon_${board}" "tempfreq_mon_${board}"
		elog "  Installed (newexe) tempfreq_mon_${board}"
		# for raspberry boards, install joetoo's layout README file
		if [ "${board:0:3}" == "bcm" ] ; then
			einfo "Installing (ins) README-joetoo-raspberry-layout in /boot"
			insinto "/boot/"
			newins "${FILESDIR}/README-joetoo-raspberry-layout" "README-joetoo-raspberry-layout"
			elog "  Installed (newins) README-joetoo-raspberry-layout"
		fi
		# note: use=joetoo now pulls dependency dev-sbc/sbc-status-leds (above)
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
	elog "${P} installed for ${board}"
	elog "Depends on joetoo-meta by default (see joetoo USE flag) "
	elog ""
	elog "version 0.0.1 is the first consolidated ${PN} ebuild"
	elog " 0.0.2/3 provide bugfixes for supported boards"
	elog " 0.1.0 aligns boot-config, boot-firmware, and kernelimage for all boards"
	elog " 0.1.1/2 adds support for original rpi model b (bcm2708-rpi-b)"
	elog " 0.1.3 adds support for rpi 3 model b v1.2 (32 bit) (bcm2710-rpi-3-b)"
	elog " 0.1.5 adopts rk3399-rock-pi-4c-plus vice rk3399-rock-4c-plus"
	elog " 0.2.0 adopts the consolidated sys-kernel/linux-joetoo-kernelimage dependency"
	elog " 0.2.1 add support for rock 5c (rk3588s-rock-5c)"
	elog " 0.2.2 updates temp, freq monitor and package.use/mask"
	elog ""
	elog "Thank you for using ${PN}"
}
