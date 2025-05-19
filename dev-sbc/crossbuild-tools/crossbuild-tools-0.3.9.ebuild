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

RDEPEND="
	${BDEPEND}
	app-admin/eselect
	app-arch/tar
	dev-lang/python-exec
	dev-libs/openssl
	dev-util/script_header_brendlefly
	net-misc/curl
	net-misc/wget
	sys-apps/coreutils
	sys-apps/util-linux
	sys-block/parted
	sys-fs/dosfstools
	sys-fs/e2fsprogs
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

	# Install mkenv-files, mkimg-files, admin_files, README, and create-install BUILD
	elog "Installing (cp) into /etc/${PN}/"
	for x in $(find ${S}/${PN}/mkenv-files/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/${PN}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing mkenv-files config files and scripts"
	for x in $(find ${S}/${PN}/mkimg-files/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/${PN}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing mkimg-files config files and scripts"
	for x in $(find ${S}/${PN}/admin_files/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/${PN}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing admin_files config files and scripts"
	elog "Installing (ins) into /etc/${PN}/"
	insinto "/etc/${PN}/"
	newins "${S}/${PN}/README" "README"  || die "Install failed!"
	elog "Done installing README"
	echo "BUILD=${PVR}" > ${T}/BUILD
	newins "${T}/BUILD" "BUILD" || die "Install failed!"
	elog "Done installing BUILD"

	# Install cb- scripts
	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	for x in $(find ${S}/${PN}/ -type f -iname 'cb-*'); do
		z=$(basename $x)
		newexe "${x}" "${z}" || die "Install ${z} failed!"
	done
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
	elog " 0.0.26 enables media mount for image build"
	elog " 0.1.0 generalizes to spt any sbc w BOARD image file framework"
	elog " 0.2.0 adds cb-mkimg and finalize-chroot-for-image scripts"
	elog " 0.3.0 culminates refinements prerequisite to running cb-mkimg"
	elog " 0.3.1 consolidates some files in mkimg-files/common"
	elog " 0.3.2-9 provide refinements and bugfixes"
	elog ""
	ewarn "Note: ${PN} has installed files in /etc/${PN}. By default,"
	ewarn "  these will be config-protect'd and you will need to use"
	ewarn "  e.g. dispatch-conf to complete their installation."
	ewarn "  To override this behavior, add /etc/${PN}/ to"
	ewarn "  CONFIG_PROTECT_MASK in /etc/portage/make.conf"
	elog ""
	ewarn "Note: the mkimg-files structure is provided as an"
	ewarn "  instructional guide.  You can populate the structure"
	ewarn "  at /etc/${PN}/mkimg-files/ with your personal,"
	ewarn "  possibly sensitive, content and update the script at"
	ewarn "etc/${PN}/mkimg-files/common/usr/local/sbin/finalize-chroot"
	ewarn "to tailor system crossbuild template(s) to your needs"
	elog ""
	elog "Thank you for using ${PN}"
}
