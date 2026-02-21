# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# joetoolkit - my own linux utilities

EAPI=8

DESCRIPTION="Utilities for a joetoo system"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 arm arm64 ~amd64 ~x86 ~arm ~arm64"

IUSE="+iptools -xenvmfiles -backup_utilities -utility_archive"

RESTRICT="mirror"

REQUIRED_USE=""

S="${WORKDIR%/}/${PN}"

RDEPEND="
	dev-util/script_header_joetoo[extended,unicode]
	app-admin/eselect
	app-text/enscript
	app-text/ghostscript-gpl
	iptools? (
		>=net-analyzer/nmap-7.92
		>=net-dns/bind-tools-9.16
	)
	backup_utilities? (
		>=net-misc/rsync-3.2.4
	)
"

BDEPEND="${RDEPEND}
"

install_tool_category() {
	# install files from a category which is this level of the eponymous directory
	# -type f ensures subdirectories are handled as if a separate category (see server_certs, below)
	# use $2, if provided, to filter contents to install separately (e.g. insert_into_file, below)
	local tool_category="$1"
	local find_command=""
	local filter=""
	einfo "running install_tool_category ${tool_category}"
	if [ ! -z "$2" ] ; then
		filter="$2"
		find_command="find ${S}/${tool_category}/ -maxdepth 1 -mindepth 1 -type f | grep -Ev \"${filter}\""
	else
		find_command="find ${S}/${tool_category}/ -maxdepth 1 -mindepth 1 -type f"
	fi
	for x in $(eval "${find_command}"); do
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
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "T=${T}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"

	# basic set of utilities for joetoo - handle insert_into_file stuff separately
	elog "Installing joetoolkit ..."
	target="/usr/sbin/"
	dodir "${target}"
	tool_category="joetoolkit"
	filter="insert_into_file"
        install_tool_category "${tool_category}" "${filter}"
	elog "done"

	# to do: spin off insert_into_file as a separate package independent of joetoolkit
	# install insert_into_file tool and associated components
	target="/usr/sbin/"
	einfo "Installing (exe) insert_into_file into ${target}"
	exeinto "${target}"
	newexe "${S}/joetoolkit/insert_into_file" "insert_into_file" || die "failed to newexe insert_into_file"
	elog "insert_into_file installed into ${target}"

	# install BUILD, BPN, and config template *(for insert_into_file)*
	target="/etc/insert_into_file/"
	einfo "Installing (ins) BUILD, BPN, and config template into ${target}"
	insinto "${target}"
	echo "# DO NOT EDIT - created by ebuild for sourcing by script" > ${T}/BUILD
	echo "BUILD=${PV}" >> ${T}/BUILD
	newins "${T}/BUILD" "BUILD" || die "failed to newins BUILD"
	elog "BUILD installed into ${target}"
	echo "# DO NOT EDIT - created by ebuild for sourcing by script" > ${T}/BPN
	echo 'BPN=${PN}' >> ${T}/BPN
	newins "${T}/BPN" "BPN" || die "failed to newins BPN"
	elog "BPN installed into ${target}"
	newins "${S}/joetoolkit/insert_into_file_template.conf" "insert_into_file_template.conf" || \
		die "failed to newins insert_into_file_template.conf"
	elog "Installed insert_into_file_template.conf into ${target}"

	# install local.usage, .cmdline_arguments, .cmdline_compound_arguments *(for insert_into_file)*
	einfo "Installing (ins) local.usage, .cmdline_arguments, .cmdline_compound_arguments for insert_into_file"
	z="insert_into_file"
	for x in local.usage local.cmdline_arguments local.cmdline_compound_arguments ; do
		newins "${S}/joetoolkit/${z}_${x}" "${x}" || die "failed to newins ${x}"
		elog "${x} installed into ${target}"
	done
	# install eselect module *(for insert_into_file)*
	einfo "Installing (ins) the insert_into_file.conf eselect module into /usr/share/eselect/modules/ ..."
	target="/usr/share/eselect/modules/"
	insinto "${target}"
	z="insert_into_file.eselect"
	newins "${S}/joetoolkit/${z}" "${z}"
	elog "Installed insert_into_file.conf eselect module."

	# to do: spin off check_resilient_services as a separate package independent of joetoolkit
	# install /etc/${PN}/check_resilient_services/ with BUILD and BPN
	elog "Installing BUILD, BPN and local.usage placeholder into /etc/${PN}/check_resilient_services/ ..."
	dodir "/etc/${PN}/check_resilient_services/"
	echo "BUILD=${PV}" > ${D}/etc/${PN}/check_resilient_services/BUILD || die "failed to install BUILD"
	echo "BPN=${PN}/check_resilient_services" > ${D}/etc/${PN}/check_resilient_services/BPN || die "failed to install BPN"
	echo "Placeholder for potential local.usage, local.cmdline_arguments, etc" > ${D}/etc/${PN}/check_resilient_services/README_placeholder_for_local.usage || die "failed to install placeholder"
	elog "done installing BUILD, BPN and placeholder"

	# server certificates for joetoo servers
	elog "Installing (ins) server_certs ..."
#	target="/usr/share/${PN}/server_certs/"
	target="/usr/share/${PN}/"
	insinto "${target}"
	doins -r "${S}/joetoolkit/server_certs"
	elog "server_certs installed into ${target}"

	# ip tools
	if use iptools;
	then
		target="/usr/sbin/"
		tool_category="iptools"
		elog "USE flag \"${tool_category}\" selected ..."
		dodir "${target}"
		install_tool_category "${tool_category}"
	else
		elog "USE flag \"iptools\" not selected iptools/ not copied"
	fi

	# xenvmfiles
	if use xenvmfiles ; then
		target="/usr/sbin/"
		tool_category="xenvmfiles"
		elog "USE flag \"${tool_category}\" selected ..."
		dodir "${target}"
		install_tool_category "${tool_category}_joetoo"
	else
		elog "USE flag \"xenvmtools\" not selected; xenvmfiles_joetoo/ not copied"
	fi

	# backup_utilities
	if use backup_utilities ; then
		target="/usr/sbin/"
		tool_category="backup_utilities"
		elog "USE flag \"${tool_category}\" selected ..."
		dodir "${target}"
		install_tool_category "${tool_category}"
	else
		elog "USE flag \"xenvmtools\" not selected; xenvmfiles_joetoo/ not copied"
	fi

	# utility_archive
	if use utility_archive ; then
		elog "USE flag \"utility_archive\" selected ..."
		target="/usr/share/${PN}/"
		insinto "${target}"
		x="utility_archive.tbz2"
		newins "${S}/${x}" "${x}";
		elog "${x} installed into ${target}"
	else
		elog "USE flag \"utility_archive\" not selected; utility_archive/ not copied"
	fi
}

