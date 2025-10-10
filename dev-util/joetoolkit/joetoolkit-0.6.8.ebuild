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

# I will have to come back to this - I'm sure there are dependencies to
# note; for now, use joetoo
REQUIRED_USE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR%/}/${PN}"

RDEPEND="
	dev-util/script_header_joetoo[extended]
	app-admin/eselect
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

src_install() {
	# install utilities into /usr/local/sbin (for now)

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
	dodir "/usr/sbin/"
	for x in $(find ${S}/joetoolkit/ -maxdepth 1 -type f | grep -v insert_into_file);
	do
		z=$(echo ${x} | sed "s|${S}/joetoolkit/||");
		einfo "Installing (cp) ${z} into /usr/sbin/"
		cp "${x}" "${D}/usr/sbin/${z}" || die "install (copy) failed"
	done
	elog "done"

	# install insert_into_file tool and associated components
	target="/usr/sbin/"
	einfo "Installing (exe) insert_into_file into ${target}"
	exeinto "${target}"
	newexe "${S}/joetoolkit/insert_into_file" "insert_into_file" || die "failed to newexe insert_into_file"
	elog "Installed insert_into_file into ${target}"
	# install BUILD, BPN, and config template for insert_into_file
	target="/etc/insert_into_file/"
	einfo "Installing (ins) BUILD, BPN, and config template into ${target}"
	insinto "${target}"
	echo "# DO NOT EDIT - created by ebuild for sourcing by script" > ${T}/BUILD
	echo "BUILD=${PV}" >> ${T}/BUILD
	newins "${T}/BUILD" "BUILD" || die "failed to newins BUILD"
	elog "Installed BUILD into ${target}"
	echo "# DO NOT EDIT - created by ebuild for sourcing by script" > ${T}/BPN
	echo 'BPN=${PN}' >> ${T}/BPN
	newins "${T}/BPN" "BPN" || die "failed to newins BPN"
	elog "Installed BPN into ${target}"
	newins "${S}/joetoolkit/insert_into_file_template.conf" "insert_into_file_template.conf" || \
		die "failed to newins insert_into_file_template.conf"
	elog "Installed insert_into_file_template.conf into ${target}"
	# install local.usage, .cmdline_arguments, .cmdline_compound_arguments for insert_into_file
	einfo "Installing (ins) local.usage, .cmdline_arguments, .cmdline_compound_arguments for insert_into_file"
	z="insert_into_file"
	for x in local.usage local.cmdline_arguments local.cmdline_compound_arguments ; do
		newins "${S}/joetoolkit/${z}_${x}" "${x}" || die "failed to newins ${x}"
		elog "Installed ${x} into ${target}"
	done
	# install eselect module for insert_into_file
	einfo "Installing (ins) the insert_into_file.conf eselect module into /usr/share/eselect/modules/ ..."
	target="/usr/share/eselect/modules/"
	insinto "${target}"
	z="insert_into_file.eselect"
	newins "${S}/joetoolkit/${z}" "${z}"
	elog "Installed insert_into_file.conf eselect module."

	# install /etc/${PN}/check_resilient_services/ with BUILD and BPN
	elog "Installing BUILD, BPN and local.usage placeholder into /etc/${PN}/check_resilient_services/ ..."
	dodir "/etc/${PN}/check_resilient_services/"
	echo "BUILD=${PV}" > ${D}/etc/${PN}/check_resilient_services/BUILD || die "failed to install BUILD"
	echo "BPN=${PN}/check_resilient_services" > ${D}/etc/${PN}/check_resilient_services/BPN || die "failed to install BPN"
	echo "Placeholder for potential local.usage, local.cmdline_arguments, etc" > ${D}/etc/${PN}/check_resilient_services/README_placeholder_for_local.usage || die "failed to install placeholder"
	elog "done installing BUILD, BPN and placeholder"

	# server certificates for joetoo servers
	elog "Installing server_certs ..."
	dodir "/usr/share/${PN}/server_certs"
	for x in $(find ${S}/joetoolkit/server_certs/ -maxdepth 1 -type f);
	do
		z=$(echo ${x} | sed "s|${S}/joetoolkit/server_certs/||");
		einfo "About to execute command cp -v "${x}" "${D}"/usr/share/${PN}/server_certs/"${z}";"
		cp -v "${x}" "${D}/usr/share/${PN}/server_certs/${z}";
	done
	elog "done"

	# ip tools
	if use iptools;
	then
		elog "USE flag \"iptools\" selected ..."
		for x in $(find ${S}/iptools/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${S}/iptools/||");
			einfo "About to execute command cp -v "${x}" "${D}"/usr/sbin/"${z}";"
			cp -v "${x}" "${D}/usr/sbin/${z}";
		done
		elog "done"
	else
		elog "USE flag \"iptools\" not selected iptools/ not copied"
	fi

	# xenvmfiles
	if use xenvmfiles ; then
		elog "USE flag \"xenvmtools\" selected ..."
		for x in $(find ${S}/xenvmfiles_joetoo/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${S}/xenvmfiles_joetoo/||");
			einfo "About to execute command cp -v "${x}" "${D}"/usr/sbin/"${z}";"
			cp -v "${x}" "${D}/usr/sbin/${z}";
		elog "done"
		done
	else
		elog "USE flag \"xenvmtools\" not selected; xenvmfiles_joetoo/ not copied"
	fi

	# backup_utilities
	if use backup_utilities ; then
		elog "USE flag \"backup_utilities\" selected ..."
		for x in $(find ${S}/backup_utilities/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${S}/backup_utilities/||");
			einfo "About to execute command cp -v "${x}" "${D}"/usr/sbin/"${z}";"
			cp -v "${x}" "${D}/usr/sbin/${z}";
		done
		elog "done"
	else
		elog "USE flag \"backup_utilities\" not selected; backup_utilities/ not copied"
	fi

	# utility_archive
	if use utility_archive ; then
		elog "USE flag \"utility_archive\" selected ..."
		dodir "/usr/share/${PN}"
		einfo "About to execute command cp -v ${S}/utility_archive.tbz2 ${D}/usr/share/${PN}/;"
		cp -v "${S}/utility_archive.tbz2" "${D}/usr/share/${PN}/";
		elog "done"
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
	elog " 0.5.20 adds support for rk3399-rock-4se"
	elog " 0.6.0 updates insert_into_file with cli, usage, eselect, etc"
	elog " 0.6.1-3 provide refinements and bugfixes"
	elog " 0.6.4 adds move_joetoo_kernels_to_webserver for use as cron job"
	elog " 0.6.5 adds new_get_openVPN_client_info_for_dns.sh, more_archive"
	elog " 0.6.6 mods move_joetoo_kernels to wait for inbound transfer"
	elog " 0.6.7 adds move_joetoo_sources_to_webserver for use as cron job"
	elog " 0.6.8 removes reference to deprecated raspberrypi-userland"
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
