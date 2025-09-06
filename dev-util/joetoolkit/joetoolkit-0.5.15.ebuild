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

BDEPEND="
"

RDEPEND="
	${BDEPEND}
	iptools? (
		>=net-analyzer/nmap-7.92
		>=net-dns/bind-tools-9.16
	)
	backup_utilities? (
		>=net-misc/rsync-3.2.4
	)
"
# To Do: add to above different choices

src_install() {
	# install utilities into /usr/local/sbin (for now)

	einfo "S=${S}"
	einfo "D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"

	# basic set of utilities for joetoo
	elog "Installing joetoolkit..."
	dodir "/usr/sbin/"
	for x in $(find ${S}/joetoolkit/ -maxdepth 1 -type f);
	do
		z=$(echo ${x} | sed "s|${S}/joetoolkit/||");
		einfo "About to execute command cp -v "${x}" "${D}"/usr/sbin/"${z}";"
		cp -v "${x}" "${D}/usr/sbin/${z}";
	done
	elog "done"

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
	elog " 0.5.0-2 move to myUtilities, script_header_joetoo, /usr/share, /usr/sbin"
	elog " 0.5.3 removes xdotool_open_windows to its own package"
	elog " 0.5.4 adds joetoo-sbc-list script and completes repo migration"
	elog " 0.5.5 vice grep ^PORTDIR now source make.conf which may e.g. =\${ROOT}var/db/..."
	elog " 0.5.6 updates the joetoo-sbc-list script"
	elog " 0.5.7 provides a new (replacement) binhost_cleanup script"
	elog " 0.5.8/9 updates the joetoo-sbc-list script w model description"
	elog " 0.5.10 fixes tarup for case of no prior matching tarballs"
	elog " 0.5.11 updates bashrc_aliases_include_joe_brendler"
	elog " 0.5.12 adds rk3588-radxa-rock-5b+ and rk3588s-orangepi-5b"
	elog " 0.5.13 adds gcsm and gpom aliases to ${PN}"
	elog " 0.5.14 updates alias gcsm to cache passphrase"
	elog " 0.5.15 updates joetoo-sbc-list for rock5b+ and tinker boards"
	elog " "
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
