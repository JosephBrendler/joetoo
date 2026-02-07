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
	app-arch/tar
	dev-libs/openssl
	dev-util/joetoolkit
	dev-util/script_header_joetoo
	net-misc/curl
	net-misc/wget
	sys-apps/coreutils
	sys-apps/util-linux
	sys-apps/grep
	sys-apps/portage
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

	elog "Installing (cp) into /etc/${PN}/"

	# install README.md, BUILD, BPN files into /etc/${PN}/
	elog "Installing (ins) into /etc/${PN}/"
	target="/etc/${PN}/"
	insinto "${target}"
	newins "${S%/}/README.md" "README.md"  || die "Install failed!"
	elog "Done installing README.md"
	echo "BUILD=${PVR}" > ${T}/BUILD
	newins "${T}/BUILD" "BUILD" || die "Install failed!"
	elog "Done installing BUILD"
	echo "BPN=${PN}" > ${T}/BPN
	newins "${T}/BPN" "BPN" || die "Install failed!"
	elog "Done installing BPN"
        # also install local.cmdline_arguments, local.cmdline_compound_arguments, local.usage
#	newins "${S%/}/local.cmdline_arguments" "local.cmdline_arguments"  || die "Install failed!"
#	elog "Done installing local.cmdline_arguments"
#	newins "${S%/}/local.cmdline_compound_arguments" "local.cmdline_compound_arguments"  || die "Install failed!"
#	elog "Done installing local.cmdline_compound_arguments"
#	newins "${S%/}/local.usage" "local.usage"  || die "Install failed!"
#	elog "Done installing local.usage"

	# Install scripts into /usr/sbin/
	elog "Installing (exe) finalize-chroot-joetoo into /usr/sbin/"
	exeinto "/usr/sbin/"
	newexe "${S%/}/finalize-chroot-joetoo" "finalize-chroot-joetoo" || die "Install finalize-chroot-joetoo failed!"
	elog "Installed finalize-chroot-joetoo"

	# Install reusable tools into root
	elog "Installing (exe) reusable tools into /"
	exeinto "/"
	# /mount-the-rest.gmki91
	newexe "${S%/}/mount-the-rest.gmki91" "/mount-the-rest.gmki91" || die "Install /mount-the-rest.gmki91 failed!"
	elog "Installed /mount-the-rest.gmki91"
	# umount-chroot
	newexe "${S%/}/umount-chroot" "umount-chroot" || die "Install umount-chroot failed!"
	elog "Installed umount-chroot"
	# finalize-chroot-joetoo
	newexe "${S%/}/finalize-chroot-joetoo" "finalize-chroot-joetoo" || die "Install finalize-chroot-joetoo failed!"
	elog "Installed finalize-chroot-joetoo"
	# joetoo-system-install
	newexe "${S%/}/joetoo-system-install" "joetoo-system-install" || die "Install joetoo-system-install failed!"
	elog "Installed joetoo-system-install"
	# chroot-prep
	newexe "${S%/}/chroot-prep" "chroot-prep" || die "Install chroot-prep failed!"
	elog "Installed chroot-prep"
	# chroot-commands
	insinto "/"
	newins "${S%/}/chroot-commands" "chroot-commands" || die "Install chroot-commands failed!"
	elog "Installed chroot-commands"
	# content_for_mkenv_gmki91
	doins -r "${S%/}/content_for_mkenv_gmki91"  || die "Install content_for_mkenv_gmki91 failed!"
	elog "Installed content_for_mkenv_gmki91"
	# content_for_mkimg_template
	doins -r "${S%/}/content_for_mkimg_template"  || die "Install content_for_mkimg_template failed!"
	elog "Installed content_for_mkimg_template"
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
	elog " 0.0.2 fixes sourcing of BUILD, BPN"
	elog " 0.0.3 fixes validation of ROOT in make.conf"
	elog " 0.0.4 updates finalize-chroot-joetoo and adds umount-chroot"
	elog " 0.4.5-7 upgraded from wget-stage3-amd64 to joetoo-system-install (plus)"
	elog ""
	elog "Thank you for using ${PN}"
}
