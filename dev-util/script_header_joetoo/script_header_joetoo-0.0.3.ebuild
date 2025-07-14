# Copyright 2024-2054 Joe Brendler
# Distributed under the terms of the GNU General Public License v3
# joe brendler 6/8/2024

EAPI=8

DESCRIPTION="A script header with easy-to-use formatting colors and misc functions"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~amd64 x86 ~x86 arm ~arm arm64 ~arm64"
#KEYWORDS=""

# automatically also pull in dev-util/script-header-joetoo-extended
IUSE="+extended +niopt +examples"
REQUIRED_USE="
	examples? ( extended )
"
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
	target="/usr/sbin/"
		einfo "Installing (ins) ${PN} into ${target} ..."
		insinto "${target}"
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
	if use examples ; then
		einfo "examples USE flag is set"
		# install template script
		einfo "Installing (exe) template_script.bash into ${target} ..."
                exeinto "${target}"
		newexe "${S%/}/template_script.bash" "template_script.bash"
		elog "Installed template_script.bash in ${target}"

		# install example local cmdline arg processing and "usage" extension modules
		target="/etc/template_script.bash/"
		einfo "Installing (ins) cmdline arg and usage modules into ${target} ..."
		insinto "${target}"
		for x in $(find ${S%/}/ -iname "example*") ; do
			z=$(echo $(basename $x) | sed 's|example_||')
			newins "${x}" "${z}"
			elog "installed ${z} in ${target}"
		done
	fi

	elog "${P} installed"
	elog "Employ ${PN} functions after sourcing it "
	elog "(e.g. # source /usr/local/sbin/${PN})"
	elog ""
	elog "Notes:"
	elog "  enable the \"examples\" USE flag to get an example script and cmdline/usage modules"
	elog "  enable the \"extended\" USE flag to employ/source the extended function set"
	elog "  enable the \"niopt\" USE flag to employ/source the noninteractive function set"
	elog "  use commands \"summarize_me\" and \"summarize_my_extension\""
	elog ""
	elog "version_history, in the ebuild's FILESDIR, records version history"
	elog "(package upgraded and renamed)"
	elog " ver 0.0.0 is the initial build for the new package with cmdline processing, etc"
	elog " 0.0.1/2 provide refinements and bugfixes"
	elog " 0.0.3 fixes modular_msg and summarize_my_extension"
	elog ""
	elog "Thank you for using ${PN}"

}
