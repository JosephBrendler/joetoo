# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# joe brendler 6/8/2024
# this is a re-design which no longer uses a SRC_URI, juse ${FILESDIR}

EAPI=8

DESCRIPTION="A script header with easy-to-use formatting colors and misc functions"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
#KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE="extended niopt"
RESTRICT="mirror"

# these are now consolidated in FILESDIR
#RDEPEND="extended? ( dev-util/script_header_brendlefly_extended )
#	niopt? ( dev-util/script_header_brendlefly_noninteractive )"

RDEPEND=""

BDEPEND="${RDEPEND}"

src_install() {
	# install utility script header in /usr/local/sbin
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
		newins "${FILESDIR}/${PN}" "${PN}"
		elog "Installed ${PN} in ${target}"
		if use extended ; then
			einfo "extended USE flag is set"
			einfo "Installing (ins) ${PN}_extended into ${target} ..."
			newins "${FILESDIR}/${PN}_extended" "${PN}_extended"
			elog "Installed ${PN}_extended in ${target}"
		fi
		if use niopt ; then
			einfo "niopt USE flag is set"
			einfo "Installing (ins) ${PN}_noninteractive into ${target} ..."
			newins "${FILESDIR}/${PN}_noninteractive" "${PN}_noninteractive"
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
	elog "version 0.2.0 added color(), incl reverse video \"\${RVon}\""
	elog " 0.2.11, moved bs() and countdown() to the extended function set"
	elog " 0.3.0 added checkshell() to adjust for non-interactive shells"
	elog " 0.3.7 updated the swr() function, to use nmap"
	elog " 0.3.8 moved watchdistcc to dev-util/joetoolkit and added fe()"
	elog " 0.3.9 moved which() to dev-util/joetoolkit"
	elog " 0.3.10 updates checkboot() for x86/ x86_64/armv7l/aarch64"
	elog " 0.4.0 is a major rewrite, consolidating content in FILESDIR"
	elog " 0.4.1 fixes d_echo() and adds isnumber() and ishex() functions"
	elog " 0.4.2 fixes isnumber(), ishex(), and d_echo() for busybox (ash shell)"
	elog " 0.4.3 now uses #!/bin/sh, asigns VERBOSE/verbosity only if null, offers unbold colors"
	elog " 0.4.4 fixes d_echo and de_echo for null string e.g. d_echo 1"
	elog " 0.4.5 adds display_vars() and supporting functions get_longest(), echo_n_long()"
	elog " 0.4.6 fixes bugs"
	elog ""
	elog "Thank you for using ${PN}"

}
