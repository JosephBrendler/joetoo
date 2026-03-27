# Copyright (c) joe brendler  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="collects specified system files from client as custom content for use by crossbuild-tools cb-mkimg"
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
	target="/etc/${PN}/"
	einfo "Installing (ins) README.md, BUILD, BPN files into ${target}"
	insinto "${target}"
	newins "${S}/README.md" "README.md"  || die "Install failed!"
	elog "Installed README.md into ${target}"
	echo "BUILD=${PVR}" > ${T}/BUILD
	newins "${T}/BUILD" "BUILD" || die "Install failed!"
	elog "Installed BUILD into ${target}"
	echo "BPN=${PN}" > ${T}/BPN
	newins "${T}/BPN" "BPN" || die "Install failed!"
	elog "Installed BPN into ${target}"

	# install the ${PN}_local.cmdline_arg_handler
	target="/etc/${PN}/"
	insinto "${target}"
	einfo "Installing (ins) ${PN} cmdline arg and usage module into ${target} ..."
	insinto "${target}"
	newins "${S%/}/${PN}_local.cmdline_arg_handler" "${PN}_local.cmdline_arg_handler" || \
		die "failed to install ${PN}_local.cmdline_arg_handler"
	elog "Installed ${PN}_local.cmdline_arg_handler in ${target}"

	# Install script into /usr/sbin/
	einfo "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	newexe "${S}/${PN}" "${PN}" || die "failed to install script ${PN}"
	elog "Installed script ${PN} into ${target}"

	# Install this package's .conf files in /etc/${PN}/configs
	# ( so app_configure will only load the linked config )
	target="/etc/${PN}/configs/"
	insinto "${target}"
	for x in $(find ${S} -type f -name "${PN}_*.conf") ; do
		z="${x##*/}"   # like =$(basename $x) but w/o subshell and function call
		einfo "installing ${z} into ${target}"
		newins "${x}" "${z}"  || die "failed to install ${z} into ${target}"
	done
	elog "Installed .conf file(s) into ${target}"

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
	elog " 0.0.3 provides refinements and bugfixes"
	elog " 0.0.4 updates sensitive source dirs and files"
	elog " 0.1.0 adopts j_msg, new joetoo cli, and extracts ssh key mgmt to script_header_joetoo_ssh"
	elog " 0.1.1-3 provide refinements and bugfixes"
	elog ""
	ewarn "Note: ${PN} has installed files in /etc/${PN}. By default,"
	ewarn "  these will be config-protect'd and you will need to use"
	ewarn "  e.g. dispatch-conf to complete their installation."
	ewarn "  To override this behavior, add /etc/${PN}/ to"
	ewarn "  CONFIG_PROTECT_MASK in /etc/portage/make.conf"
	elog ""
	elog "Thank you for using ${PN}"
}
