# Copyright 2025-2056 Joe Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Baseline per-package environment configurations for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="arm ~arm amd64 ~amd64 arm64 ~arm64"

IUSE="
	-TBD
	"

REQUIRED_USE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	# basic set of configuration files for joetoo
	target="/etc/portage/env"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_portage_env_gold.conf_joetoo" "gold.conf"
		newins "${FILESDIR}/etc_portage_env_j1_makeopts.conf_joetoo" "j1_makeopts.conf"
		newins "${FILESDIR}/etc_portage_env_j4_makeopts.conf_joetoo" "j4_makeopts.conf"
		newins "${FILESDIR}/etc_portage_env_no_collision-protect.conf_joetoo" "no_collision-protect.conf"
		newins "${FILESDIR}/etc_portage_env_nodist_features.conf_joetoo" "nodist_features.conf"
		newins "${FILESDIR}/etc_portage_env_perl-5.26-always-dot_joetoo" "perl-5.26-always-dot"
		newins "${FILESDIR}/etc_portage_env_perl-5.26-unsafe-inc_joetoo" "perl-5.26-unsafe-inc"
		newins "${FILESDIR}/etc_portage_env_safe-cflags.conf_joetoo" "safe-cflags.conf"
		newins "${FILESDIR}/etc_portage_env_serialize-make.conf_joetoo" "serialize-make.conf"
		newins "${FILESDIR}/etc_portage_env_suppress-distcc.conf_joetoo" "suppress-distcc.conf"
		newins "${FILESDIR}/etc_portage_env_suppress-distcc-pump.conf_joetoo" "suppress-distcc-pump.conf"
		newins "${FILESDIR}/etc_portage_env_portage_tmpdir_on_rootfs.conf_joetoo" "portage_tmpdir_on_rootfs.conf"
		newins "${FILESDIR}/etc_portage_env_mysql-with-protobuf-bundled-conf_joetoo" "mysql-with-protobuf-bundled.conf"
		newins "${FILESDIR}/etc_portage_env_lang-en-us-utf8.conf_joetoo" "lang-en-us-utf8.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/portage/package.env/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_portage_package.env_joetoo" "package.env"
		elog "Done installing (ins) files into ${target} ..."
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "board=${board}"
	elog ""
	elog "${P} installed"
	elog "Please report bugs to the maintainer."
	elog ""
	elog "version_history can be found in the ebuild files directory."
	elog " 0.0.1 is the initial ebuild"
	elog ""
	elog "Thank you for using ${PN}"
}
