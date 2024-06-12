# Copyright joe brendler 2024-2699
# $Id$
#
# This ebuild simply deploys kernel/module/dtb/overlay packages built with sys-kernel/kernelupdate::joetoo
# Among other resources, reference https://www.raspberrypi.com/documentation/computers/linux_kernel.html
#

EAPI=8

BOARD="${PN/linux-/}"
BOARD="${BOARD/_kernel_image/}"

DESCRIPTION="kernel image for ${BOARD} sbc"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-${BOARD}_kernel_image-${PV}.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm ~arm64 ~amd64"

IUSE="+dtb -dtbo -symlink -raspi-sources -rockchip-sources"

REQUIRED_USE="
	raspi-sources? ( !rockchip-sources )
	rockchip-sources? ( !raspi-sources )
"

RESTRICT="mirror"

RDEPEND="
	raspi-sources?    ( =sys-kernel/raspi-sources-${PV} )
	rockchip-sources? ( =sys-kernel/rockchip-sources-${PV} )
"

DEPEND="${RDEPEND}"

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
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	# install kernel and associated modules
	dodir / && einfo "Created / with dodir"
	dodir /lib && einfo "Created /lib with dodir"
	dodir /boot && einfo "Created /boot with dodir"
	dodir /boot/dts && einfo "Created /boot/dts with dodir"
	dodir /boot/overlays && einfo "Created /boot/overlays with dodir"
	# Install kernel files
	einfo "Installing (ins) kernel files into /boot/"
	insinto "/boot/"
	for x in $(find ${S}boot/ -type f -maxdepth 1); do
		z="$(basename ${x})"
		einfo "Installing $x as $z ..."
		newins "${x}" "${z}"
		elog "Installed kernel file ${z}"
	done
	# Install modules
	einfo "Installing (ins) modules into /lib/"
	insinto "/lib/"
	doins -r "${S}lib/modules"
	elog "Installed modules"
	# Conditionally install dtbs
	if use dtb && [ ! "${BOARD:0:3}" == "dom" ] ; then
		case ${BOARD:0:2} in
			"bc" )  dtb_folder="broadcom";;
			"rk" )  dtb_folder="rockchip";;
		esac
		einfo "Installing (ins) dtb files into /boot/dts/"
		insinto "/boot/dts"
		doins -r "${S}boot/dts/${dtb_folder}"
		elog "Installed ${dtb_folder} dtb files"
		# pull just the right file up to /boot
		einfo "Installing ${BOARD}.dtb into /boot/"
		insinto "/boot/"
		newins "${S}boot/dts/${dtb_folder}/${BOARD}.dtb" "${BOARD}.dtb"
		elog "Installed ${BOARD}.dtb into /boot/"
	else
		elog "use dtb not selected ; dtb files not installed"
	fi
	# Conditionally install dtbos - in /boot/overlays rather than /boot/dts/overlays
	if use dtbo && [ ! "${BOARD:0:3}" == "dom" ] ; then
		einfo "Installing (ins) dtbo files into /boot/overlays"
		insinto "/boot/"
		doins -r "${S}boot/dts/overlays"
		elog "Installed dtbo files"
	else
		elog "use dtbo not selected ; dtbo files not installed"
	fi
	# conditionally install symlink
	if use symlink ; then
		elog "  (USE=\"symlink\") (set)"
		ewarn "USE symlink (selected), but this is not implemented yet"
	else
		elog "  (USE=\"-symlink\") (unset)"
		ewarn "use symlink not selected ; symlink for your kernel not installed"
	fi
	elog "Thank you for using ${PN}"
}
