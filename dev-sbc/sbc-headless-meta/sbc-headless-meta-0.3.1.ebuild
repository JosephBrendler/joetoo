# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY
# as of Jan 2025, we're deprecating the consolidated kernel image sys-kernel/linux-joetoo-kernelimage because
#  it is a maintenance challenge - all possible kernels must be built (i.e. for 12 boards as of now) before the
#  consolidated kernel ebuild will work for any of them.  We are moving instead back to an individual joetoo_kernelimage
#  for each board (model) supported

EAPI=7

DESCRIPTION="Baseline packages for a headless single board computer (sbc)"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${P}.tbz2"

LICENSE="metapackage"
SLOT="0"
IUSE="
	+innercore +gpio +joetoo +boot-fw -kernelimage
	bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-cm4-io bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588-rock-5b rk3588s-orangepi-5 rk3588s-rock-5c
"

REQUIRED_USE="
	innercore
	^^ ( bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-cm4-io bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588-rock-5b rk3588s-orangepi-5 rk3588s-rock-5c )
"

RESTRICT=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

# keyword for arm or arm64 according to board selection (amd/64 for crossbuilding)
KEYWORDS="amd64 ~amd64 ~arm ~arm64"

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
		bcm2712-rpi-cm5-cm5io?  (
			>=sys-boot/sbc-boot-config-0.0.1[bcm2712-rpi-5-b(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2712-rpi-5-b?  (
			>=sys-boot/sbc-boot-config-0.0.1[bcm2712-rpi-5-b(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		bcm2711-rpi-cm4-io?   (
			>=sys-boot/sbc-boot-config-0.0.1[bcm2711-rpi-4-b(+)]
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
		rk3588-rock-5b?       (
			>=sys-boot/sbc-boot-config-0.0.1[rk3588-rock-5b(+)]
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
		bcm2712-rpi-cm5-cm5io? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2712-rpi-cm5-cm5io(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2712-rpi-cm5-cm5io(+)]
		)
		bcm2712-rpi-5-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2712-rpi-5-b(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2712-rpi-5-b(+)]
		)
		bcm2711-rpi-cm4-io? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2711-rpi-cm4-io(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),bcm2711-rpi-cm4-io(+)]
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
		rk3588-rock-5b? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3588-rock-5b(+)]
			>=joetoo-base/joetoo-meta-0.2.0[sbc(+),rk3588-rock-5b(+)]
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
		bcm2712-rpi-cm5-cm5io?  ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2712-rpi-cm5-cm5io(+)] )
		bcm2712-rpi-5-b?        ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2712-rpi-5-b(+)] )
		bcm2711-rpi-cm4-io?     ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2711-rpi-cm4-io(+)] )
		bcm2711-rpi-4-b?        ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2711-rpi-4-b(+)] )
		bcm2710-rpi-3-b-plus?   ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2710-rpi-3-b-plus(+)] )
		bcm2710-rpi-3-b?        ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2710-rpi-3-b(+)] )
		bcm2709-rpi-2-b?        ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2709-rpi-2-b(+)] )
		bcm2708-rpi-b?          ( >=sys-boot/raspi-boot-firmware-1.20240424[bcm2708-rpi-b(+)] )
		rk3288-tinker-s?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3288-tinker-s(+)] )
		rk3399-rock-pi-4c-plus? ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3399-rock-pi-4c-plus(+)] )
		rk3399-tinker-2?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3399-tinker-2(+)] )
		rk3588-rock-5b?         ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588-rock-5b(+)] )
		rk3588s-orangepi-5?     ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588s-orangepi-5(+)] )
		rk3588s-rock-5c?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588s-rock-5c(+)] )
	)
	kernelimage? (
		bcm2712-rpi-cm5-cm5io?  ( sys-kernel/linux-bcm2712-rpi-cm5-cm5io_joetoo_kernelimage )
		bcm2712-rpi-5-b?        ( sys-kernel/linux-bcm2712-rpi-5-b_joetoo_kernelimage )
		bcm2711-rpi-cm4-io?     ( sys-kernel/linux-bcm2711-rpi-cm4-io_joetoo_kernelimage )
		bcm2711-rpi-4-b?        ( sys-kernel/linux-bcm2711-rpi-4-b_joetoo_kernelimage )
		bcm2710-rpi-3-b-plus?   ( sys-kernel/linux-bcm2710-rpi-3-b-plus_joetoo_kernelimage )
		bcm2710-rpi-3-b?        ( sys-kernel/linux-bcm2710-rpi-3-b_joetoo_kernelimage )
		bcm2709-rpi-2-b?        ( sys-kernel/linux-bcm2709-rpi-2-b_joetoo_kernelimage )
		bcm2708-rpi-b?          ( sys-kernel/linux-bcm2708-rpi-b_joetoo_kernelimage )
		rk3288-tinker-s?        ( sys-kernel/linux-rk3288-tinker-s_joetoo_kernelimage )
		rk3399-rock-pi-4c-plus? ( sys-kernel/linux-rk3399-rock-pi-4c-plus_joetoo_kernelimage )
		rk3399-tinker-2?        ( sys-kernel/linux-rk3399-tinker-2_joetoo_kernelimage )
		rk3588-rock-5b?         ( sys-kernel/linux-rk3588-rock-5b_joetoo_-kernelimage )
		rk3588s-orangepi-5?     ( sys-kernel/linux-rk3588s-orangepi-5_joetoo_kernelimage )
		rk3588s-rock-5c?        ( sys-kernel/linux-rk3588s-rock-5c_joetoo_-kernelimage )
	)
