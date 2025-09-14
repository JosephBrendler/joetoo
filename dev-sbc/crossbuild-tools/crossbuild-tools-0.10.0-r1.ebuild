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
	app-admin/eselect
	app-arch/tar
	dev-lang/python-exec
	dev-lang/rust-bin
	dev-libs/openssl
	dev-python/pkgconfig
	dev-util/joetoolkit
	dev-util/script_header_joetoo
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

	elog "Installing (cp) into /etc/${PN}/"
	# Install mkenv-files into /etc/${PN}/"
	for x in $(find ${S}/mkenv-files/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing mkenv-files config files and scripts"

	# install mkimg-files into /etc/${PN}/
	for x in $(find ${S}/mkimg-files/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing mkimg-files config files and scripts"

	# install mkdev-files into /etc/${PN}/
	for x in $(find ${S}/mkdev-files/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing mkdev-files config files and scripts"

	# install admin-files into /etc/${PN}/
	for x in $(find ${S}/admin_files/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing admin_files"

	# install custom_content framework into /etc/${PN}/
	for x in $(find ${S}/custom_content/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing custom_content framework"

	# install cb-layout-device config files into /etc/${PN}/
	for x in $(find ${S}/cb-layout-device-configs/ -maxdepth 1 -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/cb-layout-device-configs/
	done
	elog "Done installing cb-layout-device config files"

	# install RUST_CROSS_TARGETS configuration
	insinto "/etc/portage/env/dev-lang/"
        newins "${S}/etc_portage_dev-lang_rust" "rust" || die "Install failed!"
        elog "Done installing RUST_CROSS_TARGETS configuration"

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
        # also install local.cmdline_arguments, local.cmdline_compound_arguments, local.usage
	newins "${S}/local.cmdline_arguments" "local.cmdline_arguments"  || die "Install failed!"
	elog "Done installing local.cmdline_arguments"
	newins "${S}/local.cmdline_compound_arguments" "local.cmdline_compound_arguments"  || die "Install failed!"
	elog "Done installing local.cmdline_compound_arguments"
	newins "${S}/local.usage" "local.usage"  || die "Install failed!"
	elog "Done installing local.usage"

	# Install cb- scripts into /usr/sbin/
	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	for x in $(find ${S}/ -type f -iname 'cb-*'  -executable); do
		z=$(basename $x)
		newexe "${x}" "${z}" || die "Install ${z} failed!"
	done
	elog "Done installing scripts"

	# Install this packages other .conf files in /etc/${PN}
	# (currently N/A)
#	insinto "/etc/${PN}"
#	for x in $(find ${S}/ -maxdepth 1 -type f -iname 'cb-*.conf') ; do
#		z=$(basename $x)
#		newins "${x}" "${z}" || die "Install ${z} failed!"
#	done
#	elog "Done installing .conf file(s)"

	# Install cb-layout-device.conf eselect module
	einfo "Installing (ins) the cb-layout-device.conf eselect module into /usr/share/eselect/modules/ ..."
	insinto "/usr/share/eselect/modules/"
	z="cb-layout-device.eselect"
	newins "${S}/${z}" "${z}"
	elog "Installed cb-layout-device.conf eselect module."

	# Install custom_content/mkimg-files eselect module
	einfo "Installing (ins) the custom_content/mkimg-files (cb-populate-image.eselect) module into /usr/share/eselect/modules/ ..."
	insinto "/usr/share/eselect/modules/"
	z="cb-populate-image.eselect"
	newins "${S}/${z}" "${z}"
	elog "Installed custom_content/mkimg-files (cb-populate-image.eselect) module."
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
	elog " 0.10.0 updates to cb-mkenv, cb-mkimg, andcb-mkdev"
	elog ""
	ewarn "Note: ${PN} has installed files in /etc/${PN}. By default,"
	ewarn "  these will be config-protect'd and you will need to use"
	ewarn "  e.g. dispatch-conf to complete their installation."
	ewarn "  To override this behavior, add /etc/${PN}/ to"
	ewarn "  CONFIG_PROTECT_MASK in /etc/portage/make.conf"
	elog ""
	ewarn "Use the cb-populate-image eselect module to populate"
	ewarn "/etc/${PN}/custom-content/mkimg-files/"
	ewarn "by linking your own content, granting you privacy and control."
	ewarn "You can also edit the finalize-chroot and finalize-chroot-for-image"
	ewarn "scripts at /etc/${PN}/mkimg-files/common/usr/local/sbin/"
	ewarn "to tailor system crossbuild template(s) to your needs"
	ewarn "Use the cb-layout-device eselect module to choose a device-"
	ewarn "layout template to be used by cb-mkdev to make an actual"
	ewarn "bootable media device for your board.  (Note that you may still"
	ewarn "need to install a bootloader like u-boot, separately)"
	elog ""
	elog "Thank you for using ${PN}"
}
