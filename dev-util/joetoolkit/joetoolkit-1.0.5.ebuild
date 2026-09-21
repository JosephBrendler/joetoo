# Copyright 2024-2026 Joseph Brendler
# Distributed under the terms of the GNU General Public License v2
#
# joetoolkit - my own linux utilities

EAPI=8
inherit joetoo_license

DESCRIPTION="Utilities for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/joetoo-upstream/master/${CATEGORY}/${PN}-${PV}.tbz2"

S="${WORKDIR%/}/${PN}"

LICENSE="GPL-3+"

SLOT="0"

# see runtime dependency limitations below. the only "legal" way to keyword this is amd64 or ~amd64 only
# to install on other arch, use ** in package.accept_keywords
#KEYWORDS="~amd64 ~arm ~arm64 ~x86"
KEYWORDS="~amd64"

# note: in EAPI 8 these are off by default and do not need - prefix to set default = off
IUSE="+iptools devtools converters router"

RESTRICT="mirror"

REQUIRED_USE="
	router? ( iptools )
"

RDEPEND="
	dev-util/script_header_joetoo[extended]
	app-admin/eselect
	iptools? (
		>=net-analyzer/fping-5.4
		>=net-analyzer/nmap-7.92
		>=net-dns/bind-9.18
		>=net-misc/ipcalc-ng-1.0.3
		>=net-misc/ndisc6-1.0.8
		>=net-misc/socat-1.8.1.1
	)
	devtools? (
		>=app-misc/jq-1.8.2
		>=dev-util/shellcheck-0.11.0
		>=net-misc/curl-8.21.0-r1
	)
	converters? (
		>=app-text/enscript-1.6.6-r2
		app-text/ghostscript-gpl
		dev-python/ansi2html
		>=dev-python/weasyprint-69.0
	)
"
# note: runtime dependencies for text2pdf: (enscript(*), ghostscript-gpl)
# note: runtime dependencies for uat2pdf: (ansi2html, weasyprint(**))
# (*) not keyworkded for ~arm ; (**) not keyworded for ~arm or ~arm64
# $ for pkg in "${pkgs[@]}"; do echo; echo $pkg; echo $(repeat '-' ${#pkg}); equery meta -k $pkg; done
# * app-text/enscript [gentoo] 1.6.6-r2:0: amd64 x86 ~arm64 (*)
# * app-text/ghostscript-gpl [gentoo] 10.06.0-r2:0/10.06: amd64 arm arm64 x86
# * dev-python/ansi2html [gentoo] 1.9.4:0: amd64 arm arm64 x86 /// 1.9.5:0: ~amd64 ~arm ~arm64 ~x86
# * dev-python/weasyprint [gentoo] 69.0:0: amd64 /// 70.0:0: ~amd64 ~x86 (**)

BDEPEND="
	${RDEPEND}
"

