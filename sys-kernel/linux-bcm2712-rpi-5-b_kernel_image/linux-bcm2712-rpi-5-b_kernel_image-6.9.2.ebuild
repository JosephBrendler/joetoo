# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

BOARD="${PN/linux-/}"
BOARD="${BOARD/_kernel_image/}"

DESCRIPTION="kernel image for ${BOARD} sbc"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-${BOARD}_kernel_image-${PV}.tar.bz2"

S="${WORKDIR}/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~arm ~arm64"
IUSE="+dtb +dtbo -symlink -sources"
RESTRICT="mirror"

RDEPEND="
	sources? ( =sys-kernel/raspi-sources-${PV} )
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
		elog "Installed kernel file 9${z}"
	done
	# Install modules
	einfo "Installing (cp) modules into /lib/"
	einfo 'About to issue command: cp -R '${S}'lib '${D}
	cp -R "${S}lib" "${D}" || die "Install failed!"
	elog "Installed modules"
	# Conditionally install dtbs
	if use dtb && ! "${BOARD:0:3}" == "dom" ; then
		einfo "Installing (cp) dtb files into /boot/dts/broadcom"
		einfo 'About to issue command: cp -R '${S}'boot/dts/broadcom '${D}'boot/dts'
		cp -R "${S}boot/dts/broadcom" "${D}boot/dts/" || die "Install failed!"
		elog "Installed dtb files"
		# pull just the right file up to /boot
		einfo "Installing ${BOARD}.dtb into /boot/"
		einfo 'About to issue command: cp -R '${S}'boot/dts/broadcom/${BOARD}.dtb '${D}'boot/'
		cp  "${S}boot/dts/broadcom/${BOARD}" "${D}boot/" || die "Install failed!"
		elog "Installed ${BOARD}.dtb into /boot/"
	else
		elog "use dtb not selected ; dtb files not installed"
	fi
	# Conditionally install dtbos - in /boot/overlays rather than /boot/dts/overlays
	if use dtbo && ! "${BOARD:0:3}" == "dom" ; then
		einfo "Installing (cp) dtbo files into /boot/overlays"
		einfo 'About to issue command: cp -R '${S}'boot/dts/overlays '${D}'boot/'
		cp -R "${S}boot/dts/overlays" "${D}boot/" || die "Install failed!"
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
