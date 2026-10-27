# Copyright 2025-2026 Joe Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit joetoo_license

DESCRIPTION="Baseline per-package environment configurations for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/joetoo-upstream/master/${CATEGORY}/${PN}-${PV}.tbz2"

S="${WORKDIR}/${PN}"

LICENSE="metapackage"
SLOT="0"

KEYWORDS="amd64 arm arm64"

IUSE=" TBD"

#REQUIRED_USE=""   # pkgcheck scan complains about empty global vars

RESTRICT="mirror"

#RDEPEND=""   # pkgcheck scan complains about empty global vars

#BDEPEND="${RDEPEND}"   # pkgcheck scan complains about empty global vars

src_install() {
	elog "S=${S}"
	elog "D=${D}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog ""
	# per-package environment configuration files for joetoo
	target="/etc/portage/env"
		elog "Installing (ins) files into ${target} ..."
		insinto "${target}"
		for x in $(find "${S}" -maxdepth 1 -name '*.conf' -printf '%f\n') ; do
			newins "${S}/${x}" "${x}" || die "failed to install ${x}"
			elog "Installed ${target}/${x}"
		done
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/portage/package.env/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${S}/package.env" "package.env" || die "failed to install package.env"
		newins "${S}/README" "README" || die "failed to install README"
		elog "Installed ${target}/package.env"
		elog "Done installing (ins) files into ${target} ..."
	# run eclass joetoo_license code
	joetoo_license_src_install

}

pkg_postinst() {
	elog "${P} installed"
	elog "Please report bugs to the maintainer."
	elog ""
	elog "version_history can be found in the ebuild files directory."
	elog " 0.0.1 is the initial ebuild"
	elog " 1.0.0 is the first licensed version, migrated to joetoo-upstream, and with tools"
	elog " 1.0.1 fixes profile-adjusted category for lld"
	elog ""
	elog "Thank you for using ${PN}"
}
