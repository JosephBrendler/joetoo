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

IUSE="+rk3288-tinker-s rk3288-tinker raspi3 bcm2711-rpi-4-b"

# tinker-s is default above, but "at least one of" the options
REQUIRED_USE="
	|| ( rk3288-tinker-s rk3288-tinker raspi3 bcm2711-rpi-4-b )
	"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND="
	>=sys-devel/crossdev-20230321
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
	elog "Installing kernelupdate-embedded..."
	dodir "/usr/sbin/"
	for x in $(find ${FILESDIR}/ -maxdepth 1 -type f);
	do
		z=$(echo ${x} | sed "s|${FILESDIR}/||");
		einfo "About to execute command cp -v "${x}" "${D}"/usr/sbin/"${z}";"
		cp -v "${x}" "${D}/usr/sbin/${z}";
	done
	elog "done"

	dodir "/etc/kernelupdate-embedded/"
	# tinker-s (default)
	if use rk3288-tinker-s;
	then
		elog "USE flag \"rk3288-tinker-s\" selected ..."
		dodir "/etc/kernelupdate-embedded/rk3288-tinker-s/"
		for x in $(find ${FILESDIR}/rk3288-tinker-s/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${FILESDIR}/rk3288-tinker-s/||");
			einfo "About to execute command cp -v "${x}" "${D}"/etc/kernelupdate-embedded/"${z}";"
			cp -v "${x}" "${D}/etc/kernelupdate-embedded/${z}";
		done
		elog "done"
	else
		elog "USE flag \"rk3288-tinker-s\" not selected rk3288-tinker-s configs not copied"
	fi
	if use bcm2711-rpi-4-b;
	then
		elog "USE flag \"bcm2711-rpi-4-b\" selected ..."
		dodir "/etc/kernelupdate-embedded/bcm2711-rpi-4-b/"
		for x in $(find ${FILESDIR}/bcm2711-rpi-4-b/ -maxdepth 1 -type f);
		do
			z=$(echo ${x} | sed "s|${FILESDIR}/bcm2711-rpi-4-b/||");
			einfo "About to execute command cp -v "${x}" "${D}"/etc/kernelupdate-embedded/"${z}";"
			cp -v "${x}" "${D}/etc/kernelupdate-embedded/${z}";
		done
		elog "done"
	else
		elog "USE flag \"bcm2711-rpi-4-b\" not selected bcm2711-rpi-4-b configs not copied"
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
	elog "kernelupdate-embedded installed"
	elog ""
	elog "Version 0.0.5 incorporates kernelupdate-embedded.conf file(s) and generalizes for multiple models"
	elog "Version 0.0.6 enables use of multiple .conf files and provides examples for models"
	elog "  rk3288-tinker-s and bcm2711-rpi-4-b.  You can use/modify, and symlink the one"
	elog "  you want to kernelupdate-embedded.conf in /etc/kernelupdate-embedded/"
	elog ""
	elog "This software is still prliminary.  Please report bugs to the maintainer."
	elog ""
	elog "Thank you for using kernelupdate-embedded"
}
