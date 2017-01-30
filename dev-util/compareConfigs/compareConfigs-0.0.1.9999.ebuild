# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the 9999 (bleeding edge) version ebuild for compareConfigs

EAPI=6

inherit eutils

DESCRIPTION="color side-by-side compare of all parameters in two kernel configuration files"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/compareConfigs-0.0.1.tbz2"

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"

#KEYWORDS="~amd64 ~x86 ~arm"
KEYWORDS=""
IUSE="scripts testdata"

RDEPEND="dev-util/Terminal
	scripts? ( dev-util/script_header_brendlefly[extended] )"
DEPEND="${RDEPEND}"

src_compile() {
	# infoke the package's Makefile to compile against the "all" target (listed first)
	elog 'About to issue command: emake DESTDIR="${D}"'
	emake DESTDIR="${D}"
}

src_install() {
	elog "S=${S}"
	elog "D=${D}"
	elog "P=${P}"
	elog "PN=${PN}"
	elog "PV=${PV}"
	elog "PVR=${PVR}"
	elog "RDEPEND=${RDEPEND}"
	elog "DEPEND=${DEPEND}"
	elog "KEYWORDS=${KEYWORDS}"
	elog "IUSE=${IUSE}"
	if use scripts ; then
		elog "  (USE=\"scripts\") (set)"
	else
		elog "  (USE=\"-scripts\") (unset)"
	fi
	if use testdata ; then
		elog "  (USE=\"testdata\") (set)"
	else
		elog "  (USE=\"-testdata\") (unset)"
	fi
	elog ""

	# install the shared object library in /usr/lib/
	dodir /usr/lib/ && elog "Created ${D}/usr/lib/ with dodir"
	dodir /usr/local/bin/ && elog "Created ${D}/usr/local/bin/ with dodir"
	dodir /usr/include/ && elog "Created ${D}/usr/include/ with dodir"
	# Instead of using emake DESTDIR="${D}" (which would cause sandbox errors because
	#   the Makefile's install target writes to the live filesystem) just copy the file(s)
	elog 'About to issue command: cp -R '${S}'/libKernelConfig.so '${D}'/usr/lib/'
	cp -v "${S}/libKernelConfig.so" "${D}/usr/lib/" || die "Install failed!"
	elog "The shared object file libKernelConfig.so has been installed in /usr/lib/"
	elog ""
	elog 'About to issue command: cp -R '${S}'/KernelConfig.h '${D}'/usr/include/'
	cp -v "${S}/KernelConfig.h" "${D}/usr/include/" || die "Install failed!"
	elog "KernelConfig.h has been installed in /usr/include/"
	elog ""
	elog 'About to issue command: cp -R '${S}'/compareConfigs '${D}'/usr/local/bin/'
	cp -v "${S}/compareConfigs" "${D}/usr/local/bin/" || die "Install failed!"
	elog "compareConfigs has been installed in /usr/local/bin/"
	elog ""
	elog "compareConfigs reads all of two config files and outputs colorized side-by-side comparison"
	elog "useage:   $ compareConfigs <path/to/config1> <path/to/config2>"
	elog "example:  $ compareConfigs /home/joe/.config-live-DVD /boot/config-4.4.39-gentoo"
	elog ""
	elog "Recommend you ensure \"/usr/local/bin\" is in your \$PATH"
	elog ""

	# conditionally install the test program in /usr/local/bin/
	if use testdata ; then
		elog 'About to issue command: cp -R '${S}'/kernelConfigLibTest '${D}'/usr/local/bin/'
		cp -v "${S}/kernelConfigLibTest" "${D}/usr/local/bin/" || die "Install failed!"
		elog 'About to issue command: cp -R '${S}'/testconfig1 '${D}'/usr/local/bin/'
		cp -v "${S}/testconfig1" "${D}/usr/local/bin/" || die "Install failed!"
		elog 'About to issue command: cp -R '${S}'/testconfig2 '${D}'/usr/local/bin/'
		cp -v "${S}/testconfig2" "${D}/usr/local/bin/" || die "Install failed!"
		elog "The test program kerlenConfigLibTest and associated simple input \"config\" files"
		elog "have been installed in /usr/local/bin/"
		elog ""
		elog "kernelConfigLibTest reads and dumps a single config file,"
		elog "thus testing the KernelConfig.so library"
		elog "useage:   $ kernelConfigLibTest <path/to/config1>"
		elog "example:  $ comparam /home/joe/.config-live-DVD"
		elog ""
	else
		ewarn "The test program kerlenConfigLibTest and associated simple input \"config\" files"
		ewarn "have not been installed because of -testdata USE flag"
		elog ""
	fi

	# conditionally install the "concept" scripts in /usr/local/bin/
	if use scripts ; then
		elog 'About to issue command: cp -R '${S}'/comparam.sh '${D}'/usr/local/bin/'
		cp -v "${S}/comparam.sh" "${D}/usr/local/bin/" || die "Install failed!"
		elog 'About to issue command: cp -R '${S}'/compare-configs.sh '${D}'/usr/local/bin/'
		cp -v "${S}/compare-configs.sh" "${D}/usr/local/bin/" || die "Install failed!"
		elog "The \"concept\" scripts comparm.sh and compare-configs.sh"
		elog "have been installed in /usr/local/bin/"
		elog ""
		elog "comparam.sh compares a single config setting in two config files"
		elog "useage:   $ comparam <path/to/config1> <path/to/config2> <parameter>"
		elog "example:  $ comparam /home/joe/.config-live-DVD /boot/config-4.4.39-gentoo iwlwifi"
		elog ""
		elog "compare-configs.sh compares all of two config files side-by-side, like compareConfigs binary, just slower"
		elog "useage:   $ compare-configs.sh <path/to/config1> <path/to/config2>"
		elog "example:  $ compare-configs.sh /home/joe/.config-live-DVD /boot/config-4.4.39-gentoo"
		elog ""
	else
		ewarn "The \"concept\" scripts comparm.sh and compare-configs.sh"
		ewarn "have not been installed because of -scripts USE flag"
		elog ""
	fi

	elog "Thank you for using compareConfigs and the KernelConfig library"
	elog ""
}
