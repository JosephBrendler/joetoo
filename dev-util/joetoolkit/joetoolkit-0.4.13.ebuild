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
	elog "Version 0.0.4 adds a vpn watch service for raspi4 (optional with iptools USE flag"
	elog " 0.0.5 adds/tweaks a nextcloud_upgrade utility"
	elog " 0.1.8 moved kernelupdate-tinker utility to a separate eponymous package"
	elog " 0.1.9 adds tool to remove bogus binary packages on \"Destination exists\""
	elog " up to 0.1.14 tweak tools and move some tools to/from other packages"
	elog " 0.2.0 improves the nextcloud_upgrade utility"
	elog " 0.3.0 introduces nuoromis infrastructure related code"
	elog " 0.3.1 adds server cert for tinker05"
	elog " 0.3.2 add to x_arg_nobinmergelist list of pkgs to add to package.env"
	elog " 0.3.3 updates geolocate utility (ipapi.co vs tools.keycdn.com)"
	elog " 0.3.4 updates the loggit utility"
	elog " 0.3.5 updates the ipset_countrycode_load, update_ipdeny tools and cronjobs"
	elog " 0.3.6 removes vpn/svc/temp tools now provided by headless-mata packages"
	elog " 0.3.7 adds alias mb='mount /boot' to bashrc_aliases_include_joe_brendler"
	elog " 0.3.8/9 add/update utilities"
	elog " 0.3.10 removed kernelupdate (temp kernelupdate-old)"
	elog " 0.4.0/1 adds git/nextcloud and archives some tools, aligns # w joetoo packages"
	elog " 0.4.2 updates gp (git push) tool"
	elog " 0.4.3 switches xdo... to lxterminal to adapt to plasma 6 (wayland) conversion of konsole"
	elog " 0.4.4 adds icmerge (ignore-collision merge)"
	elog " 0.4.5 archives old certs and installs Brendler_Consulting_LLC_Root_CA.crt"
	elog " 0.4.6 archives old cflags tools and introduces get_my_cflags3.sh"
	elog " 0.4.7 switches from root back to user execution, for plasma 6 (x11 session)"
	elog " 0.4.8 adds nextcloud_check_version tool and moves _current_version to _version"
	elog " 0.4.9/10 fix bug(s) in nextcloud_check_version tool"
	elog " 0.4.11 adds maybe_do_upgrade() function to nextcloud_check_version tool"
	elog " 0.4.12 fixes bug(s) in nextcloud_check_version tool"
	elog " 0.4.13 re-activates installU_inImageFile tool to deploy xen pv kernel/modules"
	elog ""
	elog "To Do:"
	elog "   install to /usr/bin or sbin vs /usr/local/sbin"
	elog ""
	elog "This software is still preliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using ${PN}"
}
