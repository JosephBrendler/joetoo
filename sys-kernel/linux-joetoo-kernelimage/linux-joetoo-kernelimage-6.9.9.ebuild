# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

DESCRIPTION="kernel image for ${BOARD} sbc"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="arm arm64 amd64 ~arm ~arm64 ~amd64"

IUSE="
	-raspi-sources -rockchip-sources
	+dtb +dtbo
	-symlink
	bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5
	domU
"

REQUIRED_USE="
	^^ (
		bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
		rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5
		domU
	)
	bcm2708-rpi-b?        ( raspi-sources )
	bcm2709-rpi-2-b?      ( raspi-sources )
	bcm2710-rpi-3-b?      ( raspi-sources )
	bcm2710-rpi-3-b-plus? ( raspi-sources )
	bcm2711-rpi-4-b?      ( raspi-sources )
	bcm2712-rpi-5-b?      ( raspi-sources )
	rk3288-tinker-s?        ( rockchip-sources )
	rk3399-rock-pi-4c-plus? ( rockchip-sources )
	rk3399-tinker-2?        ( rockchip-sources )
	rk3588s-orangepi-5?     ( rockchip-sources )
	raspi-sources?    ( !rockchip-sources )
	rockchip-sources? ( !raspi-sources )
	domU?             ( !rockchip-sources !raspi-sources )
"

RESTRICT="mirror"

RDEPEND="
	raspi-sources?    ( =sys-kernel/raspi-sources-${PV} )
	rockchip-sources? ( =sys-kernel/rockchip-sources-${PV} )
	domU?             ( =sys-kernel/gentoo-sources-${PV} )
"

BDEPEND="${RDEPEND}"

SRC_URI="
	domU?                   ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-domU_kernel_image-${PV}.tar.bz2 )
	bcm2708-rpi-b?          ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2708-rpi-b_kernel_image-${PV}.tar.bz2 )
	bcm2709-rpi-2-b?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2709-rpi-2-b_kernel_image-${PV}.tar.bz2 )
	bcm2710-rpi-3-b?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2710-rpi-3-b_kernel_image-${PV}.tar.bz2 )
	bcm2710-rpi-3-b-plus?   ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2710-rpi-3-b-plus_kernel_image-${PV}.tar.bz2 )
	bcm2711-rpi-4-b?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2711-rpi-4-b_kernel_image-${PV}.tar.bz2 )
	bcm2712-rpi-5-b?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-bcm2712-rpi-5-b_kernel_image-${PV}.tar.bz2 )
	rk3288-tinker-s?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3288-tinker-s_kernel_image-${PV}.tar.bz2 )
	rk3399-rock-pi-4c-plus? ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3399-rock-pi-4c-plus_kernel_image-${PV}.tar.bz2 )
	rk3399-tinker-2?        ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3399-tinker-2_kernel_image-${PV}.tar.bz2 )
	rk3588s-orangepi-5?     ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3588s-orangepi-5_kernel_image-${PV}.tar.bz2 )
"
# fix S
S=${WORKDIR}

# NOTE: joetoo kernels for these boards don't yet work...
#	rk3399-tinker-2? ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3399-tinker-2_kernel_image-${PV}.tar.bz2 )
#	rk3588s-orangepi-5? ( https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-rk3588s-orangepi-5_kernel_image-${PV}.tar.bz2 )

#einfo "SRC_URI=${SRC_URI}"   ### for debugging global scope borken before functions get to run

pkg_setup() {
	einfo "Starting pkg_setup ..."
	# for sbc systems we need to know which board we are using
	if use bcm2708-rpi-b; then
		export board="bcm2708-rpi-b"
	else if use bcm2709-rpi-2-b; then
		export board="bcm2709-rpi-2-b"
	else if use bcm2710-rpi-3-b; then
		export board="bcm2710-rpi-3-b"
	else if use bcm2710-rpi-3-b-plus; then
		export board="bcm2710-rpi-3-b-plus"
	else if use bcm2711-rpi-4-b ; then
		export board="bcm2711-rpi-4-b"
	else if use bcm2712-rpi-5-b ; then
		export board="bcm2712-rpi-5-b"
	else if use rk3288-tinker-s; then
		export board="rk3288-tinker-s"
	else if use rk3399-rock-pi-4c-plus; then
		export board="rk3399-rock-pi-4c-plus"
	else if use rk3399-tinker-2; then
		export board="rk3399-tinker-2"
	else if use rk3588s-orangepi-5; then
		export board="rk3588s-orangepi-5"
	else
		export board=""
	fi; fi; fi; fi; fi; fi; fi; fi; fi; fi

	# mainly for debugging transparency - dump ebuild environment
	einfo "Assigned board: ${board}"
	einfo "SRC_URI=${SRC_URI}"
	einfo "WORKDIR=${WORKDIR}"
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "ED=${ED}"
	einfo "A=${A}"
	einfo "T=${T}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"
}

