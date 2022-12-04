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

RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=">=joetoo-base/joetoo-meta-0.0.4b
"

RDEPEND="
	${DEPEND}
	iptools? (
		>=net-analyzer/nmap-7.93
	)
	xenvmfiles? (
		>=app-emulation/xen-4.15
		>=app-emulation/xen-tools-4.15
	)
	backup_utilities? (
		>=net-misc/rsync-3.2.4
	)
"
# To Do: add to above different choices

src_install() {
	# install utilities into /usr/local/sbin (for now)
	dodir "/usr/local/sbin/"

        # basic set of utilities for joetoo
        einfo "About to execute command cp -R "${S}"/files/joetoolkit/*" "${D}"usr/local/sbin/"
        cp -v "${S}/files/joetoolkit/*" "${D}usr/local/sbin/" || die "Install failed!"
        elog "${PN} installed in /usr/local/sbin."
        elog ""

	# ip tools
	if use iptools ; then
        einfo "About to execute command cp -R "${S}"/files/iptools/*" "${D}"usr/local/sbin/"
        cp -v "${S}/files/iptools/*" "${D}usr/local/sbin/" || die "Install failed!"
        elog "${PN} iptools installed in /usr/local/sbin."
        elog ""

	else
		einfo "USE=iptools not selected"
		elog "USE=iptools not selected"
	fi

       # xenvmfiles
        if use xenvmfiles ; then

        else

        fi

       # backup_utilities
        if use backup_utilities ; then

        else

        fi

       # utility_archive
        if use utility_archive ; then

        else

        fi
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	elog ""
	elog "joetoolkit installed"
	elog "This version is preliminary. Please report bugs to the maintainer."
	elog ""
	elog ""
	elog "Thank you for using joetoolkit"
}
