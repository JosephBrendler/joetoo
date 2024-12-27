# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

DESCRIPTION="kernel image for joetoo pv xen vm"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="amd64 ~amd64"

IUSE=""

REQUIRED_USE=""

RESTRICT="mirror"

RDEPEND="
	=sys-kernel/gentoo-sources-${PV}
"

BDEPEND="${RDEPEND}"

SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/linux-domU_kernel_image-${PV}.tar.bz2"

# fix S
S=${WORKDIR}

pkg_setup() {
	einfo "Starting pkg_setup ..."
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
}

pkg_postinst() {
	einfo "Starting pkg_postinst ..."
	elog "${P} installed for ${board}"
	elog ""
	elog "version 0.0.0 is the initial template for consolidated ${PN} ebuilds"
	elog " ${PV} is a consolidated ebuild for ${P}"
	elog ""
	elog "Thank you for using ${PN}"
}
