# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Baseline for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm ~amd64 ~arm64 arm amd64 arm64"
RESTRICT="mirror"
IUSE="+headless -plasma -gnome"
REQUIRED_USE="^^ ( headless plasma gnome )"

S="${WORKDIR}/${PN}"

RDEPEND=""
BDEPEND="${RDEPEND}"

pkg_setup() {
	elog "pkg_setup complete"
}

src_install() {
	target="/etc/portage/package.accept_keywords/"
	einfo "Installing (ins) files into ${target} ..."
	insinto "${target}"
	newins "${S}/package.accept_keywords.joetoo" "joetoo"
	if use plasma ; then
		newins "${S}/package.accept_keywords.plasma" "plasma"
	fi
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
	einfo "arch=${arch}"
	elog ""
	elog "${P} installed"
	elog "Please report bugs to the maintainer."
	elog ""
	elog "version_history can be found in the ebuild files directory."
	elog " 0.0.1 is the first separate ebuild for ${PN}"
	elog ""
	if use gnome; then
		ewarn "USE = gnome was specified, but is not implemented yet..."
		elog "USE = gnome was specified, but is not implemented yet..."
		elog ""
	fi
	elog ""
	elog "Thank you for using ${PN}"
}
