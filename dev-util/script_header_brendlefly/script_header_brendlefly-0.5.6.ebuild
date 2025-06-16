# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# joe brendler 6/8/2024
# this is a re-design which DOES use SRC_URI again

EAPI=8

DESCRIPTION="A script header with easy-to-use formatting colors and misc functions"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~amd64 x86 ~x86 arm ~arm arm64 ~arm64"
#KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE="extended niopt"
RESTRICT="mirror"

RDEPEND=""

BDEPEND="${RDEPEND}"

S=${WORKDIR%/}/${PN}
src_install() {
	# install utility script header in /usr/local/sbin
	einfo "WORKDIR=${WORKDIR}"
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo ""
	target="/usr/local/sbin/"
		einfo "Installing (ins) ${PN} into ${target} ..."
		insinto "${target}"
#		newins "${FILESDIR}/${PN}" "${PN}"
		newins "${S%/}/${PN}" "${PN}"
		elog "Installed ${PN} in ${target}"
		if use extended ; then
			einfo "extended USE flag is set"
			einfo "Installing (ins) ${PN}_extended into ${target} ..."
			newins "${S%/}/${PN}_extended" "${PN}_extended"
			elog "Installed ${PN}_extended in ${target}"
		fi
		if use niopt ; then
			einfo "niopt USE flag is set"
			einfo "Installing (ins) ${PN}_noninteractive into ${target} ..."
			newins "${S%/}/${PN}_noninteractive" "${PN}_noninteractive"
			elog "Installed ${PN}_noninteractive in ${target}"
		fi


	elog "${P} installed"
	elog "Employ ${PN} functions after sourcing it "
	elog "(e.g. # source /usr/local/sbin/${PN})"
	elog ""
	elog "Notes:"
	elog "  enable the \"extended\" USE flag to employ/source the extended function set"
	elog "  enable the \"niopt\" USE flag to employ/source the noninteractive function set"
	elog "  use commands \"summarize_me\" and \"summarize_my_extension\""
	elog ""
	elog "version_history, in the ebuild's FILESDIR, records version history"
	elog " 0.4.7 fixes a bug in display_vars()"
	elog " 0.4.8 adds function initialize_vars()"
	elog " 0.5.0 moves to myUtilities repo and adds yn var type for display_vars"
	elog " 0.5.1 fixes bugs in display_ and initialize_vars"
	elog " 0.5.2 makes (extended) bs() quieter"
	elog " 0.5.3 fixes a typo in initialize_vars()"
	elog " 0.5.4 bugfixes initialize_vars() and moves package to dev-util in src repo"
	elog " 0.5.5/6 refine display_ and initialize_vars"
	elog ""
	elog "Thank you for using ${PN}"

}
