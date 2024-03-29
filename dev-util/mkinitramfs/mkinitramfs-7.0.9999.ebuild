# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="create initramfs for LUKS encrypted / lvm system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/mkinitramfs-${PV}.tbz2"

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"

KEYWORDS=""
IUSE="bogus"
RESTRICT="mirror"

RDEPEND=">=dev-util/script_header_brendlefly-0.3.9
	>=sys-apps/which-2.21
	>=app-misc/pax-utils-1.1.7
	>=sys-libs/glibc-2.23
	>=sys-apps/file-5.29
	>=app-arch/cpio-2.12-r1
	>=sys-boot/grub-2.06-r1
	>=sys-fs/lvm2-2.02.188-r2
	>=sys-fs/cryptsetup-2.3.6-r2
	>=sys-apps/busybox-1.34.1"
DEPEND="${RDEPEND}"
#	bogus? ( >=dev-util/bogus-2.0 )"

src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	# install utility scripts and baseline initramfs sources in /usr/src
	dodir /usr/src/${PN} && einfo "Created /usr/src/${PN} with dodir"
	einfo 'About to issue command: cp -R '${S}'/ '${D}'/usr/src/'
	cp -R "${S}/" "${D}/usr/src/" || die "Install failed!"
	elog ""
	dodir usr/bin/
	einfo "About to execute command cp -R "${S}"/ckinitramfs "${D}"/usr/bin/"
	cp -v "${S}/ckinitramfs" "${D}/usr/bin/" || die "Install failed!"
	elog "ckinitramfs installed in /usr/bin/"
	elog ""
	dodir etc/mkinitramfs/
	einfo "About to execute command cp -R "${S}"/mkinitramfs.conf "${D}"/etc/mkinitramfs/"
	cp -v "${S}/mkinitramfs.conf" "${D}/etc/mkinitramfs/" || die "Install failed!"
	elog "mkinitramfs.conf installed in /etc/mkinitramfs/"
	elog ""
	einfo "About to execute command cp -R "${S}"/init.conf "${D}"/etc/mkinitramfs/"
	cp -v "${S}/init.conf" "${D}/etc/mkinitramfs/" || die "Install failed!"
	elog "init.conf installed in /etc/mkinitramfs/"
	elog ""

	elog "mkinitramfs-5.4 was a significant rewrite of the package."
	elog "ver 5.9 corrects issues with lvm early availability."
	elog "Ensure you do not have USE=udev set for lvm2"
	elog "ver 6.1 corrects grub-related bugs"
	elog "ver 6.2 patches for a rare issuxe with cryptsetup failure for missing file"
	elog "  (libgcc_s.so.1) needed for cancel_pthreads"
	elog "ver 6.3 preserves init.conf by moving both config files to /etc/mkinitramfs/"
	elog "ver 6.4 puts ckinitramfs in /usr/bin instead of /usr/local/bin"
	elog "ver 6.5 drops lvmconf from dynexecutables and adds some lvm linked files"
	elog "ver 6.6 adds find to dynexecutables and fixes an associated bug"
	elog "ver 6.7 generalizes init to unlock nvmeXnXpZ, mmcblkXpX devices as well as sdXX"
	elog "ver 7.0 generalizes mkinitramfs to support raspberry pi 5 and other SBCs"
	elog ""
	elog "Please report any bugs you find to the maintainer."
	elog ""
	elog "Thank you for using mkinitramfs"
}
