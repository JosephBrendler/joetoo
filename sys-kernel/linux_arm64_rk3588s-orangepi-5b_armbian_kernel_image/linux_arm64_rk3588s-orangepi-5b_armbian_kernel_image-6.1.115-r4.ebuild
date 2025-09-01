# Copyright 2025-2055 joe brendler
# Distributed under the terms of the GNU General Public License v3

EAPI=8

BOARD="${PN/linux_arm64_/}"
BOARD="${BOARD/_armbian_kernel_image/}"

DESCRIPTION="kernel image for ${BOARD} sbc"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raspi56406.brendler/rockchip-kernels/${PN}-${PV}.tbz2"

S="${WORKDIR}/"

LICENSE="MIT"

# go multi-slot for kernel images
#SLOT="0"
SLOT=${PV}

KEYWORDS="~arm64"

IUSE="+dtbo +rockchip-sources"

RESTRICT="mirror"

BDEPEND="
"

RDEPEND="
	${BDEPEND}
	rockchip-sources? ( =sys-kernel/rockchip-sources-${PV} )
"

pkg_preinst() {
	export FALSE=''
	export TRUE=0
	EFI_MOUNT=$FALSE
	# if /boot/efi is on a separate block device, and it is not mounted, try to mount it
	elog "checking whether /boot/efi should be/is mounted ..."
	if grep -v '^#' /etc/fstab | grep boot/efi >/dev/null 2>&1  ; then
		EFI_MOUNT=$TRUE
		elog "Verified /boot/efi is supposed to be mounted; checking if it is ..."
		if ! grep "${ROOT%/}/boot/efi" /proc/mounts >/dev/null 2>&1 ; then
			elog "${ROOT%/}/boot/efi is not mounted, trying to mount it now ..."
			! $(mount /boot/efi) && \
				die "Failed to mount /boot" || \
				elog "Succeeded in mounting /boot/efi ; continuing ..."
		else
			elog "Verified ${ROOT%/}/boot/efi is mounted ; continuing ..."
		fi
	else
		elog "Verified /boot/efi is not supposed to be mounted ; continuing ..."
	fi
	BOOT_MOUNT=$FALSE
	# if /boot is on a separate block device, and it is not mounted, try to>
	elog "checking whether /boot should be/is mounted ..."
	if grep -v '^#' /etc/fstab | grep boot >/dev/null 2>&1  ; then
		BOOT_MOUNT=$TRUE
		elog "Verified /boot is supposed to be mounted; checking if it is ..."
		if ! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1 ; then
			elog "${ROOT%/}/boot is not mounted, trying to mount it now ..."
			! $(mount /boot) && \
				die "Failed to mount /boot" || \
				elog "Succeeded in mounting /boot ; continuing ..."
		else
			elog "Verified ${ROOT%/}/boot is mounted ; continuing ..."
		fi
	else
		elog "Verified /boot is not supposed to be mounted ; continuing ..."
	fi
}


src_install() {
	einfo "BOARD=${BOARD} (determined from ebuild filename; not used but available)"
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
	# but don't try to copy links into a vfat boot partition
	# not checking if /boot/efi is vat, because we know it is vfat but doesn't contain links
	FAT_PART=$FALSE
	if $BOOT_MOUNT ; then
		boot_part_type=$(findmnt /boot -n -o FSTYPE)
		if [[ "${boot_part_type}" == "vfat" ]] ; then
			elog "boot is mounted and is vfat ; setting FAT_PART TRUE"
			FAT_PART=$TRUE
		else
			elog "boot is mounted but is not vfat ; copying all including symlinks"
		fi
	else
		elog "boot is not supposed to be mounted ; copying all including symlinks"
	fi

	# tarball contains /usr/src, /lib/firmware, /lib/modules, /boot, and links to vmlinuz and uinitrd in /boot
	# install all content in each section except boot
	for subdir in $(find ${S} -mindepth 1 -maxdepth 1 -type d -and -not -type l | grep -v 'boot' ) ; do
		cp -a "${subdir}" "${D}/" || die "failed to copy -a ${subdir}"
		elog "Done copying ${subdir}"
	done

	# now copy symlinks in boot if boot is NOT on a vfat partition
	if $FAT_PART ; then
		# /boot is on a vfat partition, copy only files
		einfo "FAT_PART is TRUE (/boot is on a FAT partition); copying files only, not symlinks"
		for x in $(find ${S}/boot -mindepth 1 -type f); do
			bn=$(basename $x)
			dn=$(dirname $x | sed "s|^${S}||")
			einfo "checking if dn: $dn exists ..."
			if [ ! -d ${D}/${dn} ] ; then
				mkdir -p "${D}/${dn}" || die "failed to mkdir -p ${D}/${dn}"
				elog "Directory ${D}/${dn} did not exist; created with mkdir"
			else
				elog "Directory ${D}/${dn} already exists; skipping mkdir"
			fi
			einfo "copying bn: $bn into dn: $dn ..."
			if [ -f ${x} ] ;then
				cp -a "${x}" "${D}/${dn%/}/" || die "failed to cp -a ${x} ${D}/${dn%/}/"
				elog "Copied ${bn} to ${dn}"
			else
				elog "Source file ${x} does not exist; skipping"
			fi
			elog "Done copying $bn into $dn"
		done
	else
		# /boot is NOT on a vfat partition, copy all content
		cp -a "${S}/boot" "${D}/" || die "failed to copy -a ${S}/boot"
		elog "Done copying /boot"
	fi

	# now copy links at / pointing to /boot/vmlinuz and /boot/uInitrd
	einfo "Copying boot symlinks to /"
	for symlink in $(find ${S} -mindepth 1 -maxdepth 1 -type l) ; do
		cp -a "${symlink}" "${D}/" || die "failed to cp -a ${symlink} ${D}/"
		elog "Installed symlink ${symlink} to /"
	done
	elog "Done copying boot symlinks to /"
}

pkg_postinst() {
	elog "Installed ${P}"
	elog " version 6.1.115 is the initial ebuild for this package"
	elog " revisions -r1 to -r4 provide refinements and bugfixes"
	elog ""
	elog "Thank you for using ${PN}"
}
