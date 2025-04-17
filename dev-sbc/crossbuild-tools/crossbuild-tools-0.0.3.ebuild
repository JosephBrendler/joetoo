# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="joetoo program to run and configure sbc emulation instances with qemu"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${P}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64 ~amd64"
IUSE=""

S="${WORKDIR}"

BDEPEND=""

# as of 20250201 stable qemu does not have a raspi4b model, so use ~arm64 version of qemu for that board
RDEPEND="
	${BDEPEND}
	sys-devel/crossdev
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

	# Install config files and README
	elog "Installing (ins) into /etc/${PN}/"
	insinto "/etc/${PN}/"
	doins -r "${S}/${PN}/files"
	elog "Done installing config files"
	newins "${S}/${PN}/README" "README"
	elog "Done installing README"

	# Install scripts
	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	newexe "${S}/${PN}/chroot-target" "chroot-target"
	newexe "${S}/${PN}/populate-target" "populate-target"
	newexe "${S}/${PN}/quickpkg-toolchain" "quickpkg-toolchain"
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
	elog " 0.0.2 adds root/.bash[rc|_profile] and alias emerge-chroot"
	elog " 0.0.3 adds buildtarget-qemu script"
	elog ""
	elog "Note: ${PN} has installed files in /etc/${PN}. By default,"
	elog "  these will be config-protect'd and you will need to use"
	elog "  e.g. dispatch-conf to complete their installation."
	elog "  To override this behavior, add /etc/${PN}/ to"
	elog "  CONFIG_PROTECT_MASK in /etc/portage/make.conf"
	elog ""
	elog "Thank you for using ${PN}"
}
