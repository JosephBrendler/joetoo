# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Rockchip bootloader firmware for supported boards"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
#SRC_URI=""

LICENSE="GPL-2 Rockchip"
SLOT="0"
KEYWORDS="~arm ~arm64"

IUSE="
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5
	-kernel -dtbo"

# require exactly one kind of board to be selected
REQUIRED_USE="
        ^^ ( rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 )
"

UPSTREAM_PV="6.x"

MY_PATH="${PN}-${UPSTREAM_PV}"

SRC_URI="https://raspi56406.brendler/${MY_PATH}/${MY_PATH}.tbz2"

RESTRICT="mirror binchecks strip"

# dpkg-deb is needed to extract armbian-build output products
BDEPEND="
	>=app-arch/dpkg-1.20.9-r1
"

RDEPEND="
	!sys-boot/raspberrypi-firmware
	${BDEPEND}
"

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

	# fix S
	S="${WORKDIR}/${MY_PATH}"

	einfo "S and T are used; here they are ..."
	einfo "  S=${S}"
	einfo "  T=${T}"
	einfo "A and D are not used, but here they are ..."
	einfo "  A=${A}"
	einfo "  D=${D}"
	einfo "P=${P}"
	einfo "  PN=${PN}"
	einfo "  PV=${PV}"
	einfo "  PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	einfo "MY_PATH=${MY_PATH}"
	einfo "SRC_URI=${SRC_URI}"
	einfo "board=${board}"
	einfo "kernel_name=${kernel_name}"
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
	if use kernel || use dtbo; then
		# extract kernel-build packages for this board from filesdir to temp space
		einfo "extracting kernel-build image from FILESDIR to temp space T ..."
		tar xvpf ${S}/${board}/kernel-output/kernel-*.tar -C ${T}/
		einfo "creating scratch space ..."
		mkdir ${T}/scratch
	fi
	if use kernel; then
		# extract the kernel-image deb package to temporary scractch space
		einfo "kernel use flag selected; extracting kernel image files ..."
		dpkg-deb -x ${T}/global/linux-image*.deb ${T}/scratch/
		# remove ./usr/lib -- is only dtb/overlay files to be installed by dtb
		einfo "pruning ./usr/lib (dtbs/overlays) -- installed w/ USE dtbo if needed ..."
		rm -rv ${T}/scratch/usr/lib
		# remove ./etc - is empty .d folders
		einfo "pruning ./etc (empty .d folders) ..."
		rm -rv ${T}/scratch/etc
		# install contents of boot, lib, and usr/share
		einfo "installing (ins) kernel image tree below into root / of install directory D ..."
		tree -L 4 --charset=C ${T}/scratch
		insinto "/"
		for dir in boot lib usr; do
			doins -r "${T}/scratch/${dir}"
			elog "Installed (doins -r) ${dir} in /"
		done
		# clean up temp scratch space
		einfo "cleaning up temporary scratch space ..."
		rm -rv "${T}/scratch/*"
	fi

	# if selected by use flag, install dtbos
	if use dtbo; then
		# extract the dtb/overlay deb package to temporary scractch space
		einfo "dtbo use flag selected; extracting dtb/overlay files ..."
		mkdir ${T}/scratch
		dpkg-deb -x ${T}/global/linux-dtb*.deb ${T}/scratch/
		# install contents of boot and usr/share
		einfo "installing (ins) dtb/overlay tree below into root / of install directory D ..."
		tree -L 3 --charset=C ${T}/scratch
		insinto "/"
		for dir in boot usr; do
			doins -r "${T}/scratch/${dir}"
			elog "Installed (doins -r) ${dir} in /"
		done
		# clean up temp scratch space
		einfo "cleaning up temporary scratch space ..."
		rm -rv "${T}/scratch/*"
	fi
}

pkg_postinst() {
	elog "Installed ${PN}"
	elog "Please read provided instructions regarding how to reflash u-boot"
	elog ""
	elog "ver 0.0.1 was the initial ebuild"
	elog " 0.0.2 provides actual armbian-build u-boot reflash resources for each board"
	elog " 0.1.0 delivers armbian-build kernel, dtbs, overlays, if selected by use flag"
	elog ""
	elog "****************************************************************************"
	elog "*** CAUTION: only use u-boot-reflash toosl if really needed, or to make  ***"
	elog "***    new boot media for a NEW system                                   ***"
	elog "***    Exercise caution - improper use could render system inoperable    ***"
	elog "****************************************************************************"
	elog ""
	elog "Please inspect your /boot setup and inspect in particular--"
	elog "  /boot/joetooEnv.txt -- "
        elog "      dtb_prefix       (path to .dtb file, rel. to /boot/ [or link to it])"
        elog "      fdtfile          (name of .dtb file)"
        elog "      overlay_prefix   (string that begins relevant overlay filenames)"
        elog "      overlays         (list of overlay filenames to load [minus prefix])"
        elog "      imagefile        (name of kernel image file to load [or link to it])"
        elog "      initrdfile       (name of initramfs file to load [or link to it])"
        elog "      rootdev          (path, UUID, or PARTUUID identifying root device)"
        elog "      rootfstype       (normally ext4)"
	elog "Verify that these settings match the /boot file structure and vice versa ..."
	elog ""
	elog "Thanks for using ${PN}"
}
