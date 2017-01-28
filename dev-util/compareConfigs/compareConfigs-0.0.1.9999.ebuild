# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# This is the 9999 (bleeding edge) version ebuild for compareConfigs

EAPI=6

inherit eutils

DESCRIPTION="c++ shared obj lib for ANSI & UNICODE terminal control, w/ optional examples"
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
	einfo 'About to issue command: emake DESTDIR="${D}"'
	emake DESTDIR="${D}"
}

src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	einfo "KEYWORDS=${KEYWORDS}"
	einfo "IUSE=${IUSE}"
	if use scripts ; then
		einfo "  (USE=\"scripts\") (set)"
	else
		einfo "  (USE=\"-scripts\") (unset)"
	fi
	if use testdata ; then
		einfo "  (USE=\"testdata\") (set)"
	else
		einfo "  (USE=\"-testdata\") (unset)"
	fi

	# install the shared object library in /usr/lib/
	dodir /usr/lib/ && einfo "Created ${D}/usr/lib/ with dodir"
	dodir /usr/local/bin/ && einfo "Created ${D}/usr/local/bin/ with dodir"
	dodir /usr/include/ && einfo "Created ${D}/usr/include/ with dodir"
	# Instead of using emake DESTDIR="${D}" (which would cause sandbox errors because
	#   the Makefile's install target writes to the live filesystem) just copy the file(s)
	einfo 'About to issue command: cp -R '${S}'/libKernelConfig.so '${D}'/usr/lib/'
	cp -v "${S}/libKernelConfig.so" "${D}/usr/lib/" || die "Install failed!"
	einfo "The shared object file libKernelConfig.so has been installed in /usr/lib/"
	einfo 'About to issue command: cp -R '${S}'/KernelConfig.h '${D}'/usr/include/'
	cp -v "${S}/KernelConfig.h" "${D}/usr/include/" || die "Install failed!"
	einfo "KernelConfig.h has been installed in /usr/include/"
	einfo 'About to issue command: cp -R '${S}'/compareConfigs '${D}'/usr/local/bin/'
	cp -v "${S}/compareConfigs" "${D}/usr/local/bin/" || die "Install failed!"
	einfo "compareConfigs has been installed in /usr/local/bin/"
	einfo ""
	einfo "compareConfigs reads all of two config files and outputs colorized side-by-side comparison"
	einfo "useage:   $ compareConfigs <path/to/config1> <path/to/config2>"
	einfo "example:  $ compareConfigs /home/joe/.config-live-DVD /boot/config-4.4.39-gentoo"
	einfo ""
	einfo "Recommend you ensure \"/usr/local/bin\" is in your \$PATH"

	# conditionally install the test program in /usr/local/bin/
	if use testdata ; then
		einfo 'About to issue command: cp -R '${S}'/kernelConfigLibTest '${D}'/usr/local/bin/'
		cp -v "${S}/kernelConfigLibTest" "${D}/usr/local/bin/" || die "Install failed!"
		einfo 'About to issue command: cp -R '${S}'/testconfig* '${D}'/usr/local/bin/'
		cp -v "${S}/testconfig*" "${D}/usr/local/bin/" || die "Install failed!"
		einfo "The test program kerlenConfigLibTest and associated simple input \"config\" files"
		einfo "have been installed in /usr/local/bin/"
		einfo ""
		einfo "kernelConfigLibTest reads and dumps a single config file,"
		einfo "thus testing the KernelConfig.so library"
		einfo "useage:   $ kernelConfigLibTest <path/to/config1>"
		einfo "example:  $ comparam /home/joe/.config-live-DVD"
	else
		ewarn "The test program kerlenConfigLibTest and associated simple input \"config\" files"
		ewarn "have not been installed because of -testdata USE flag"
	fi

	# conditionally install the "concept" scripts in /usr/local/bin/
	if use scripts ; then
		einfo 'About to issue command: cp -R '${S}'/comparam.sh '${D}'/usr/local/bin/'
		cp -v "${S}/comparam.sh" "${D}/usr/local/bin/" || die "Install failed!"
		einfo 'About to issue command: cp -R '${S}'/compare-configs.sh '${D}'/usr/local/bin/'
		cp -v "${S}/compare-configs.sh" "${D}/usr/local/bin/" || die "Install failed!"
		einfo "The \"concept\" scripts comparm.sh and compare-configs.sh"
		einfo "have been installed in /usr/local/bin/"
		einfo ""
		einfo "comparam.sh compares a single config setting in two config files"
		einfo "useage:   $ comparam <path/to/config1> <path/to/config2> <parameter>"
		einfo "example:  $ comparam /home/joe/.config-live-DVD /boot/config-4.4.39-gentoo iwlwifi"
		einfo ""
		einfo "compare-configs.sh compares all of two config files side-by-side, like compareConfigs binary, just slower"
		einfo "useage:   $ compare-configs.sh <path/to/config1> <path/to/config2>"
		einfo "example:  $ compare-configs.sh /home/joe/.config-live-DVD /boot/config-4.4.39-gentoo"
	else
		ewarn "The \"concept\" scripts comparm.sh and compare-configs.sh"
		ewarn "have not been installed because of -scripts USE flag"
	fi

	einfo "Thank you for using compareConfigs and the KernelConfig library"
}

