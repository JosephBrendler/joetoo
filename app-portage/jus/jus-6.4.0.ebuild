# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# joe brendler 6/8/2024
# re-write: move from src_uri to filesdir

EAPI=8

DESCRIPTION="A simple joetoo update sequence (jus)"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86 ~arm ~arm64"
KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE="distcc eix"
RESTRICT="mirror"

RDEPEND=">=sys-apps/portage-2.3.3
	>=app-portage/portage-utils-0.62
	>=app-portage/gentoolkit-0.3.2
	>=dev-util/script_header_brendlefly-0.2.11[extended]
	>=app-portage/eix-0.32.4
	eix? ( >=app-shells/push-2.0 )
	distcc? ( >=sys-devel/distcc-3.1 )"
# app-portage/show-elogs  --- I haven't packaged this yet
BDEPEND="${RDEPEND}"

src_install() {
	# Note: utility script header installs in /usr/local/sbin
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"
	einfo ""
	einfo "Copying ${PN}.conf to ${S} to edit if needed"
	cp -v ${FILESDIR}/${PN}.conf ${S}/

	if use distcc ; then
		elog "  (USE=\"distcc\") (set)"
		einfo "About to execute command sed -i 's/^DISTCC="no"/DISTCC="yes"/' ${S}/${PN}.conf"
		sed -i 's/^DISTCC="no"/DISTCC="yes"/' "${S}/${PN}.conf"
	else
		elog "  (USE=\"-distcc\") (unset)"
		einfo "About to execute command sed -i 's/^?DISTCC="yes"/DISTCC="no"/' ${S}/${PN}.conf"
		sed -i 's/^?DISTCC="yes"/DISTCC="no"/' "${S}/${PN}.conf"
	fi
	if use eix ; then
		elog "  (USE=\"eix\") (set)"
		einfo "About to execute command sed -i 's/^EIX="no"/EIX="yes"/' ${S}/${PN}.conf"
		sed -i 's/^EIX="no"/EIX="yes"/' "${S}/${PN}.conf"
	else
		elog "  (USE=\"-eix\") (unset)"
		einfo "About to execute command sed -i 's/^?EIX="yes"/EIX="no"/' ${S}/${PN}.conf"
		sed -i 's/^?EIX="yes"/EIX="no"/' "${S}/${PN}.conf"
	fi

	# install utilities jus and rus in /usr/bin; .conf file in /etc/
	dodir usr/bin/
	dodir /etc/${PN}/
	target="/usr/bin"
	# install jus in /usr/bin/
	einfo "Installing (exe) ${PN} into ${target} ..."
	exeinto "${target}"
	newexe "${FILESDIR}/${PN}" "${PN}"
	elog "Installed (exe) ${PN} in ${target}"

	# install rus in /usr/bin
	einfo "Installing (exe) ${PN/j/r} into ${target} ..."
	exeinto "${target}"
	newexe "${FILESDIR}/${PN/j/r}" "${PN/j/r}"
	elog "Installed (exe) ${PN/j/r} in ${target}"

	# install jus.conf in /etc/jus/
	target="/etc/jus/"
	insinto "${target}"
	newins "${S}/${PN}.conf" "${PN}.conf"
	elog "Installed (ins) ${PN}.conf in ${target}"
}

pkg_postinst() {
	elog ""
	elog "Completed installation of ${P}"
	elog ""
	elog "Version 6.0.1.9999 was the initial version of jus, adapted from gus-5.3.1.9999"
	elog "  6.0.3 -- now includes rebuild update sequnce companion script (rus)"
	elog "  6.1.0 -- reads PORTDIR, PKGDIR from make.conf; incl. golang-rebuild; bugfixes"
	elog "  6.1.2 -- fixes rus-status and recommends rebuild verification steps"
	elog "  6.2.0 -- adds pick_binutils() function and -s (get status) option"
	elog "  6.2.1 -- adds stop/start of pkg sync rsync & cron jobs (cloudsync)"
	elog "  6.2.4 -- adds bugfix and messaging in rus to clarify incremental status"
	elog "  6.2.5 -- makes jus rebuilds use non-binary FEATURES"
	elog "  6.2.6 -- uses --oneshot to avoid adding to @world set and option for j1 MAKEOPTS"
	elog '  6.3.0 -- adds compound argument processing and "resume" options for rus'
	elog "  6.3.1 -- adds show-config and distcc option for rus"
	elog "  6.3.2 -- rus follows gentoo replacement of sys-devel/libtool with dev-build/libtool"
	elog "  6.3.3 -- adds jus option to resume at arbitrary step, with (e.g.) -[r]3 or --resume -4"
	elog "  6.3.4 -- improves rus debug format and fixes verbosity increment bug"
	elog "  6.4.0 -- rewrite to move content from SRC_URI to FILESDIR"
	elog ""
	elog "Thank you for using ${PN}"

}
