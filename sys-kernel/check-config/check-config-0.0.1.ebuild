# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# kernel builder program for embedded systems (tinkerboard s)

EAPI=8

inherit linux-info

DESCRIPTION="kernel configuration check experiments"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="arm arm64 amd64 ~arm ~arm64 ~amd64"

IUSE=""

REQUIRED_USE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND=""

BDEPEND="${RDEPEND}"

# Install for selected board(s) from above different choices, like joetoo-meta does via pkg_setup(),
# but note that where joetoo-meta is "exactly-one-of" board, this is "at-least-one-of"...
# Therefor, need to do in src_install and use for loop to install selected boards
pkg_preinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "A=${A}"
	einfo "T=${T}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"
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

		# check that these targets are either y or m
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
			# die "fat def codepage NOT ok (${fat_def_codepage})" ### don't kill over this
			ewarn "fat def codepage NOT ok (${fat_def_codepage})"
		fat_def_iocharset="$(linux_chkconfig_string FAT_DEFAULT_IOCHARSET)"
		[[ "${fat_def_iocharset}" == "\"iso8859-1\"" ]] && \
			elog "fat def iocharset ok (${fat_def_iocharset})" || \
			# die "fat def iocharset NOT ok (${fat_def_iocharset})" ### don't kill over this
			ewarn "fat def iocharset NOT ok (${fat_def_iocharset})"
	else
		die "I could not find a linux config for joetoo config-check"
	fi
}


pkg_postinst() {
	elog "${P} done"
}
