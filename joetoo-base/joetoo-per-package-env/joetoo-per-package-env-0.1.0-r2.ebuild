# Copyright 2025-2056 Joe Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Baseline per-package environment configurations for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="arm ~arm amd64 ~amd64 arm64 ~arm64"
RESTRICT="mirror"

IUSE=" -TBD"

REQUIRED_USE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}/${PN}"

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	# per-package environment configuration files for joetoo
	target="/etc/portage/env"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		for x in $(find ${S} -maxdepth 1 -name '*.conf' -printf '%f\n') ; do
			newins "${S}/${x}" "${x}" || die "failed to install ${x}"
			elog "Installed ${target}/${x}"
		done
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/portage/package.env/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${S}/package.env" "package.env" || die "failed to install package.env"
		elog "Installed ${target}/package.env"
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
	elog " 0.0.2->10 update package.env with additional nodistmerge package"
	elog " 0.0.11 removes some j1_makeopts and changes most to j4"
	elog " 0.1.0 moves source to myUtilities repo"
	elog " 0.1.0-r1 fixes manifest"
	elog "Thank you for using ${PN}"
}
