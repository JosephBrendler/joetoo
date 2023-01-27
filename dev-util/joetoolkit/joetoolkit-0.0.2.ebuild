# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# joetoolkit - my own linux utilities

EAPI=8

DESCRIPTION="Utilities for a joetoo system"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~arm64"

IUSE="+iptools -xenvmfiles -backup_utilities -utility_archive"

# I will have to come back to this - I'm sure there are dependencies to
# note; for now, use joetoo
REQUIRED_USE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=">=joetoo-base/joetoo-meta-0.0.4b
"

RDEPEND="
	${DEPEND}
	iptools? (
		>=net-analyzer/nmap-7.93
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
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"

	# basic set of utilities for joetoo
	elog "Installing joetoolkit..."
	dodir "/usr/local/sbin/"
	for x in $(find ${FILESDIR}/joetoolkit/ -maxdepth 1 -type f);
	do
		z=$(echo ${x} | sed "s|${FILESDIR}/joetoolkit/||");
		einfo "About to execute command cp -v "${x}" "${D}"/usr/local/sbin/"${z}";"
		cp -v "${x}" "${D}/usr/local/sbin/${z}";
	done
	elog "done"

	# server certificates for joetoo servers
	elog "Installing server_certs ..."
	dodir "/usr/local/sbin/server_certs"
	for x in $(find ${FILESDIR}/joetoolkit/server_certs/ -maxdepth 1 -type f);
	do
		z=$(echo ${x} | sed "s|${FILESDIR}/joetoolkit/server_certs/||");
		einfo "About to execute command cp -v "${x}" "${D}"/usr/local/sbin/server_certs/"${z}";"
		cp -v "${x}" "${D}/usr/local/sbin/server_certs/${z}";
	done
	elog "done"

	# ip tools
	if use iptools;
	then
		elog "USE flag \"iptools\" selected ..."
		for x in $(find ${FILESDIR}/iptools/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${FILESDIR}/iptools/||");
			einfo "About to execute command cp -v "${x}" "${D}"/usr/local/sbin/"${z}";"
			cp -v "${x}" "${D}/usr/local/sbin/${z}";
		done
		elog "done"
	else
		elog "USE flag \"iptools\" not selected iptools/ not copied"
	fi

	# xenvmfiles
	if use xenvmfiles ; then
		elog "USE flag \"xenvmtools\" selected ..."
		for x in $(find ${FILESDIR}/xenvmfiles_joetoo/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${FILESDIR}/xenvmfiles_joetoo/||");
			einfo "About to execute command cp -v "${x}" "${D}"/usr/local/sbin/"${z}";"
			cp -v "${x}" "${D}/usr/local/sbin/${z}";
		elog "done"
		done
	else
		elog "USE flag \"xenvmtools\" not selected; xenvmfiles_joetoo/ not copied"
	fi

	# backup_utilities
	if use backup_utilities ; then
		elog "USE flag \"backup_utilities\" selected ..."
		for x in $(find ${FILESDIR}/backup_utilities/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${FILESDIR}/backup_utilities/||");
			einfo "About to execute command cp -v "${x}" "${D}"/usr/local/sbin/"${z}";"
			cp -v "${x}" "${D}/usr/local/sbin/${z}";
		done
		elog "done"
	else
		elog "USE flag \"backup_utilities\" not selected; backup_utilities/ not copied"
	fi

	# utility_archive
	if use utility_archive ; then
		elog "USE flag \"utility_archive\" selected ..."
		for x in $(find ${FILESDIR}/utility_archive/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${FILESDIR}/utility_archive/||");
			einfo "About to execute command cp -v "${x}" "${D}"/usr/local/sbin/"${z}";"
			cp -v "${x}" "${D}/usr/local/sbin/${z}";
		done
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
	elog "RDEPEND=${RDEPEND}"
	elog "DEPEND=${DEPEND}"
	elog ""
	elog "joetoolkit installed"
	elog "This version is preliminary. Please report bugs to the maintainer."
	elog ""
	elog ""
	elog "Thank you for using joetoolkit"
}
