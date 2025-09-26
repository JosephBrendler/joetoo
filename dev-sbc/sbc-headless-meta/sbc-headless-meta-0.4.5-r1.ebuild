# Copyright (c) joe brendler joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="Baseline packages for a headless single board computer (sbc)"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="metapackage"
SLOT="0"
IUSE="
	+innercore +gpio +joetoo +boot-fw kernelimage
	bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-cm4-io bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-rock-4se rk3399-tinker-2
	rk3588-rock-5b rk3588-radxa-rock-5b+ rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	fsl-imx8mq-phanbell
	meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
	generic-armv6j generic-armv7a generic-aarch64
	generic-amd64
"

REQUIRED_USE="
	innercore
	joetoo
	^^ ( bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-cm4-io bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-rock-4se rk3399-tinker-2
	rk3588-rock-5b rk3588-radxa-rock-5b+ rk3588s-orangepi-5 rk3588s-orangepi-5b rk3588s-rock-5c
	fsl-imx8mq-phanbell
	meson-gxl-s905x-libretech-cc-v2 meson-sm1-s905d3-libretech-cc meson-g12b-a311d-libretech-cc
	generic-armv6j generic-armv7a generic-aarch64
	generic-amd64
	)
"

RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}/${PN}"

# keyword for arm or arm64 according to board selection (amd/64 for crossbuilding)
KEYWORDS="amd64 ~amd64 ~arm ~arm64"

BDEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0
"

