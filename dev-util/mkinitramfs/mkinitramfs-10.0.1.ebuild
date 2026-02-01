# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit linux-info

DESCRIPTION="create initramfs for LUKS encrypted / lvm system"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"

KEYWORDS="amd64 ~amd64 arm64 ~arm64"
IUSE="+grub"
RESTRICT="mirror"

RDEPEND="dev-util/script_header_joetoo
	>=sys-apps/which-2.21
	>=app-misc/pax-utils-1.1.7[python(+)]
	>=sys-libs/glibc-2.23
	>=sys-apps/file-5.29
	>=app-arch/cpio-2.12-r1
	>=sys-fs/lvm2-2.02.188-r2[-udev(-)]
	>=sys-fs/cryptsetup-2.3.6-r2[urandom(+),openssl(+)]
	>=sys-apps/busybox-1.34.1[-static(-)]
	grub? ( >=sys-boot/grub-2.06-r1[device-mapper(+)] )
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
			~DEVTMPFS ~UEVENT_HELPER ~RD_GZIP  \
			~CRYPTO ~CRYPTO_AES ~CRYPTO_XTS ~CRYPTO_USER_API ~CRYPTO_USER_API_SKCIPHER \
			~CRYPTO_RMD160 ~CRYPTO_SHA256 ~CRYPTO_SHA512 ~CRYPTO_WP512 ~CRYPTO_LRW \
			~CRYPTO_XCBC ~CRYPTO_SERPENT ~CRYPTO_TWOFISH \
			NLS_CODEPAGE_437 NLS_ASCII NLS_ISO8859_1 NLS_UTF8 \
			~MSDOS_FS VFAT_FS \
			"

		check_extra_config && elog "check_extra_config passed" || elog "check_extra_config failed"

		# next, check that these targets are either y or m - but don't kill over this
		targets="GENTOO_LINUX GENTOO_LINUX_PORTAGE"
		for target in ${targets} ; do
			linux_chkconfig_present ${target}  && \
			elog "${target} is present" || \
			ewarn "${target} is not present"
		done

		# now check for some specific string settings - but don't kill over this
		fat_def_codepage=$(linux_chkconfig_string FAT_DEFAULT_CODEPAGE)
		[[ ${fat_def_codepage} -eq 437 ]] && \
			elog "fat def codepage ok (${fat_def_codepage})" || \
			ewarn "fat def codepage NOT ok (${fat_def_codepage})"
		fat_def_iocharset="$(linux_chkconfig_string FAT_DEFAULT_IOCHARSET)"
		[[ "${fat_def_iocharset}" == "\"iso8859-1\"" ]] && \
			elog "fat def iocharset ok (${fat_def_iocharset})" || \
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
	elog "ver 9.0.0 is a renewed major rewrite of make_sources.sh"
	elog " 9.0.1 fixes ckinitramfs and consolidates a common_functions_header"
	elog " 9.0.2/3 fix bugs and add debug in validate_passdevice()"
	elog " 9.0.4/5 fix bugs in ckinitramfs for merged- and split-usr systems"
	elog " 9.0.6 moves sources to dev-util and makes grub a USE option"
	elog " 9.0.7 fixes a bug"
	elog " 9.0.8/9 moves to script_header_joetoo"
	elog " 10.0.0 integrates script_header_joetoo (POSIX), upgrades all"
	elog " 10.0.1 provides bufixes and enhancements"
	elog " "
	elog "Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
