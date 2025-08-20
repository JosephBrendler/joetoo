# Copyright 2025-2055 joe brendler
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DESCRIPTION="kernel image for ${BOARD} sbc"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
#SRC_URI="https://raspi56406.brendler/amlogic-kernels/linux-${BOARD}_armbian_kernel_image-${PV}.tbz2"
SRC_URI="https://raspi56406.brendler/arm64-uefi-kernels/${PN}/${PN}-${PV}.tbz2"


S="${WORKDIR}/"

LICENSE="MIT"

# go multi-slot for kernel images
#SLOT="0"
SLOT=${PV}

KEYWORDS="~arm ~arm64"

IUSE="+dtbo +amlogic-sources"

RESTRICT="mirror"

BDEPEND="
"

RDEPEND="
	${BDEPEND}
	amlogic-sources? ( =sys-kernel/amlogic-sources-${PV} )
"

pkg_preinst() {
	# if /boot/efi is on a separate block device, and it is not mounted, try to mount it
	if grep -v '^#' /etc/fstab | grep boot/efi >/dev/null 2>&1  && \
		! grep "${ROOT%/}/boot/efi" /proc/mounts >/dev/null 2>&1
	then
		elog "${ROOT%/}/boot/efi is not mounted, trying to mount it now..."
		! $(mount /boot/efi) && \
			die "Failed to mount /boot" || \
			elog "Succeeded in mounting /boot/efi ; continuing..."
	else
		elog "Verified /boot/efi is mounted ; continuing..."
	fi
}

src_install() {
	einfo "BOARD=${BOARD}"
	einfo "SRC_URI=${SRC_URI}"
	einfo "  S=${S}"
	einfo "  T=${T}"
	einfo "  A=${A}"
	einfo "  D=${D}"
	einfo "P=${P}"
	einfo "  PN=${PN}"
	einfo "  PV=${PV}"
	einfo "  PVR=${PVR}"

	# not like the other armbian kernel (.tar, .deb) packages
	# just install everything in the tarball
	# Note: might be missing dtbo files (and may need to fix later)

	target="/"
	insinto "${target}"
	# doins -r and cp -a  "${S%/}/*" "${D%/}/" both don't work, so instead -
	# (don't) doins -r "${S}/*" || die "failed to install via doins"
	# (don't) cp -a "${S%/}/*" "${D%/}/" || die "failed to install via cp -a"
	# do recursive copy of everything found at top level of tarball
	for x in $(find ${S} -maxdepth 1 -mindepth 1 -type f -or -type d); do
		z=$(basename $x)
		einfo "copying $z ..."
		cp -a "${x}" "${D%/}/"  || die "failed to copy $z"
		elog "done copying $z"
	done
	elog "done installing"
	# now create links from / to /boot/ ***(not needed on uefi system)***
#	kernel=$(basename $(find ${D}/boot/ -maxdepth 1 -iname 'vmlinuz*') )
#	dosym -r /boot/${kernel} ../vmlinuz || die "failed to create symlink for vmlinuz"
#	elog "created symlink for vmlinuz"
#	initramfs=$(basename $(find ${D}/boot/ -maxdepth 1 -iname 'initrd*') )
#	dosym -r /boot/${initramfs} ../initrd || die "failed to create symlink for initrd"
#	elog "created symlink for initrd"
}

pkg_postinst() {
	elog "Installed ${P}"
	elog " version 6.12.42 was the initial ebuild for this package"
	elog " 6.12.42-r1-3 are bugfixes"
	elog ""
	elog "Note: this package supports all uefi enabled arm64 boards"
	elog "  If you change the kernel or initramfs, you must run -"
	elog "  e.g.  grub-mkconfig -o /boot/grub/grub.cfg"
	elog ""
	elog "Thank you for using ${PN}"
}