# notes:
# (1) for USE joetoo, the joetoo-platform-meta[sbc,<board>] dependency should
#     confirm the package should have already been installed with those use
#     (and in the process installed make.conf, package.use, package.accept_keywords
#      files that will affect this installation)
# (2) starting with 0.0.4-r1 (for solitude, board=meson-sm1-s905d3-libretech-cc)
#I'm migrating uefi supported boards AWAY from sbc-boot-config
# i.e. for each such deployment, ** delete ** dependency on --
# >=sys-boot/sbc-boot-config-0.0.1[${board}(+)]
#
RDEPEND="
	${BDEPEND}
	>=sys-firmware/b43-firmware-5.100.138
	innercore? (
		>=sys-kernel/linux-firmware-20220310
		>=sys-apps/rng-tools-6.8
		>=sys-apps/sbc-gpio-0.0.1
		>=sys-apps/sbc-spi-0.0.1
		bcm2712-rpi-cm5-cm5io?  (
			>=sys-boot/sbc-boot-config-0.0.1[bcm2712-rpi-cm5-cm5io(+)]
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
			>=sys-boot/sbc-boot-config-0.0.1[bcm2711-rpi-cm4-io(+)]
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
		rk3399-rock-4se?  (
			>=sys-boot/sbc-boot-config-0.0.1[rk3399-rock-4se(+)]
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
		rk3588-radxa-rock-5b+?       (
			>=sys-boot/sbc-boot-config-0.0.1[rk3588-radxa-rock-5b+(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3588s-orangepi-5?    (
			>=sys-boot/sbc-boot-config-0.0.1[rk3588s-orangepi-5(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3588s-orangepi-5b?    (
			>=sys-boot/sbc-boot-config-0.0.1[rk3588s-orangepi-5b(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		rk3588s-rock-5c?       (
			>=sys-boot/sbc-boot-config-0.0.1[rk3588s-rock-5c(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		fsl-imx8mq-phanbell?   (
			>=sys-boot/sbc-boot-config-0.0.1[fsl-imx8mq-phanbell(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		meson-gxl-s905x-libretech-cc-v2?   (
			>=sys-boot/sbc-boot-config-0.0.1[meson-gxl-s905x-libretech-cc-v2(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		meson-sm1-s905d3-libretech-cc?   (
			>=sys-apps/sbc-i2c-0.0.1
		)
		meson-g12b-a311d-libretech-cc?   (
			>=sys-boot/sbc-boot-config-0.0.1[meson-g12b-a311d-libretech-cc(+)]
			>=sys-apps/sbc-i2c-0.0.1
		)
		generic-aarch64?  (
			>=sys-boot/sbc-boot-config-0.0.1[bcm2712-rpi-5-b(+)]
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)

		generic-armv7a?   (
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			>=sys-boot/sbc-boot-config-0.0.1[bcm2709-rpi-2-b(+)]
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
		generic-armv6j?   (
			>=sys-apps/rpi3-ondemand-cpufreq-1.1.1-r1
			>=sys-boot/sbc-boot-config-0.0.1[bcm2708-rpi-b(+)]
			media-libs/raspberrypi-userland
			>=sys-apps/rpi-i2c-1.0.1
			>=net-wireless/rpi3-wifi-regdom-1.1-r1
			>=sys-apps/rpi-serial-1.0.0-r1
			>=sys-apps/rpi-video-1.0.0-r1
		)
	)
	gpio? (
		>=dev-libs/libgpiod-2.1
	)
	joetoo? (
		>=dev-util/joetoolkit-0.3.3
		>=joetoo-base/joetoo-common-meta-0.0.1
		bcm2712-rpi-cm5-cm5io? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2712-rpi-cm5-cm5io(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),bcm2712-rpi-cm5-cm5io(+)]
		)
		bcm2712-rpi-5-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2712-rpi-5-b(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),bcm2712-rpi-5-b(+)]
		)
		bcm2711-rpi-cm4-io? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2711-rpi-cm4-io(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),bcm2711-rpi-cm4-io(+)]
		)
		bcm2711-rpi-4-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2711-rpi-4-b(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),bcm2711-rpi-4-b(+)]
		)
		bcm2710-rpi-3-b-plus? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2710-rpi-3-b-plus(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),bcm2710-rpi-3-b-plus(+)]
		)
		bcm2710-rpi-3-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2710-rpi-3-b(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),bcm2710-rpi-3-b(+)]
		)
		bcm2709-rpi-2-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2709-rpi-2-b(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),bcm2709-rpi-2-b(+)]
		)
		bcm2708-rpi-b? (
			>=dev-sbc/sbc-status-leds-0.0.1[bcm2708-rpi-b(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),bcm2708-rpi-b(+)]
		)
		rk3288-tinker-s? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3288-tinker-s(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3288-tinker-s(+)]
		)
		rk3399-rock-pi-4c-plus? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3399-rock-pi-4c-plus(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3399-rock-pi-4c-plus(+)]
		)
		rk3399-rock-4se? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3399-rock-4se(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3399-rock-4se(+)]
		)
		rk3399-tinker-2? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3399-tinker-2(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3399-tinker-2(+)]
		)
		rk3588-rock-5b? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3588-rock-5b(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3588-rock-5b(+)]
		)
		rk3588-radxa-rock-5b+? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3588-radxa-rock-5b+(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3588-radxa-rock-5b+(+)]
		)
		rk3588s-orangepi-5? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3588s-orangepi-5(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3588s-orangepi-5(+)]
		)
		rk3588s-orangepi-5b? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3588s-orangepi-5b(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3588s-orangepi-5b(+)]
		)
		rk3588s-rock-5c? (
			>=dev-sbc/sbc-status-leds-0.0.1[rk3588s-rock-5c(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),rk3588s-rock-5c(+)]
		)
		fsl-imx8mq-phanbell? (
			>=dev-sbc/sbc-status-leds-0.0.1[fsl-imx8mq-phanbell(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),fsl-imx8mq-phanbell(+)]
		)
		meson-gxl-s905x-libretech-cc-v2? (
			>=dev-sbc/sbc-status-leds-0.0.1[meson-gxl-s905x-libretech-cc-v2(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),meson-gxl-s905x-libretech-cc-v2(+)]
		)
		meson-sm1-s905d3-libretech-cc? (
			>=dev-sbc/sbc-status-leds-0.0.1[meson-sm1-s905d3-libretech-cc(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),meson-sm1-s905d3-libretech-cc(+)]
		)
		meson-g12b-a311d-libretech-cc? (
			>=dev-sbc/sbc-status-leds-0.0.1[meson-g12b-a311d-libretech-cc(+)]
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),meson-g12b-a311d-libretech-cc(+)]
		)
		generic-aarch64?  (
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),generic-aarch64(+)]
		)
		generic-armv7a?   (
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),generic-armv7a(+)]
		)
		generic-armv6j?   (
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),generic-armv6j(+)]
		)
		generic-amd64?   (
			>=joetoo-base/joetoo-platform-meta-0.0.1[sbc(+),generic-amd64(+)]
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
		rk3399-rock-4se?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3399-rock-4se(+)] )
		rk3399-tinker-2?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3399-tinker-2(+)] )
		rk3588-rock-5b?         ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588-rock-5b(+)] )
		rk3588-radxa-rock-5b+?  ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588-radxa-rock-5b+(+)] )
		rk3588s-orangepi-5?     ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588s-orangepi-5(+)] )
		rk3588s-orangepi-5b?    ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588s-orangepi-5b(+)] )
		rk3588s-rock-5c?        ( >=sys-boot/rockchip-boot-firmware-0.0.1[rk3588s-rock-5c(+)] )
		fsl-imx8mq-phanbell?    ( >=sys-boot/nxp-boot-firmware-0.0.1[fsl-imx8mq-phanbell(+)] )
		meson-gxl-s905x-libretech-cc-v2?  ( >=sys-boot/amlogic-boot-firmware-0.0.1[meson-gxl-s905x-libretech-cc-v2(+)] )
		meson-sm1-s905d3-libretech-cc?    ( >=sys-boot/amlogic-boot-firmware-0.0.1[meson-sm1-s905d3-libretech-cc(+)] )
		meson-g12b-a311d-libretech-cc?    ( >=sys-boot/amlogic-boot-firmware-0.0.1[meson-g12b-a311d-libretech-cc(+)] )
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
		rk3399-rock-4se?        ( sys-kernel/linux-rk3399-rock-4se_joetoo_kernelimage )
		rk3399-tinker-2?        ( sys-kernel/linux-rk3399-tinker-2_joetoo_kernelimage )
		rk3588-rock-5b?         ( sys-kernel/linux-rk3588-rock-5b_joetoo_-kernelimage )
		rk3588-radxa-rock-5b+?  ( sys-kernel/linux-rk3588-radxa-rock-5b+_joetoo_-kernelimage )
		rk3588s-orangepi-5?     ( sys-kernel/linux-rk3588s-orangepi-5_joetoo_kernelimage )
		rk3588s-orangepi-5b?    ( sys-kernel/linux-rk3588s-orangepi-5b_joetoo_kernelimage )
		rk3588s-rock-5c?        ( sys-kernel/linux-rk3588s-rock-5c_joetoo_-kernelimage )
		fsl-imx8mq-phanbell?    ( sys-kernel/linux-fsl-imx8mq-phanbell_joetoo_-kernelimage )
		meson-gxl-s905x-libretech-cc-v2?  ( sys-kernel/linux-meson-gxl-s905x-libretech-cc-v2_joetoo_-kernelimage )
		meson-sm1-s905d3-libretech-cc?    ( sys-kernel/linux-meson-sm1-s905d3-libretech-cc_joetoo_-kernelimage )
		meson-g12b-a311d-libretech-cc?    ( sys-kernel/linux-meson-g12b-a311d-libretech-cc_joetoo_-kernelimage )
	)