pkg_postinst() {
	elog "S=${S}"
	elog "D=${D}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog "FILESDIR=${FILESDIR}"
	elog ""
	elog "${P} installed"
	elog "Version history can be found in the ebuild's files directory"
	elog " 0.6.11 adds nextcloud_ tools enabling federated shares"
	elog " 0.6.12 adds nextcloud_list_configs"
	elog " 0.6.13 adds tools to collect distcc server farm data"
	elog " -r1 fixes install location for server ca certs"
	elog " 0.6.14 adds screen alias to force utf8 support"
	elog " 0.6.15/16 update tarup and add ebuild update (ebup) command"
	elog " 0.6.17 adds alias cv as upd to strip_blank_lines_and_comments.sh"
	elog " 0.7.0 uses install_tool_category() to properly install executables"
	elog " 0.7.1 adds joetoolkit/iptools/openvpn_dns_updater.sh"
	elog " 0.7.2 changes a , to a . in a filename"
	elog " 0.7.3 updates unlock-drives; adds unlock-drives-minimal"
	elog " 0.7.4-7 bugfix sort unique/order with key/LC_COLLATE in openvpn_dns_updater.sh"
	elog " 0.7.8 adds 99-ula-ndp-fix.start and restart-network utilities"
	elog " 0.7.9-11 updates openvpn_dns_updater.sh"
	elog " 0.7.12/13 add connectivity_check.sh"
	elog " 0.7.14 changes hostname to fqdn for ipv6 in openvpn_dns_updater.sh"
	elog " 0.7.14/15 adds 0+ whitespace before # comment stripping for alias cv"
	elog " 0.7.16-22 add/update utilities"
	elog " 0.7.23 removes old certs; updates bashrc_aliases"
	elog " 0.7.24-30 add/update utilities"
	elog ""
	if use utility_archive ; then
		elog "USE flag \"utility_archive\" selected ..."
		elog "utility_archive.tbz2 has been installed at /usr/share/${PN}/"
		elog "un-tar with e.g. # tar -xvjpf /usr/share/${PN}/utility_archive.tbz2 --directory=/home/joe/scratchpad/"
		elog "to explore the associated ancient (all deprecated) scripts"
	fi
	elog "This software is still evolving.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
