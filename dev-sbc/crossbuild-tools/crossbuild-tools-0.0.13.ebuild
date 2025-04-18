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

RESTRICT="mirror"

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

	# Install config files, README, and BUILD
	elog "Installing (ins) into /etc/${PN}/"
	insinto "/etc/${PN}/"
	doins -r "${S}/${PN}/files" || die "Install failed!"
	elog "Done installing config files"
	newins "${S}/${PN}/README" "README"  || die "Install failed!"
	elog "Done installing README"
	echo "BUILD=${PVR}" > ${T}/BUILD
	newins "${T}/BUILD" "BUILD" || die "Install failed!"
	elog "Done installing BUILD"

	# Install scripts
	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	newexe "${S}/${PN}/chroot-target" "chroot-target" || die "Install failed!"
	newexe "${S}/${PN}/populate-target" "populate-target" || die "Install failed!"
	newexe "${S}/${PN}/quickpkg-toolchain" "quickpkg-toolchain" || die "Install failed!"
	newexe "${S}/${PN}/buildtarget-qemu" "buildtarget-qemu" || die "Install failed!"
	newexe "${S}/${PN}/mkcrossbuildenv" "mkcrossbuildenv" || die "Install failed!"
	elog "Done installing scripts"
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
	elog " 0.0.4 adds finalize-chroot to run on first login from .bashrc"
	elog " 0.0.5 adds repos.conf and mkcrossbuildenv script"
	elog " 0.0.6 adds install_my_local_ca_certificates"
	elog " 0.0.7 adds keywords for chroot"
	elog " 0.0.8 adds dependent keywords and bugfix for finalize-chroot"
	elog " 0.0.9 refines mkcrossbuildenv script and adds BUILD"
	elog " 0.0.10-12 provide bugfixes and refinements"
	elog " 0.0.13 clarifies ARCH arm64 vs aarch64 in validate_target() fns"
	elog ""
	ewarn "Note: ${PN} has installed files in /etc/${PN}. By default,"
	ewarn "  these will be config-protect'd and you will need to use"
	ewarn "  e.g. dispatch-conf to complete their installation."
	ewarn "  To override this behavior, add /etc/${PN}/ to"
	ewarn "  CONFIG_PROTECT_MASK in /etc/portage/make.conf"
	elog ""
	elog "Thank you for using ${PN}"
}