"

pkg_setup() {
	# for sbc systems we need to know which board we are using
	if use bcm2712-rpi-cm5-cm5io ; then export board="bcm2712-rpi-cm5-cm5io" ; export arch="arm64"
	elif use bcm2712-rpi-5-b ; then export board="bcm2712-rpi-5-b" ; export arch="arm64"
	elif use bcm2711-rpi-cm4-io ; then export board="bcm2711-rpi-cm4-io" ; export arch="arm64"
	elif use bcm2711-rpi-4-b ; then export board="bcm2711-rpi-4-b" ; export arch="arm64"
	elif use bcm2710-rpi-3-b-plus; then export board="bcm2710-rpi-3-b-plus" ; export arch="arm64"
	elif use bcm2710-rpi-3-b; then export board="bcm2710-rpi-3-b" ; export arch="arm"
	elif use bcm2709-rpi-2-b; then export board="bcm2709-rpi-2-b" ; export arch="arm"
	elif use bcm2708-rpi-b; then export board="bcm2708-rpi-b" ; export arch="arm"
	elif use rk3288-tinker-s; then export board="rk3288-tinker-s" ; export arch="arm"
	elif use rk3399-rock-pi-4c-plus; then export board="rk3399-rock-pi-4c-plus" ; export arch="arm64"
	elif use rk3399-rock-4se; then export board="rk3399-rock-4se" ; export arch="arm64"
	elif use rk3399-tinker-2; then export board="rk3399-tinker-2" ; export arch="arm64"
	elif use rk3588-rock-5b; then export board="rk3588-rock-5b" ; export arch="arm64"
	elif use rk3588-radxa-rock-5b+; then export board="rk3588-radxa-rock-5b+" ; export arch="arm64"
	elif use rk3588s-orangepi-5; then export board="rk3588s-orangepi-5" ; export arch="arm64"
	elif use rk3588s-orangepi-5b; then export board="rk3588s-orangepi-5b" ; export arch="arm64"
	elif use rk3588s-rock-5c; then export board="rk3588s-rock-5c" ; export arch="arm64"
	elif use fsl-imx8mq-phanbell; then export board="fsl-imx8mq-phanbell" ; export arch="arm64"
	elif use meson-gxl-s905x-libretech-cc-v2; then export board="meson-gxl-s905x-libretech-cc-v2" ; export arch="arm64"
	elif use meson-sm1-s905d3-libretech-cc; then export board="meson-sm1-s905d3-libretech-cc" ; export arch="arm64"
	elif use meson-g12b-a311d-libretech-cc; then export board="meson-g12b-a311d-libretech-cc" ; export arch="arm64"
	elif use generic-armv6j; then export board="generic-armv6j" ; export arch="arm"
	elif use generic-armv7a; then export board="generic-armv7a" ; export arch="arm"
	elif use generic-aarch64; then export board="generic-aarch64" ; export arch="arm64"
	elif use generic-amd64; then export board="generic-amd64" ; export arch="amd64"
	else export board="" ; export arch=""
	fi
	einfo "Assigned board: ${board}"
	einfo "Assigned arch: ${arch}"
}

