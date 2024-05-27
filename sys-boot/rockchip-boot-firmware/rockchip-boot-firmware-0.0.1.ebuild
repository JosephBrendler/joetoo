# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Rockchip bootloader firmware for supported boards"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~arm64"

IUSE="rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 -kernel -dtbo"

# require exactly one kind of board to be selected
REQUIRED_USE="
        ^^ ( rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 )
"

RESTRICT="mirror binchecks strip"

DEPEND=""
RDEPEND="
	${DEPEND}"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

pkg_setup() {
	# if /boot is on a separate block device, and it is not mounted, try to mount it
	if grep -v '^#' /etc/fstab | grep boot >/dev/null 2>&1  && \
		! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1
	then
		elog "${ROOT%/}/boot is not mounted, trying to mount it now..."
		! $(mount /boot) && \
			die "Failed to mount /boot" || \
		elog "Succeeded in mounting /boot ; continuing..."
	else
		elog "Verified /boot is mounted ; continuing..."
	fi

	# for sbc systems we need to know which board we are using
	if use rk3288-tinker-s ; then
		export board="rk3288-tinker-s"
		export kernel_name="kernel_name_placeholder"
	else if use rk3399-rock-pi-4c-plus ; then
		export board="rk3399-rock-pi-4c-plus"
		export kernel_name="kernel_name_placeholder"
	else if use rk3399-tinker-2; then
		export board="rk3399-tinker-2"
		export kernel_name="kernel_name_placeholder"
	else if use rk3588s-orangepi-5; then
		export board="rk3588s-orangepi-5"
		export kernel_name="kernel_name_placeholder"
	fi; fi; fi; fi
	einfo "Assigned board: ${board}"

	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	einfo "SRC_URI=${SRC_URI}"
	einfo "board=${board}"
	einfo "kernel_name=${kernel_name}"
	einfo "uname_string=${uname_string}"
}

src_install() {
	# install u-boot_reflash_resources
	einfo "Installing (ins) u-boot_reflash_resources for ${board} into /boot/..."
	insinto /boot
		doins -r ${FILESDIR}/${board}/u-boot_reflash_resources
		elog "installed u-boot_reflash_resources"
	einfo "Installing (newenvd) config_protect_u-boot_reflash_resources..."
	newenvd "${FILESDIR}/config_protect_u-boot_reflash_resources" "99${PN}"
	elog "installed config_protect_u-boot_reflash_resources"

	# if selected by use flag, install kernel
	if use kernel; then
		elog "kernel use flag selected, but not implemented, yet"
	fi

	# if selected by use flag, install dtbos
	if use dtbo; then
		elog "dtbo use flag selected, but not implemented, yet"
	fi
}

pkg_postinst() {
	elog "Installed ${PN}"
	elog "Please read provided instructions regarding how to reflash u-boot"
	elog ""
	elog "*** Use only if really needed, or to create boot media for a NEW system ***"
	elog "***    Exercise caution - improper use could render system inoperable   ***"
	elog ""
	elog "Thanks for using ${PN}"
}
