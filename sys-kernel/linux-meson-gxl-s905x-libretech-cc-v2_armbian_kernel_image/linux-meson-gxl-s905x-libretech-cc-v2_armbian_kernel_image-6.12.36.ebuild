# Copyright 2025-2055 joe brendler
# Distributed under the terms of the GNU General Public License v3

EAPI=8

BOARD="${PN/linux-/}"
BOARD="${BOARD/_armbian_kernel_image/}"

DESCRIPTION="kernel image for ${BOARD} sbc"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raspi56406.brendler/amlogic-kernels/linux-${BOARD}_armbian_kernel_image-${PV}.tar"


S="${WORKDIR}/"

LICENSE="MIT"

# go multi-slot for kernel images
#SLOT="0"
SLOT=${PV}

KEYWORDS="~arm ~arm64"

IUSE="+dtbo +amlogic-sources"

RESTRICT="mirror"

BDEPEND="
	>=app-arch/dpkg-1.20.9-r1
"

RDEPEND="
	${BDEPEND}
	amlogic-sources? ( =sys-kernel/amlogic-sources-${PV} )
"

pkg_preinst() {
	# if /boot is on a separate block device, and it is not mounted, try to>
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
}

src_install() {
	einfo "BOARD=${BOARD}"
	einfo "SRC_URI=${SRC_URI}"
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
	# create file structure in which to install kernel and associated modules
	dodir / && einfo "Created / with dodir"
	dodir /lib && einfo "Created /lib with dodir"
	dodir /boot && einfo "Created /boot with dodir"
	dodir /boot/dts && einfo "Created /boot/dts with dodir"
	dodir /boot/overlays && einfo "Created /boot/overlays with dodir"

	# extract the kernel-image deb package to temporary scractch space
	einfo "creating scratch space ..."
	mkdir ${T}/scratch
	einfo "extracting kernel image files from deb package to scratch space ..."
	dpkg-deb -x ${S}/global/linux-image*.deb ${T}/scratch/
	# remove ./usr/lib -- is only dtb/overlay files to be installed below
	einfo "pruning ./usr/lib (dtbs/overlays) -- dtbs will be installed shortly and dtbos if requested by USE dtbo..."
	rm -rv ${T}/scratch/usr/lib
	# remove ./etc - is empty .d folders
	einfo "pruning ./etc (empty .d folders) ..."
	rm -rv ${T}/scratch/etc
	tree -L 4 --charset=C ${T}/scratch
	einfo "boot contains vmlinuz, config, System.map"
	einfo "lib contains modules for this kernel"
	einfo "usr now contains only doc files (changelog, copyright)"
	# install contents of boot, lib, and usr/share
	einfo "installing (ins) kernel image tree above into root / of install directory D ..."
	insinto "/"
	for dir in boot lib usr; do
		doins -r "${T}/scratch/${dir}"
		elog "Installed (doins -r) ${dir} in /"
	done
	# clean up temp scratch space
	einfo "cleaning up temporary scratch space ..."
	rm -rv ${T}/scratch/*


	# now extract and install the dtb files from deb package in temporary scractch space
	einfo "extracting dtb/overlay files from deb package to scratch space ..."
	dpkg-deb -x ${S}/global/linux-dtb*.deb ${T}/scratch/
	tree -L 3 --charset=C ${T}/scratch
	einfo "boot contains dtb folder (dtb files and overlays) for this kernel"
	einfo "usr contains only share/doc (changelog, copyright"
	# prune overlay folder from versioned dtb_folder, if not requested by USE dtbo
	if ! use dtbo ; then
		einfo "USE dtbo not selected; pruning overlays from dtb folder ..."
		dtb_folder="$(find ${T}/scratch/boot/ -mindepth 1 -maxdepth 1 -type d)"
		rm -rv ${dtb_folder}/amlogic/overlay
	fi
	# install contents of boot and usr/share
	einfo "installing (ins) dtb/overlay tree above into root / of install directory D ..."
	insinto "/"
	for dir in boot usr; do
		doins -r "${T}/scratch/${dir}"
		elog "Installed (doins -r) ${dir} in /"
	done
	# clean up temp scratch space
	einfo "cleaning up temporary scratch space ..."
	rm -rv ${T}/scratch/*
}

pkg_postinst() {
	elog "Installed ${P}"
	elog ""
	elog "Please inspect your /boot setup and verfiy in particular--"
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
	elog "Thank you for using ${PN}"
}