install_tool_category() {
	# install files from a category which is this level of the eponymous directory
	# -type f ensures subdirectories are handled as if a separate category (see server_certs, below)
	# use $2, if provided, to filter contents to install separately (e.g. insert_into_file, below)
	local tool_category="$1"
	local find_command=""
	local filter=""
	einfo "running install_tool_category ${tool_category}"
	find_args=( "${S}/${tool_category}/" -maxdepth 1 -mindepth 1 -type f )
	# set up filter if provided, else just use cat for pass-through
	if [ ! -z "$2" ] ; then
		grep_cmd=( grep -Ev \""$2"\" )
	else
		grep_cmd=( cat )
	fi
	for x in $( find "${find_args[@]}" | "${grep_cmd[@]}" ); do
		z=$(echo ${x} | sed "s|${S}/${tool_category}/||");
		if [[ -x ${x} ]] ; then
			einfo "Installing (exe) ${z} into ${target}"
			exeinto "${target}"
			newexe "${x}" "${z}" || die "failed to install (exe) $z"
			elog "Installed (exe) ${z} in ${target}"
		else
			einfo "Installing (ins) ${z} into ${target}"
			insinto "${target}" || die "failed to install (ins) $z"
			newins "${x}" "${z}"
			elog "Installed (ins) ${z} in ${target}"
		fi
	done
	elog "done install_tool_category ${tool_category}"
}

src_install() {
	elog "WORKDIR=${WORKDIR}"
	elog "S=${S}"
	elog "D=${D}"
	elog "T=${T}"
	elog "CATEGORY=${CATEGORY}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog "FILESDIR=${FILESDIR}"
	elog ""

	# basic set of utilities for joetoo - handle insert_into_file stuff separately
	elog "Installing joetoolkit ..."
	target="/usr/sbin/"
	dodir "${target}"
	tool_category="joetoolkit"
	filter="insert_into_file"
	install_tool_category "${tool_category}" "${filter}"
	elog "done"

	# install additional tool categories
	# IUSE="+iptools -devtools -converters -router"
	target="/usr/sbin/"
	for tool_category in iptools devtools converters router; do
		if use "${tool_category}"; then
			elog "USE flag \"${tool_category}\" selected ..."
			dodir "${target}"
			install_tool_category "${tool_category}"
		else
			elog "USE flag \"${tool_category}\" not selected ${tool_category}/ not copied"
		fi
	done

	# install BUILD and BPN files for the joetoolkit itself
	target="/etc/${PN}/"
	einfo "Installing (ins) BUILD, BPN, and config template into ${target}"
	insinto "${target}"
	echo "# DO NOT EDIT - created by ebuild for sourcing by script" > "${T}/BUILD"
	echo "BUILD=${PV}" >> "${T}/BUILD"
	newins "${T}/BUILD" "BUILD" || die "failed to newins BUILD"
	elog "BUILD installed into ${target}"
	echo "# DO NOT EDIT - created by ebuild for sourcing by script" > "${T}/BPN"
	echo 'BPN=${PN}' >> "${T}/BPN"
	newins "${T}/BPN" "BPN" || die "failed to newins BPN"
	elog "BPN installed into ${target}"

	# to do: spin off some of these below as separate packages independent of joetoolkit

	# install insert_into_file tool and associated components
	target="/usr/sbin/"
	einfo "Installing (exe) insert_into_file into ${target}"
	exeinto "${target}"
	newexe "${S}/devtools/insert_into_file" "insert_into_file" || die "failed to newexe insert_into_file"
	elog "insert_into_file installed into ${target}"

	# install BUILD, BPN, and config template *(for insert_into_file)*
	target="/etc/insert_into_file/"
	einfo "Installing (ins) BUILD, BPN, and config template into ${target}"
	insinto "${target}"
	echo "# DO NOT EDIT - created by ebuild for sourcing by script" > "${T}/BUILD"
	echo "BUILD=${PV}" >> "${T}/BUILD"
	newins "${T}/BUILD" "BUILD" || die "failed to newins BUILD"
	elog "BUILD installed into ${target}"
	echo "# DO NOT EDIT - created by ebuild for sourcing by script" > "${T}/BPN"
	echo 'BPN=${PN}' >> "${T}/BPN"
	newins "${T}/BPN" "BPN" || die "failed to newins BPN"
	elog "BPN installed into ${target}"
	x="insert_into_file_template.conf"
	newins "${S}/devtools/${x}" "${x}" || die "failed to newins ${x}"
	elog "Installed ${x} into ${target}"

	# install /etc/insert_into_file/insert_into_file_local.cmdline_arg_handler
	einfo "Installing (ins) /etc/insert_into_file/insert_into_file_local.cmdline_arg_handler"
	x="insert_into_file_local.cmdline_arg_handler"
	newins "${S}/devtools/${x}" "${x}" || die "failed to newins ${x}"
	elog "Installed ${x} into ${target}"
	# install eselect module *(for insert_into_file)*
	einfo "Installing (ins) the insert_into_file.conf eselect module into /usr/share/eselect/modules/ ..."
	target="/usr/share/eselect/modules/"
	insinto "${target}"
	x="insert_into_file.eselect"
	newins "${S}/devtools/${x}" "${x}" || die "failed to newins ${x}"
	elog "Installed ${x} into ${target}"

	# install /etc/nextcloud_check_version with BUILD and BPN (executable got installed as a normal utility)
	elog "Installing BUILD, BPN and local.usage placeholder into /etc/nextcloud_check_version/ ..."
	dodir "/etc/nextcloud_check_version/"
	echo "BUILD=${PV}" > "${D}/etc/nextcloud_check_version/BUILD" || \
		die "failed to install BUILD"
	echo "BPN=${PN}/check_resilient_services" > "${D}/etc/nextcloud_check_version/BPN" || \
		die "failed to install BPN"
	elog "done installing BUILD, BPN for nextcloud_check_version"

	# install /etc/${PN}/check_resilient_services/ with BUILD and BPN (executable got installed as a normal utility)
	elog "Installing BUILD, BPN and local.usage placeholder into /etc/${PN}/check_resilient_services/ ..."
	dodir "/etc/${PN}/check_resilient_services/"
	echo "BUILD=${PV}" > "${D}/etc/${PN}/check_resilient_services/BUILD" || \
		die "failed to install BUILD"
	echo "BPN=${PN}/check_resilient_services" > "${D}/etc/${PN}/check_resilient_services/BPN" || \
		die "failed to install BPN"
	echo "Placeholder for potential local.usage, local.cmdline_arguments, etc" > \
		"${D}/etc/${PN}/check_resilient_services/README_placeholder_for_local.usage" || \
		die "failed to install placeholder"
	elog "done installing BUILD, BPN and placeholder"

	# server certificates for joetoo servers
	elog "Installing (ins) server_certs ..."
	target="/usr/share/${PN}/"
	insinto "${target}"
	doins -r "${S}/joetoolkit/server_certs"
	elog "server_certs installed into ${target}"

	# run eclass joetoo_license code
	joetoo_license_src_install
}

pkg_postinst() {
	elog "${P} installed"
	elog "Version history can be found in the ebuild's files directory"
	elog " 1.0.0 was the first licensed version of ${PN}"
	elog " 1.0.1-5 provide bugfixes and enhancements"
	elog ""
	elog "This software is still evolving.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
