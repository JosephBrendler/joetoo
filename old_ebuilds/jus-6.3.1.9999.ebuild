# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of my first ebuild with dependencies ...

EAPI=7

DESCRIPTION="A simple joetoo update sequence (jus)"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/jus-${PV}.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86 ~arm"
KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE="distcc eix"
RESTRICT="mirror"

RDEPEND=">=sys-apps/portage-2.3.3
	>=app-portage/portage-utils-0.62
	>=app-portage/gentoolkit-0.3.2
	>=dev-util/script_header_brendlefly-0.2.11
	>=dev-util/script_header_brendlefly_extended-0.1.2
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
	if use distcc ; then
		elog "  (USE=\"distcc\") (set)"
		einfo "About to execute command sed -i 's/^DISTCC="no"/DISTCC="yes"/' ${S}/${PN}/${PN}.conf"
		sed -i 's/^DISTCC="no"/DISTCC="yes"/' "${S}"/"${PN}"/"${PN}".conf
	else
		elog "  (USE=\"-distcc\") (unset)"
		einfo "About to execute command sed -i 's/^?DISTCC="yes"/DISTCC="no"/' ${S}/${PN}/${PN}.conf"
		sed -i 's/^?DISTCC="yes"/DISTCC="no"/' "${S}"/"${PN}"/"${PN}".conf
	fi
	if use eix ; then
		elog "  (USE=\"eix\") (set)"
		einfo "About to execute command sed -i 's/^EIX="no"/EIX="yes"/' ${S}/${PN}/${PN}.conf"
		sed -i 's/^EIX="no"/EIX="yes"/' "${S}"/"${PN}"/"${PN}".conf
	else
		elog "  (USE=\"-eix\") (unset)"
		einfo "About to execute command sed -i 's/^?EIX="yes"/EIX="no"/' ${S}/${PN}/${PN}.conf"
		sed -i 's/^?EIX="yes"/EIX="no"/' "${S}"/"${PN}"/"${PN}".conf
	fi

	# install utility in /usr/bin; .conf file in /etc/ ... note: both files, which
	# are named after ${PN} are also archived for distribution in a directory named ${PN}
	dodir usr/bin/
	dodir /etc/${PN}/
	einfo "About to execute command cp -R "${S}/${PN}/${PN}" "${D}"/usr/bin/"
	cp -v "${S}/${PN}/${PN}" "${D}/usr/bin/" || die "Install failed!"
	elog "${PN} installed in /usr/bin/"
	einfo "About to execute command cp -R "${S}/${PN}/rus" "${D}"/usr/bin/"
	cp -v "${S}/${PN}/rus" "${D}/usr/bin/" || die "Install failed!"
	elog "rus installed in /usr/bin/"
	einfo "About to execute command cp -R "${S}/${PN}/${PN}.conf" "${D}"/etc/${PN}/"
	cp -v "${S}/${PN}/${PN}.conf" "${D}/etc/${PN}/" || die "Install failed!"
	elog "${PN}.conf installed in /etc/${PN}/"
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
	elog ""
	elog "Thank you for using jus"

}
