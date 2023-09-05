# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# kernel builder program for embedded systems (tinkerboard s)

EAPI=8

DESCRIPTION="kernel builder program for embedded systems (tinkerboard s)"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~arm ~amd64 ~arm64"

IUSE="+tinker-s tinker2-s raspi3 raspi4b"

# tinker-s is default above, but "exactly one of" the options
REQUIRED_USE="
	^^ ( tinker-s tinker2-s raspi3 raspi4b )
	"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND="
	>=dev-util/joetoolkit-0.1.5
	>=joetoo-base/joetoo-meta-0.0.4b
"

DEPEND="${RDEPEND}"

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
	elog "Installing kernelupdate-tinker..."
	dodir "/usr/sbin/"
	for x in $(find ${FILESDIR}/ -maxdepth 1 -type f);
	do
		z=$(echo ${x} | sed "s|${FILESDIR}/||");
		einfo "About to execute command cp -v "${x}" "${D}"/usr/sbin/"${z}";"
		cp -v "${x}" "${D}/usr/sbin/${z}";
	done
	elog "done"

	dodir "/etc/kernelupdate-tinker/"
	# tinker-s (default)
	if use tinker-s;
	then
		elog "USE flag \"tinker-s\" selected ..."
		for x in $(find ${FILESDIR}/tinker-s/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${FILESDIR}/tinker-s/||");
			einfo "About to execute command cp -v "${x}" "${D}"/etc/kernelupdate-tinker/"${z}";"
			cp -v "${x}" "${D}/etc/kernelupdate-tinker/${z}";
		done
		elog "done"
	else
		elog "USE flag \"tinker-s\" not selected tinker-s configs not copied"
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
	elog "kernelupdate-tinker installed"
	elog ""
	elog "This software is still prliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using kernelupdate-tinker"
}