pkg_preinst() {
	einfo "Starting pkg_preinst ..."
	# if /boot is on a separate block device, and it is not mounted, try to>
	if grep -v '^#' /etc/fstab | grep boot >/dev/null 2>&1  && \
		! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1 ; then
		elog "${ROOT%/}/boot is not mounted, trying to mount it now..."
		! $(mount /boot) && \
			die "Failed to mount /boot" || \
			elog "Succeeded in mounting /boot ; continuing..."
	else
		elog "Verified /boot is mounted ; continuing..."
	fi
}

src_install() {
	einfo "Starting src_install ..."
	# create directory structures for kernel, modules, device tree files, overlays
	dodir / && einfo "Created / with dodir"
	dodir /lib && einfo "Created /lib with dodir"
	dodir /boot && einfo "Created /boot with dodir"
	if ! use domU ; then
		# note: joetoo's upstream sources put dtb files in "/boot/dts/${dtb_folder}/" where ${dtb_folder} is "rockchip" or "broadcom"
		# note: armbian upstream sources put dtb/overlay files in "boot/dtb-<branch>-<version>/${dtb_folder}/"
		#       and then and neen link dtb-<branch>-<version> <-- dtb in /boot/
		dodir /boot/dts && einfo "Created /boot/dts with dodir"
		# note: joetoo's upstream sources put overlay files in "/boot/dts/overlays"
		# note: armbian upstream sources put overlay files in "/boot/dtb-<branch>-<version>/${dtb_folder}/overlay"
		#       and then and neen link dtb-<branch>-<version> <-- dtb in /boot/
		dodir /boot/overlays && einfo "Created /boot/overlays with dodir"
	fi
	# Install kernel files
	einfo "Installing (ins) kernel files into /boot/"
	insinto "/boot/"
	for x in $(find ${S}/boot/ -type f -maxdepth 1); do
		z="$(basename ${x})"
		einfo "Installing $x as $z ..."
		newins "${x}" "${z}"
		elog "Installed kernel file ${z}"
	done
	# Install modules
	einfo "Installing (ins) modules into /lib/"
	insinto "/lib/"
	doins -r "${S}/lib/modules"
	elog "Installed modules"
	if ! use domU ; then
		# Conditionally install dtbs for this sbc board
		if use dtb ; then
			case ${BOARD:0:2} in
				"bc" )  dtb_folder="broadcom";;
				"rk" )  dtb_folder="rockchip";;
			esac
			einfo "Installing (ins) dtb files into /boot/dts/"
			insinto "/boot/dts"
			doins -r "${S}/boot/dts/${dtb_folder}"
			elog "Installed ${dtb_folder} dtb files"
			# pull just the right file up to /boot
			if [[ -e ${S}/boot/dts/${dtb_folder}/${BOARD}.dtb ]] ; then
				einfo "Installing ${board}.dtb into /boot/"
				insinto "/boot/"
				newins "${S}/boot/dts/${dtb_folder}/${BOARD}.dtb" "${BOARD}.dtb"
			elog "Installed ${board}.dtb into /boot/"
			else
				ewarn "Error: ${S}/boot/dts/${dtb_folder}/${BOARD}.dtb not found"
				elog "Error: ${S}/boot/dts/${dtb_folder}/${BOARD}.dtb not found"
				elog "You may need to get this file from another e.g. sys-kernel/linux-armbian_kernel package"
			fi
		else
			elog "use dtb not selected ; dtb files not installed"
		fi
		# Conditionally install dtbos
		if use dtbo ; then
			einfo "Installing (ins) dtbo files into /boot/overlays"
			insinto "/boot/dts/"
			doins -r "${S}/boot/dts/overlays"
			elog "Installed dtbo files"
		else
			elog "use dtbo not selected ; dtbo files not installed"
		fi
	else
		elog "use domU is selected ; dtb files are not applicable, not installed"
	fi
	# conditionally install symlink
	# To Do - if boot is not on vfat ==> [ ! "$(grep -v '^#' /etc/fstab | grep boot | awk '{print $3}')" == "vfat" ]
	#         then determine link name from joetooEnv.txt (rockchip imagefile=) or config.txt (raspi kernel=)
	if use symlink ; then
		elog "  (USE=\"symlink\") (set)"
		ewarn "USE symlink (selected), but this is not implemented yet"
	else
		elog "  (USE=\"-symlink\") (unset)"
		ewarn "use symlink not selected ; symlink for your kernel not installed"
	fi
}

pkg_postinst() {
	einfo "Starting pkg_postinst ..."
	elog "${P} installed for ${board}"
	elog ""
	elog "version 0.0.0 is a template for consolidated ${PN} ebuilds"
	elog ""
	elog "Thank you for using ${PN}"
}
