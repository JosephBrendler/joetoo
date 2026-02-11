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

# automatically also pull in dev-util/script-header-joetoo-extended
IUSE="+extended +unicode +niopt +examples"
REQUIRED_USE="
	unicode? ( extended )
	examples? ( extended unicode )
"
RESTRICT="mirror"

RDEPEND="
	app-alternatives/awk
	sys-libs/ncurses[-minimal]
	sys-apps/util-linux
	|| ( net-analyzer/openbsd-netcat net-analyzer/netcat )
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/sed
	net-misc/openssh
"

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
		# install compatability header
		newins "${S%/}/${PN}_compat" "${PN}_compat" || die "failed to install ${PN}_compat"
		elog "Installed ${PN}_compat in ${target}"
		if use extended ; then
			einfo "extended USE flag is set"
			einfo "Installing (ins) ${PN}_extended into ${target} ..."
			newins "${S%/}/${PN}_extended" "${PN}_extended"
			elog "Installed ${PN}_extended in ${target}"
		fi
		if use unicode ; then
			einfo "unicode USE flag is set"
			einfo "Installing (ins) ${PN}_unicode into ${target} ..."
			newins "${S%/}/${PN}_unicode" "${PN}_unicode"
			elog "Installed ${PN}_unicode in ${target}"
		fi
		if use niopt ; then
			einfo "niopt USE flag is set"
			einfo "Installing (ins) ${PN}_noninteractive into ${target} ..."
			newins "${S%/}/${PN}_noninteractive" "${PN}_noninteractive"
			elog "Installed ${PN}_noninteractive in ${target}"
		fi
	if use examples ; then
		einfo "examples USE flag is set"
		# install emoji_demo script
		einfo "Installing (exe) emoji_demo script into ${target} ..."
		exeinto "${target}"
		newexe "${S%/}/emoji_demo" "emoji_demo"
		elog "Installed emoji_demo script in ${target}"

		# install POSIX application template script
		einfo "Installing (exe) joetoo_cli_example into ${target} ..."
		exeinto "${target}"
		newexe "${S%/}/joetoo_cli_example" "joetoo_cli_example"
		elog "Installed joetoo_cli_example in ${target}"

		# install example local cmdline arg processing and "usage" extension module
		target="/etc/joetoo_cli_example/"
		einfo "Installing (ins) cmdline arg and usage module into ${target} ..."
		insinto "${target}"
		newins "${S%/}/joetoo_cli_example_local.cmdline_arg_handler" "joetoo_cli_example_local.cmdline_arg_handler" || \
			die "failed to install joetoo_cli_example_local.cmdline_arg_handler"
		elog "installed joetoo_cli_example_local.cmdline_arg_handler in ${target}"

		# install POSIX application template .config file
		einfo "Installing (exe) joetoo_cli_example.conf into ${target} ..."
		exeinto "${target}"
		newexe "${S%/}/joetoo_cli_example.conf" "joetoo_cli_example.conf"
		elog "Installed joetoo_cli_example.conf in ${target}"

		# install a BUILD assignment file
		einfo "Installing (ins) BUILD assignment file in ${target}"
		echo "BUILD=${PVR}" > ${T}/BUILD || die "failed to create BUILD file"
		insinto "${target}"
		newins "${T}/BUILD" "BUILD" || die "failed to install BUILD file"
		elog "installed BUILD file in ${target}"

		# install an example BPN assignment file
		einfo "Installing (ins) example BPN assignment file in ${target}"
		echo "BPN=${PN}" > ${T}/BPN || die "failed to create BPN file"
		insinto "${target}"
		newins "${T}/BPN" "BPN" || die "failed to install BPN file"
		elog "installed BPN file in ${target}"
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
	elog " 0.3.0 implements POSIX command sequence framework"
	elog " 0.3.1-10 provide bugfixes and enhancements"
	elog " 0.4.0 deploys a new severity-aware, log-enabled, consolidated messaging system"
	elog ""
	elog "Thank you for using ${PN}"
}