"

pkg_setup() {
# for sbc systems we need to know which board we are using
	if use bcm2712-rpi-cm5-cm5io ; then
		export board="bcm2712-rpi-cm5-cm5io"
	else if use bcm2712-rpi-5-b ; then
		export board="bcm2712-rpi-5-b"
	else if use bcm2711-rpi-cm4-io ; then
		export board="bcm2711-rpi-cm4-io"
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
	else if use rk3588-rock-5b; then
		export board="rk3588-rock-5b"
	else if use rk3588s-orangepi-5; then
		export board="rk3588s-orangepi-5"
	else if use rk3588s-rock-5c; then
		export board="rk3588s-rock-5c"
	else
		export board=""
	fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi
	einfo "Assigned board: ${board}"
}

src_install() {
	elog "Installing (ins) into /etc/portage/"
	insinto "/etc/portage/package.use/"
	newins "${S}/${PN}/package.use_${board}-headless-meta" "package.use_${board}-headless-meta"
	elog "Installed (newins) package.use_${board}-headless-meta"

	insinto "/etc/portage/package.accept_keywords/"
	newins "${S}/${PN}/package.accept_keywords_${board}-headless-meta" "package.accept_keywords_${board}-headless-meta"
	elog "Installed (newins) package.accept_keywords_${board}-headless-meta"

	insinto "/etc/portage/package.unmask/"
	newins "${S}/${PN}/package.unmask_${board}-headless-meta" "package.unmask_${board}-headless-meta"
	elog "Installed (newins) package.unmask_${board}-headless-meta"

	elog "Installing (exe) into /etc/local.d/"
	exeinto "/etc/local.d/"
	newexe "${S}/${PN}/cpu_gov.start" "cpu_gov.start"
	elog "Installed (newexe) cpu_gov.start"

	# config_protect this and other files in /etc/local.d
	newenvd "${S}/${PN}/config_protect" "99${PN}"


	# for a joetoo installation, include temp/freq monitoring tool
	if use joetoo ; then
		elog "USE joetoo selected"
		einfo "Installing (exe) tempfreq monitoring tool into /usr/sbin/"
		exeinto "/usr/sbin/"
		newexe "${S}/${PN}/tempfreq_mon_${board}" "tempfreq_mon_${board}"
		elog "  Installed (newexe) tempfreq_mon_${board}"
		# for raspberry boards, install joetoo's layout README file
		if [ "${board:0:3}" == "bcm" ] ; then
			einfo "Installing (ins) README-joetoo-raspberry-layout in /boot"
			insinto "/boot/"
			newins "${S}/${PN}/README-joetoo-raspberry-layout" "README-joetoo-raspberry-layout"
			elog "  Installed (newins) README-joetoo-raspberry-layout"
		fi
	else
		elog "USE joetoo NOT selected; NOT installing temp/freq monitoring tool"
	fi
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
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
	elog " 0.3.0 adds rk3588-rock-5b"
	elog " 0.3.1 adds bcm2711-rpi-cm4-io and bcm2712-rpi-cm5-cm5io"
	elog ""
	elog "Thank you for using ${PN}"
}
