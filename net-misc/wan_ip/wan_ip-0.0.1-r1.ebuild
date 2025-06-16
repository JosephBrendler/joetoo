# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="A very light wrapper to rsync content, scripts, and binary packages on home net"
HOMEPAGE="https://github.com/JosephBrendler/myUtilities"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

IUSE=""

RESTRICT="mirror"

RDEPEND="
	net-misc/dropbox
	app-misc/jq
	net-analyzer/speedtest-cli
	dev-util/joetoolkit
"

BDEPEND="${RDEPEND}"

src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"

	# install the .conf file
	target="/etc/${PN}/"
	elog "Installing (ins) into ${target}"
	insinto "${target}"
	newins "${S}/${PN}/${PN}.conf" "${PN}.conf"
	elog "  Installed (ins) ${PN}.conf"

	# install the cron job file
	target="/etc/cron.d/"
	elog "Installing (ins) joetoo ${PN}.cron file into ${target}"
	insinto "${target}"
	newins "${S}/${PN}/${PN}.cron" "${PN}.cron"
	elog "Installed (newins) ${PN}.cron"

	# install the get_ and post_ executables
	target="/root/bin/"
	elog "Installing (exe) into ${target}"
	exeinto "${target}"
	newexe "${S}/${PN}/get_${PN}.sh" "get_${PN}.sh"
	elog "Installed (newexe) get_${PN}.sh"
	newexe "${S}/${PN}/post_${PN}.sh" "post_${PN}.sh"
	elog "Installed (newexe) post_${PN}.sh"
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
	elog "version_history will be located in the ebuild's $FILESDIR"
	elog " 0.0.1 is the initial draft package and ebuild"
	elog ""
	elog ""
	elog ""
	elog "Thank you for using ${PN}"
}
