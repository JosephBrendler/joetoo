# joe brendler 6/8/2024
# re-write: moved from filesdir back to src_uri for better version control

EAPI=8

DESCRIPTION="A simple joetoo update sequence (jus)"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

S="${WORKDIR%/}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64 amd64 x86 arm arm64"

IUSE="distcc eix"
RESTRICT="mirror"

RDEPEND=">=sys-apps/portage-2.3.3
	>=app-portage/portage-utils-0.62
	>=app-portage/gentoolkit-0.3.2
	eix? (
		>=app-portage/eix-0.32.4
		>=app-shells/push-2.0
	)
	distcc? ( >=sys-devel/distcc-3.1 )
	dev-util/script_header_joetoo[extended]
	>=dev-util/joetoolkit-0.4.21
"
BDEPEND="${RDEPEND}"

src_install() {
	# Note: utility script header installs in /usr/local/sbin
	einfo "WORKDIR=${WORKDIR}"
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "ED=${ED}"
	einfo "T=${T}"
	einfo "P=${P}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo ""
	# copy config file to temp space, to edit if needed
	einfo "Copying ${PN}.conf to ${T} to edit if needed"
	cp -v ${S}/${PN}.conf ${T}/

	if use distcc ; then
		elog "  (USE=\"distcc\") (set)"
		einfo "About to execute command sed -i 's/^DISTCC="no"/DISTCC="yes"/' ${T}/${PN}.conf"
		sed -i 's/^DISTCC="no"/DISTCC="yes"/' "${T}/${PN}.conf"
	else
		elog "  (USE=\"-distcc\") (unset)"
		einfo "About to execute command sed -i 's/^?DISTCC="yes"/DISTCC="no"/' ${T}/${PN}.conf"
		sed -i 's/^?DISTCC="yes"/DISTCC="no"/' "${T}/${PN}.conf"
	fi
	if use eix ; then
		elog "  (USE=\"eix\") (set)"
		einfo "About to execute command sed -i 's/^EIX="no"/EIX="yes"/' ${T}/${PN}.conf"
		sed -i 's/^EIX="no"/EIX="yes"/' "${T}/${PN}.conf"
	else
		elog "  (USE=\"-eix\") (unset)"
		einfo "About to execute command sed -i 's/^?EIX="yes"/EIX="no"/' ${T}/${PN}.conf"
		sed -i 's/^?EIX="yes"/EIX="no"/' "${T}/${PN}.conf"
	fi

	# install utilities jus and rus in /usr/bin; .conf file in /etc/
	dodir usr/bin/
	dodir /etc/${PN}/
	target="/usr/bin"
	# install jus
	einfo "Installing (exe) ${PN} into ${target} ..."
	exeinto "${target}"
	newexe "${S}/${PN}" "${PN}"
	elog "Installed (exe) ${PN} in ${target}"

	# install rus
	einfo "Installing (exe) ${PN/j/r} into ${target} ..."
	exeinto "${target}"
	newexe "${S}/${PN/j/r}" "${PN/j/r}"
	elog "Installed (exe) ${PN/j/r} in ${target}"

	# install jus.conf
	target="/etc/${PN}/"
	insinto "${target}"
	newins "${T}/${PN}.conf" "${PN}.conf"
	elog "Installed (ins) ${PN}.conf in ${target}"

	einfo "About to create PKG_PVR (BUILD) file"
	build_assignment="BUILD='"
	build_assignment+="${PVR}'"
	echo "${build_assignment}" > ${T}/PKG_PVR
	newins "${T}/PKG_PVR" "BUILD"
	elog "PKG_PVR file with content [${PVR}] installed in ${target}/BUILD"
	elog ""
}

pkg_postinst() {
	elog ""
	elog "Completed installation of ${P}"
	elog ""
	elog "Version 6.0.1.9999 was the initial version of jus, adapted from gus-5.3.1.9999"
	elog " 6.5.0 moves ${PN} bak to myUtilities repo for better version control; updates code"
	elog " 6.5.1 fixes bug in verbosity of bs sort of updateables"
	elog " 6.5.2 makes update-check quieter"
	elog " 6.6.0 moves sources to app-portage; adds distcc and new/changeduse cmdline control"
	elog " 6.6.1 moves to script_header_joetoo"
	elog " 6.6.2 vice grep ^PORTDIR now source make.conf which may e.g. =\${ROOT}var/db/..."
	elog ""
	elog "Thank you for using ${PN}"

}
