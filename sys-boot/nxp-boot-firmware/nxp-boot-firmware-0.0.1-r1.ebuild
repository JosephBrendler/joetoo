# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY
# installs u-boot files from ebuild's ${FILESDIR}
# if selected by USE armbian_kernel, depends on sys-kernel package to install kernel and dtb/overlays

EAPI=8

DESCRIPTION="Rockchip bootloader firmware for supported boards"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
#SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~arm64"

IUSE="
	fsl-imx8mq-phanbell
	+kernel +dtbo
"

# require exactly one kind of board to be selected
REQUIRED_USE="
        ^^ ( fsl-imx8mq-phanbell )
"

RESTRICT="mirror binchecks strip"

S="${WORKDIR}/"


BDEPEND="
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
	if use fsl-imx8mq-phanbell ; then
		export board="fsl-imx8mq-phanbell"
	fi
	einfo "Assigned board: ${board}"

	einfo "S and D are used; here they are ..."
	einfo "  S=${S}"
	einfo "  D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "  PN=${PN}"
	einfo "  PV=${PV}"
	einfo "  PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"
	einfo "board=${board}"
}

src_install() {
	# install boot firmware files
	einfo "Installing (ins) boot firmware files for ${board} into /boot/..."
	insinto /boot
	for x in $(find ${FILESDIR}/${board}/boot/ -type f  | grep -v config_protect); do
		d=$(dirname $x | sed "s|${FILESDIR}/${board}||")
		z=$(basename $x)
		[ ! -d ${D}/${d} ] && mkdir -p ${D}/${d}
		cp -p ${x} ${D}/${d}/${z} && \
			elog "installed /${d}/${z}" || die "failed to install /${d}/${z}"
	done
	# install config_protect
	einfo "Installing (newenvd) config_protect_u-boot_reflash_resources..."
	newenvd "${FILESDIR}/config_protect_u-boot_reflash_resources" "99${PN}"
	elog "installed config_protect_u-boot_reflash_resources"
}

pkg_postinst() {
	elog "Installed ${PN}"
	elog "ver 0.0.1 was the initial ebuild, supporting fsl-imx8mq-phanbell"
	elog ""
	elog "(for future upgrade to joetooEnv.txt)"
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
