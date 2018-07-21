# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the next version of my first ebuild with dependencies ...

EAPI=6

DESCRIPTION="A simple gentoo update sequence (gus)"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/gus-1.0.4.9999.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~x86 ~arm"
KEYWORDS=""

# automatically also pull in dev-util/script-header-brendlefly-extended
IUSE="distcc eix"

RDEPEND=">=sys-apps/portage-2.3.3
	>=app-portage/portage-utils-0.62
	>=app-portage/gentoolkit-0.3.2
	>=dev-util/script_header_brendlefly-0.2.11
	>=dev-util/script_header_brendlefly_extended-0.1.2
	>=app-portage/eix-0.32.4
	eix? ( >=app-shells/push-2.0 )
	distcc? ( >=sys-devel/distcc-3.1 )"
# app-portage/show-elogs  --- I haven't packaged this yet
DEPEND="${RDEPEND}"

src_install() {
	# install utility script header in /usr/local/sbin
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
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

	# install utility in /usr/local/bin; .conf file in /etc/ ... note: both files, which
	# are named after ${PN} are also archived for distribution in a directory named ${PN}
	dodir usr/local/bin/
	dodir /etc/${PN}/
	einfo "About to execute command cp -R "${S}/${PN}/${PN}" "${D}"usr/local/bin/"
	cp -v "${S}/${PN}/${PN}" "${D}usr/local/bin/" || die "Install failed!"
	elog "${PN} installed in /usr/local/bin/"
	einfo "About to execute command cp -R "${S}/${PN}/${PN}.conf" "${D}"etc/${PN}/"
	cp -v "${S}/${PN}/${PN}.conf" "${D}etc/${PN}/" || die "Install failed!"
	elog "${PN}.conf installed in /etc/${PN}/"
	## Note: I don't think there's a function like do/newconfd available to help with this...
	if use distcc ; then
		einfo "About to execute command cp -R "${S}/${PN}/distcc_unfriendly" "${D}"ect/${PN}/"
		cp -v "${S}/${PN}/distcc_unfriendly" "${D}etc/${PN}/" || die "Install failed!"
		elog ""
		elog "As of version 1.0.0 you can use option -c | --check to produce a list"
		elog "of updateable installed packages and of those which are in the world set."
		elog "(if using distcc, this is split into those friendly/unfriendly to distcc)"
		elog "if needed or requested w/ -y | --sync, the portage tree will be sync'd first"
		elog ""
		elog "To prepare for distcc-3.3, gus-1.0.1+ switches from 'pump emerge ...' to "
		elog "\"\"FEATURES=${FEATURES} distcc distcc-pump\" emerge ...\""
		elog ""
		elog "Version 1.0.4 added dependency on >=script_header_brendlefly_extended-0.1.2"
		elog "because the binary search function bs() moved there"
		elog ""
	fi
	elog ""
	elog "Thank you for using gus"

}