src_install() {
	# Note: USE joetoo is now required; so pakcage.use, accept_keywords, make.conf come from joetoo-platform-meta now

	# install common package.unmask file
	target="/etc/portage/package.unmask/"
	einfo "Installing (ins) package.unmask_sbc-headless-meta into ${target}"
	insinto "${target}"
	newins "${S}/package.unmask_sbc-headless-meta" "package.unmask_${board}-headless-meta"
	elog "Installed (newins) package.unmask_sbc-headless-meta into ${target}"

	# install cpu_gove.start file in /etc/local.d
	target="/etc/local.d/"
	einfo "Installing (exe) cpu_gov.start into ${target}"
	exeinto "${target}"
	newexe "${S}/cpu_gov.start" "cpu_gov.start"
	elog "Installed (newexe) cpu_gov.start into ${target}"

	# install config_protect for this and other files in /etc/local.d
	einfo "Installing (envd) config_protect"
	newenvd "${S}/config_protect" "99${PN}"
	elog "Installed env.d file config_protect as 99${PN}"

	# USE joetoo is now required; so this is no longer an "if use" block -- include temp/freq monitoring tool
	target="/usr/sbin/"
	einfo "Installing (exe) tempfreq monitoring tool into ${target}"
	exeinto "${target}"
	newexe "${S}/tempfreq_mon_sbc" "tempfreq_mon_sbc"
	elog "  Installed (newexe) tempfreq_mon_sbc into ${target}"
	# install joetoo's layout README file
	target="/boot/"
	insinto "${target}"
	case ${board:0:3} in
		"bcm" ) readme_file="README-joetoo-raspberry-layout" ;;
		"rk3" ) readme_file="README-joetoo-rockchip-layout" ;;
		"mes" ) readme_file="README-joetoo-amlogic-layout" ;;
		"fsl" ) readme_file="README-joetoo-nxp-layout" ;;
	esac
	einfo "Installing (cp) ${readme_file} in ${target}"
	cp -v "${S}/${readme_file}" "${D}/boot/${readme_file}"
	elog "  Installed (cp) ${readme_file} into ${target}"
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "board=${board}"
	einfo "arch=${arch}"
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
	elog " 0.3.1 adds bcm2711-rpi-cm4-io and bcm2712-rpi-cm5-cm5io (compute modules)"
	elog " 0.3.2/-r1 provide a couple bugfixes"
	elog " 0.3.3 move to script_header_joetoo"
	elog " 0.3.4 adds meson-gxl-s905x-libretech-cc-v2 (sweet potato)"
	elog " 0.3.5 adds fsl-imx8mq-phanbell and consolidates common files"
	elog " 0.3.6 provides refinements and bugfixes, README_layout for joetoo sbcs"
	elog " 0.4.0 adds meson-g12b-a311d-libretech-cc (alta)"
	elog " 0.4.1 provides refinements and bugfixes"
	elog " 0.4.2 adds meson-sm1-s905d3-libretech-cc (solitude)"
	elog " 0.4.3 provides refinements and bugfixes"
	elog " 0.4.4 depends on joetoo-platform-meta and pull in joetoo-common-meta"
	elog " 0.4.4-r1 uefi board (solitude), drops sys-boot/sbc-boot-config dependency"
	elog " -r2 adds rk3588-radxa-rock-5b+ and rk3588s-orangepi-5b"
	elog " 0.4.5 is just a version bump to clarify latest"
	elog " -r1 adds rk3399-rock-4se"
	elog ""
	elog "Thank you for using ${PN}"
}
