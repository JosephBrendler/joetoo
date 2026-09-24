# Copyright 2024-2026 Joseph Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit joetoo_license

DESCRIPTION="script header w easy formatting, UI, CLI, and many functions"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/joetoo-upstream/master/${CATEGORY}/${PN}-${PV}.tbz2"
# first ebuild using an eclass

S="${WORKDIR%/}/${PN}"

LICENSE="GPL-3+"

SLOT="0"

KEYWORDS="amd64 arm arm64 x86"

# automatically also pull in dev-util/script-header-joetoo-extended
IUSE="+extended +niopt +examples unicode_data"
REQUIRED_USE="
	examples? ( extended )
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

src_install() {
	# install utility script header in /usr/local/sbin
	elog "WORKDIR=${WORKDIR}"
	elog "S=${S}"
	elog "D=${D}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog ""
	target="/usr/sbin/"
		einfo "Installing (ins) ${PN} into ${target} ..."
		insinto "${target}"
		newins "${S%/}/${PN}" "${PN}"
		elog "Installed ${PN} in ${target}"
		# install unicode hex codepoint definitions
		einfo "Installing (ins) ${PN}_unicode into ${target} ..."
		insinto "${target}"
		newins "${S%/}/${PN}_unicode" "${PN}_unicode"
		elog "Installed ${PN}_unicode in ${target}"
		# install unicode registry definitions
		einfo "Installing (ins) ${PN}_registries into ${target} ..."
		insinto "${target}"
		newins "${S%/}/${PN}_registries" "${PN}_registries"
		elog "Installed ${PN}_registries in ${target}"
		# install uiasset definitions
		einfo "Installing (ins) ${PN}_uiassets into ${target} ..."
		insinto "${target}"
		newins "${S%/}/${PN}_uiassets" "${PN}_uiassets"
		elog "Installed ${PN}_uiassets in ${target}"
		# install ssh key management module
		einfo "Installing (ins) ${PN}_ssh into ${target} ..."
		insinto "${target}"
		newins "${S%/}/${PN}_ssh" "${PN}_ssh"
		elog "Installed ${PN}_ssh in ${target}"
		# install demonstrate_header script
		einfo "Installing (ins) demonstrate_header into ${target} ..."
		exeinto "${target}"
		newexe "${S%/}/demonstrate_header" "demonstrate_header"
		elog "Installed demonstrate_header in ${target}"
		# install compatability header
		newins "${S%/}/${PN}_compat" "${PN}_compat" || die "failed to install ${PN}_compat"
		elog "Installed ${PN}_compat in ${target}"
	target="/etc/${PN}/"
			# install a BUILD assignment file for ${PN}
			einfo "Installing (ins) BUILD assignment file in ${target}"
			echo "BUILD=${PVR}" > "${T}/BUILD" || die "failed to create BUILD file"
			insinto "${target}"
			newins "${T}/BUILD" "BUILD" || die "failed to install BUILD file"
			elog "installed BUILD file in ${target}"
	target="/etc/demonstrate_header/"
			# install the demonstrate_header.conf file
			einfo "Installing (ins) demonstrate_header.conf into ${target} ..."
			exeinto "${target}"
			newexe "${S%/}/demonstrate_header.conf" "demonstrate_header.conf"
			elog "Installed demonstrate_header.conf in ${target}"
			# install the demonstrate_header_local.cmdline_arg_handler
			einfo "Installing (ins) demonstrate_header cmdline arg and usage module into ${target} ..."
			insinto "${target}"
			newins "${S%/}/demonstrate_header_local.cmdline_arg_handler" "demonstrate_header_local.cmdline_arg_handler" || \
				die "failed to install demonstrate_header_local.cmdline_arg_handler"
			elog "installed demonstrate_header_local.cmdline_arg_handler in ${target}"
			# install a BUILD assignment file for demonstrate_header
			einfo "Installing (ins) BUILD assignment file in ${target}"
			echo "BUILD=${PVR}" > "${T}/BUILD" || die "failed to create BUILD file"
			insinto "${target}"
			newins "${T}/BUILD" "BUILD" || die "failed to install BUILD file"
			elog "installed BUILD file in ${target}"

	# run eclass joetoo_license code
	joetoo_license_src_install

	target="/usr/sbin/"
		insinto "${target}"
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
	# install optional content for examples
	if use examples ; then
		einfo "examples USE flag is set"
		# install POSIX application template scripts
		einfo "Installing (exe) joetoo_cli_example scripts into ${target} ..."
		exeinto "${target}"
		newexe "${S%/}/joetoo_cli_example" "joetoo_cli_example"
		elog "Installed joetoo_cli_example in ${target}"
		newexe "${S%/}/joetoo_cli_example_mini" "joetoo_cli_example_mini"
		elog "Installed joetoo_cli_example_mini in ${target}"

		# install example local cmdline arg processing and "usage" extension module
		for example in "joetoo_cli_example" "joetoo_cli_example_mini"; do
			target="/etc/${example}/"
			einfo "Installing (ins) $example cmdline arg and usage module into ${target} ..."
			insinto "${target}"
			# use the joetoo_cli_example handler for both
			newins "${S%/}/joetoo_cli_example_local.cmdline_arg_handler" "${example}_local.cmdline_arg_handler" || \
				die "failed to install ${example}_local.cmdline_arg_handler"
			elog "installed ${example}_local.cmdline_arg_handler in ${target}"

			# install POSIX application template .config file
			einfo "Installing (exe) ${example}.conf into ${target} ..."
			exeinto "${target}"
			# use the joetoo_cli_example .conf for both
			newexe "${S%/}/joetoo_cli_example.conf" "${example}.conf"
			elog "Installed ${example}.conf in ${target}"

			# install a BUILD assignment file (for both examples)
			einfo "Installing (ins) BUILD assignment file in ${target}"
			echo "BUILD=${PVR}" > "${T}/BUILD" || die "failed to create BUILD file"
			insinto "${target}"
			newins "${T}/BUILD" "BUILD" || die "failed to install BUILD file"
			elog "installed BUILD file in ${target}"

			# install an example BPN assignment file (for both examples)
			einfo "Installing (ins) example BPN assignment file in ${target}"
			echo "BPN=${PN}" > "${T}/BPN" || die "failed to create BPN file"
			insinto "${target}"
			newins "${T}/BPN" "BPN" || die "failed to install BPN file"
			elog "installed BPN file in ${target}"
		done
	fi
	# install optional content for unicode_data reference files
	if use unicode_data ; then
	        target="/usr/share/${PN}/"
		einfo "Installing (ins) unicode reference data in $target"
		insinto "$target"
		insopts -m0644
		doins -r "${S}/unicode_data" || die "failed to install unicode reference data in $target"
		elog "installed unicode_data in $target"
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
	elog " 1.0.0 is the first version to distribute licenses"
	elog " 1.0.1 adds millis2time and decode_right_status"
	elog " 1.0.3 drops precooking logic and adds compiled headers for utf8 bytecodes and registries"
	elog ""
	elog "Thank you for using ${PN}"
}
