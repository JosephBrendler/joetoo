# Copyright (c) joe brendler  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="joetoo program to run and configure sbc emulation instances with qemu"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64 ~amd64"
IUSE=""

RESTRICT="mirror"

S="${WORKDIR}/${PN}"

BDEPEND=""

RDEPEND="
	${BDEPEND}
	dev-util/script_header_joetoo
"


src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "A=${A}"
	einfo "T=${T}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"

	# install README.md, BUILD, BPN files into /etc/${PN}/
	elog "Installing (ins) into /etc/${PN}/"
	insinto "/etc/${PN}/"
	newins "${S}/README.md" "README.md"  || die "Install failed!"
	elog "Done installing README.md"
	echo "BUILD=${PVR}" > ${T}/BUILD
	newins "${T}/BUILD" "BUILD" || die "Install failed!"
	elog "Done installing BUILD"
	echo "BPN=${PN}" > ${T}/BPN
	newins "${T}/BPN" "BPN" || die "Install failed!"
	elog "Done installing BPN"
#	# also install local.cmdline_arguments, local.cmdline_compound_arguments, local.usage
#	newins "${S}/local.cmdline_arguments" "local.cmdline_arguments"  || die "Install failed!"
#	elog "Done installing local.cmdline_arguments"
#	newins "${S}/local.cmdline_compound_arguments" "local.cmdline_compound_arguments"  || die "Install failed!"
#	elog "Done installing local.cmdline_compound_arguments"
	newins "${S}/local.usage" "local.usage"  || die "Install failed!"
	elog "Done installing local.usage"

	# Install script into /usr/sbin/
	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	newexe "${S}/${PN}" "${PN}" || die "failed to install script ${PN}"
	elog "Done installing script ${PN}"

	# Install this package's .conf files in /etc/${PN}
	target="/etc/${PN}"
	insinto "${target}"
	for x in $(find ${S} -name "${PN}_*.conf") ; do
		z=$(basename $x)
		einfo "installing ${z} into ${target}"
		newins "${x}" "${z}"  || die "failed to install ${z} into ${target}"
	done
	elog "Done installing .conf file(s)"

	# Install ${PN}.conf eselect module
	target="/usr/share/eselect/modules/"
	einfo "Installing (ins) the ${PN}.conf eselect module into ${target} ..."
	insinto "${target}"
	z="${PN}.eselect"
	newins "${S}/${z}" "${z}"
	elog "Installed ${PN}.conf eselect module."

}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "ver 0.0.1 is the initial build"
	elog " 0.0.2 adds local.usage info about eselect module"
	elog ""
	ewarn "Note: ${PN} has installed files in /etc/${PN}. By default,"
	ewarn "  these will be config-protect'd and you will need to use"
	ewarn "  e.g. dispatch-conf to complete their installation."
	ewarn "  To override this behavior, add /etc/${PN}/ to"
	ewarn "  CONFIG_PROTECT_MASK in /etc/portage/make.conf"
	elog ""
	elog "Thank you for using ${PN}"
}
