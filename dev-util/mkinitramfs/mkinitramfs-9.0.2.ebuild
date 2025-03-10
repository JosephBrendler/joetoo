# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit linux-info

DESCRIPTION="create initramfs for LUKS encrypted / lvm system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/mkinitramfs-${PV}.tbz2"

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"

#KEYWORDS="~amd64 ~arm64"
KEYWORDS="amd64 ~amd64 arm64 ~arm64"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=dev-util/script_header_brendlefly-0.4.4
	>=sys-apps/which-2.21
	>=app-misc/pax-utils-1.1.7[python(+)]
	>=sys-libs/glibc-2.23
	>=sys-apps/file-5.29
	>=app-arch/cpio-2.12-r1
	>=sys-boot/grub-2.06-r1[device-mapper(+)]
	>=sys-fs/lvm2-2.02.188-r2[-udev(-)]
	>=sys-fs/cryptsetup-2.3.6-r2[urandom(+),openssl(+)]
	>=sys-apps/busybox-1.34.1[-static(-)]
"
DEPEND="${RDEPEND}"

pkg_preinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "A=${A}"
	einfo "T=${T}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
}

pkg_pretend() {
	if linux_config_exists ; then
		# first check for rotine y/n/m settings
		# define what to check for --
		#   ''  no prefix means "required"
		#   '~' prefix means "not required"
		#   '@' prefix means "must be a module"
		#   '!' prefix means "must not set"
		local CONFIG_CHECK="MD BLK_DEV ~BLK_DEV_LOOP ~FUSE_FS \
			BLK_DEV_INITRD BLK_DEV_DM DM_CRYPT ~DM_UEVENT \
			~DEVTMPFS ~UEVENT_HELPER ~RD_GZIP ~INITRAMFS_COMPRESSION_GZIP \
			~CRYPTO ~CRYPTO_AES ~CRYPTO_XTS ~CRYPT_USER_API ~CRYPTO_USER_API_SKCIPHER \
			~CRYPTO_RMD160 ~CRYPTO_SHA256 ~CRYPTO_SHA512 ~CRYPTO_WP512 ~CRYPTO_LRW \
			~CRYPTO_XCBC ~CRYPTO_SERPENT ~CRYPTO_TWOFISH \
			NLS_CODEPAGE_437 NLS_ASCII NLS_ISO8859_1 NLS_UTF8 \
			~MSDOS_FS VFAT_FS \
			"

		check_extra_config && elog "check_extra_config passed" || elog "check_extra_config failed"

		# next, check that these targets are either y or m
		targets="GENTOO_LINUX GENTOO_LINUX_PORTAGE"
		for target in ${targets} ; do
			linux_chkconfig_present ${target}  && \
			elog "${target} is present" || \
			# die "${target} is not present"  ### don't kill over this
			ewarn "${target} is not present"
		done

		# now check for some specific string settings
		fat_def_codepage=$(linux_chkconfig_string FAT_DEFAULT_CODEPAGE)
		[[ ${fat_def_codepage} -eq 437 ]] && \
			elog "fat def codepage ok (${fat_def_codepage})" || \
			# die "fat def codepage NOT ok (${fat_def_codepage})"  ### don't kill over this
			ewarn "fat def codepage NOT ok (${fat_def_codepage})"
		fat_def_iocharset="$(linux_chkconfig_string FAT_DEFAULT_IOCHARSET)"
		[[ "${fat_def_iocharset}" == "\"iso8859-1\"" ]] && \
			elog "fat def iocharset ok (${fat_def_iocharset})" || \
			# die "fat def iocharset NOT ok (${fat_def_iocharset})"  ### don't kill over this
			ewarn "fat def iocharset NOT ok (${fat_def_iocharset})"
	else
		die "I could not find a linux config for joetoo kernel config-check"
	fi
}

src_install() {
	# install utility scripts and baseline initramfs sources in /usr/src
	dodir /usr/src/${PN} && einfo "Created /usr/src/${PN} with dodir"
	einfo 'About to issue command: cp -v '${S}'/ '${D}'/usr/src/'
	cp -R "${S}/" "${D}/usr/src/" || die "Install failed!"
	elog ""
	dodir usr/bin/
	einfo "About to execute command cp -v "${S}"/ckinitramfs "${D}"/usr/bin/"
	cp -v "${S}/ckinitramfs" "${D}/usr/bin/" || die "Install failed!"
	elog "ckinitramfs installed in /usr/bin/"
	elog ""
	dodir etc/mkinitramfs/
	einfo "About to execute command cp -v "${S}"/mkinitramfs.conf "${D}"/etc/mkinitramfs/"
	cp -v "${S}/mkinitramfs.conf" "${D}/etc/mkinitramfs/" || die "Install failed!"
	elog "mkinitramfs.conf installed in /etc/mkinitramfs/"
	elog ""
	einfo "About to execute command cp -v "${S}"/init.conf "${D}"/etc/mkinitramfs/"
	cp -v "${S}/init.conf" "${D}/etc/mkinitramfs/" || die "Install failed!"
	elog "init.conf installed in /etc/mkinitramfs/"
	einfo "About to create PKG_PVR file"
	echo "${PVR}" > ${T}/PKG_PVR
	einfo "About to execute command cp -v "${T}"/PKG_PVR "${D}"/usr/src/mkinitramfs/PKG_PVR"
	cp -v "${T}/PKG_PVR" "${D}/usr/src/mkinitramfs/PKG_PVR" || die "Install failed!"
	elog "PKG_PVR file with content [${PVR}] installed in /PKG_PVR"
	elog ""
}

pkg_postinst() {
	elog "${P} installation complete."
	elog ""
	elog "mkinitramfs-5.4 was a significant rewrite of the package."
	elog "ver 5.9 corrects issues with lvm early availability."
	elog "Ensure you do not have USE=udev set for lvm2"
	elog "ver 6.1 corrects grub-related bugs"
	elog " 6.2 patches for a rare issuxe with cryptsetup failure for missing file"
	elog "  (libgcc_s.so.1) needed for cancel_pthreads"
	elog " 6.3 preserves init.conf by moving both config files to /etc/mkinitramfs/"
	elog " 6.4 puts ckinitramfs in /usr/bin instead of /usr/local/bin"
	elog " 6.5 drops lvmconf from dynexecutables and adds some lvm linked files"
	elog " 6.6 adds find to dynexecutables and fixes an associated bug"
	elog " 6.7 generalizes init to unlock nvmeXnXpZ, mmcblkXpX devices as well as sdXX"
	elog " 7.0 generalizes mkinitramfs to support raspberry pi 5 and other SBCs"
	elog " 7.1/2 fix bugs in dependent content copy and in output rotation"
	elog " 7.3 adds kernel config checks with the help of linux-info eclass"
	elog " 8.0 migrated to a merged-usr-like layout and moves scripts to FILESDIR"
	elog " 8.0.1 added verbosity to .conf and updates handling deps of executables"
	elog " 8.1.0 is a major rewrite of make_sources.sh (workedonly for merged-usr)"
	elog " 8.2.0 updates the init script and moves sources back to myUtilities repo"
	elog " 8.2.1 fixes bugs"
	elog " 8.2.2 stable for arm64, header dep >=0.4.2 for d_echo() isnumber() for ash"
	elog " 8.3.0-2 provide automatic dev/fs scan, simplicity, stability, resilience"
	elog " 9.0.0 is a renewed major rewrite of make_sources.sh"
	elog " 9.0.1 fixes ckinitramfs and consolidates a common_functions_header"
	elog " "
	elog "Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
