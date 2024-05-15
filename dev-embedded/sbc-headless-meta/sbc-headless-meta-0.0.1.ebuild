# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="Baseline packages for a headless single board computer (sbc)"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
IUSE="
	-boot-fw +innercore +gpio +joetoo
	raspi564 raspi64 raspi32 tinker32 rock4c64 tinker264 opi564
"

REQUIRED_USE="
	innercore
	sbc? ( ^^ ( raspi564 raspi64 raspi32 tinker32 rock4c64 tinker264 opi564 ) )
"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

# keyword for arm or arm64 according to board selection
KEYWORDS="~arm ~arm64"

BDEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0
"

# to do: version 0.0.4 starts migration of required packages to joetoo
#   so you won't need the genpi overlay
RDEPEND="
	${BDEPEND}
	>=sys-firmware/b43-firmware-5.100.138
	innercore? (
		>=sys-kernel/linux-firmware-20220310
		>=sys-apps/rng-tools-6.8
		>=sys-boot/tinker264-boot-config-0.0.1
	)
	gpio? (
		>=dev-libs/libgpiod-2.1
	)
	joetoo? (
		>=joetoo-base/joetoo-meta-0.2.0
		>=dev-util/joetoolkit-0.3.3
		raspi564?  ( >=dev-embedded/sbc_status_leds-0.0.1[raspi564(+)] )
		raspi64?   ( >=dev-embedded/sbc_status_leds-0.0.1[raspi64(+)] )
		raspi32?   ( >=dev-embedded/sbc_status_leds-0.0.1[raspi32(+)] )
		tinker32?  ( >=dev-embedded/sbc_status_leds-0.0.1[tinker32(+)] )
		rock4c64?  ( >=dev-embedded/sbc_status_leds-0.0.1[rock4c64(+)] )
		tinker264? ( >=dev-embedded/sbc_status_leds-0.0.1[tinker264(+)] )
		opi564?    ( >=dev-embedded/sbc_status_leds-0.0.1[opi564(+)] )
	)
"

pkg_setup() {
	# we need to know which board we are using
	if use raspi564 ; then
		export selector="raspi564"
	else if use raspi64 ; then
		export selector="raspi64"
	else if use raspi32 ; then
		export selector="raspi32"
	else if use tinker32 ; then
		export selector="tinker32"
	else if use rock4c64 ; then
		export selector="rock4c64"
	else if use tinker264 ; then
		export selector="tinker264"
	else if use opi564 ; then
		export selector="opi564"
	else
		export selector=""
	fi; fi; fi; fi; fi; fi; fi
	einfo "Assigned board selector: ${selector}"
}

src_install() {
	elog "Installing (ins) into /etc/portage/"
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${selector}-headless-meta" "package.use_${selector}-headless-meta"
	elog "Installed (newins) package.use_${selector}-headless-meta"

	insinto "/etc/portage/package.unmask/"
	newins "${FILESDIR}/package.unmask_${selector}-headless-meta" "package.unmask_${selector}-headless-meta"
	elog "Installed (newins) package.unmask_${selector}-headless-meta"

	elog "Installing (exe) into /etc/local.d/"
	exeinto "/etc/local.d/"
	newexe "${FILESDIR}/cpu_gov.start"
	elog "Installed (newexe) cpu_gov.start"

	# config_protect this and other files in /etc/local.d
	newenvd "${FILESDIR}/config_protect" "99${PN}"


	# for a joetoo installation, include temp/freq monitoring tool
	if use joetoo ; then
		elog "USE joetoo selected; installing temp/freq monitor tool"
		elog "Installing (exe) into /usr/local/sbin/"
		exeinto "/usr/sbin/"
		newexe "${FILESDIR}/tempfreq_mon_${selector}" "tempfreq_mon_${selector}"
		elog "  Installed (newexe) tempfreq_mon_${selector}"
		# note: use joetoo vpn/svc/temp now in dev-embedded/sbc_status_leds (above)
	else
		elog "USE joetoo NOT selected; NOT installing temp/freq monitoring tool"
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
	elog "${PN} installed for ${selector}"
	elog "Depends on joetoo-meta by default (see joetoo USE flag) "
	elog ""
	elog "version 0.0.1 is the first consolidated ${PN} ebuild"
	elog ""
	elog "Thank you for using ${PN}"
}
