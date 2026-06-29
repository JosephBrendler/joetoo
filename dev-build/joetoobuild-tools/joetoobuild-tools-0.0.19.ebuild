# Copyright (c) joe brendler  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="joetoo program to run and configure sbc emulation instances with qemu"
HOMEPAGE="https://github.com/joetoo"
#SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"
CUSTOM_SRC_ROOT="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master"
SRC_URI=(
"${CUSTOM_SRC_ROOT}/${CATEGORY}/${PN}-${PV}.tbz2"
"${CUSTOM_SRC_ROOT}/dev-util/script_header_joetoo/script_header_joetoo -> script_header_joetoo.copy"
"${CUSTOM_SRC_ROOT}/dev-util/script_header_joetoo/script_header_joetoo_compat -> script_header_joetoo_compat.copy"
"${CUSTOM_SRC_ROOT}/dev-util/script_header_joetoo/script_header_joetoo_unicode -> script_header_joetoo_unicode.copy"
"${CUSTOM_SRC_ROOT}/dev-util/script_header_joetoo/script_header_joetoo_extended -> script_header_joetoo_extended.copy"
"${CUSTOM_SRC_ROOT}/dev-sbc/crossbuild-tools/mkenv-files/common/usr/sbin/finalize-chroot-common-functions -> finalize-chroot-common-functions.copy"
)

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
	einfo "testing access to file from other repo at \$DISTDIR -"
	einfo "file: $DISTDIR/finalize-chroot-common-functions.copy"

	# install README.md, BUILD, BPN files into /etc/${PN}/
	target="/${PN}/"
	elog "Installing (ins) BUILD and BPN into ${target}"
	insinto "${target}"
	newins "${S%/}/README.md" "README.md"  || die "Install failed!"
	elog "Done installing README.md"
	echo "BUILD=${PVR}" > ${T}/BUILD
	newins "${T}/BUILD" "BUILD" || die "Install failed!"
	elog "Done installing BUILD"
	echo "BPN=${PN}" > ${T}/BPN
	newins "${T}/BPN" "BPN" || die "Install failed!"
	elog "Done installing BPN"

	# Testing Install file from dev-sbc/crossbuild-tools package
	target="/${PN}/"
	elog "Installing (exe) finalize-chroot-joetoo into $target"
	exeinto "$target"
	newexe "${DISTDIR%/}/finalize-chroot-common-functions.copy" "finalize-chroot-common-functions" || die "failed to install finalize-chroot-common-functions into ${target}!"
	elog "Installed finalize-chroot-common-functions into $target"

	# Testing Install files from dev-utils/script_header_joetoo package
	# Install script headers into /usr/sbin/ (on what is likely a livecd) so tools will work
	target="/usr/sbin/"
	for x in $(find ${DISTDIR} -mindepth 1 -maxdepth 1 -type f -name 'script_header_joetoo*'); do
		y=${x#${DISTDIR}}   # strip ${DISTDIR} from prefix, leaving filename.copy
		z=${y%.copy}        # strip .copy from suffix, leaving filename
		elog "Installing (exe) $z into ${target}"
		exeinto "${target}"
		newexe "$x" "$z" || die "failed to install $z into $target!"
		elog "Installed $z into $target"
	done
	# also install script headers into $PN (on what is likely a livecd) so tools can deploy them to target build system
	target="/${PN}/"
	for x in $(find ${DISTDIR} -mindepth 1 -maxdepth 1 -type f -name 'script_header_joetoo*'); do
		y=${x#${DISTDIR}}   # strip ${DISTDIR} from prefix, leaving filename.copy
		z=${y%\.copy}        # strip .copy from suffix, leaving filename
		elog "Installing (exe) $z into ${target}"
		exeinto "${target}"
		newexe "$x" "$z" || die "failed to install $z into $target!"
		elog "Installed $z into $target"
	done

	# Install core tools into /${PN}/
	target="/${PN}/"
	for x in $(find ${S} -mindepth 1 -maxdepth 1 -path archive -prune -o -print); do
		z=${x#${S}}    # strip ${S} from prefix, leaving file or direcory name
		if [ -d "$x" ] ; then
			insinto "$target"
			einfo "recursively installing (ins) directory $z into $target"
			doins -r "${x}" || die "failed to recursively installing (ins) directory $z into $target"
			elog "recursively installed (ins) directory $z into $target"
		else
			if [ -x "$x" ] ; then
				exeinto "$target"
				einfo "installing (exe) file $z into $target"
				newexe "$x" "$z" || die "failed to install (exe) file $z into $target"
				elog "installed (exe) file $z into $target"
			else
				insinto "$target"
				einfo "installing (ins) file $z into $target"
				newins "$x" "$z" || die "failed to install (ins) file $z into $target"
				elog "installed (ins) file $z into $target"
			fi
			echo "$x is not directory"
		fi
	done
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
	elog " 0.4.5-10 upgraded from wget-stage3-amd64 to joetoo-system-install (plus)"
	elog " 0.4.11-19 (significant change) now jb- core tools in /$PN/ and added external tools"
	elog ""
	elog "Thank you for using ${PN}"
}
