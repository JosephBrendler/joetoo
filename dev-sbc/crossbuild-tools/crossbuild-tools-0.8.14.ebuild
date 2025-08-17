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
	dev-libs/openssl
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

	# install cb-assemble-make-conf make-conf-parts framework into /etc/${PN}/
	for x in $(find ${S}/make-conf-parts/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing cb-assemble-make-conf make-conf-parts framework"

	# install cb-assemble-make-conf make-conf-files framework into /etc/${PN}/
	for x in $(find ${S}/make-conf-parts/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing cb-assemble-make-conf make-conf-files framework"

	# install config files into /etc/${PN}/
	for x in $(find ${S}/configs/ -maxdepth 1 -type f) ; do
		cp -p ${x} ${D}/etc/${PN}/
	done
	elog "Done installing admin_files config files and scripts"

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
	# (this is currently only cb-assemble-make-conf.conf)
	insinto "/etc/${PN}"
	for x in $(find ${S}/ -maxdepth 1 -type f -iname 'cb-*.conf') ; do
		z=$(basename $x)
		newins "${x}" "${z}" || die "Install ${z} failed!"
	done
	elog "Done installing .conf file(s)"

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
	elog " 0.0.26 enables media mount for image build"
	elog " 0.1.0 generalizes to spt any sbc w BOARD image file framework"
	elog " 0.2.0 adds cb-mkimg and finalize-chroot-for-image scripts"
	elog " 0.3.0 culminates refinements prerequisite to running cb-mkimg"
	elog " 0.3.1 consolidates some files in mkimg-files/common"
	elog " 0.3.2-9 provide refinements and bugfixes"
	elog " 0.4.0 integrates cb-mount cb-umount and supports rk3588-rock-5b"
	elog " 0.4.1 corrects package.use/joetoo for rk3588-rock-5b & others"
	elog " 0.4.2 corrects .accept_keywords/joetoo for rk3588-rock-5b (+)"
	elog " 0.4.3 provides refinements and bugfixes"
	elog " 0.4.4 supports bcm2711-rpi-cm4-io and bcm2712-rpi-cm5-cm5io"
	elog " 0.5.0 provides initial draft of cb-layout-device and cb-mkdev"
	elog " 0.6.0 reworks common fns, cb-layout-device, and cb-flash-device"
	elog " 0.6.1 refines common-functions, layout-device flash-device"
	elog " 0.6.2 bugfix source cb-common-functions and add eselect"
	elog " 0.6.3 add list_unused_disks, non-stty separator, right_status"
	elog " 0.6.4/5 refines cb-collect- scripts (to generalize)"
	elog " 0.6.6/7 build and bugfix cb-mkdev; fix sanity check"
	elog " 0.6.8 fixes bad CFLAGS in raspi4/cm4 make.conf"
	elog " 0.6.9 moves to script_header_joetoo"
	elog " 0.6.10 adds meson-gxl-s905x-libretech-cc-v2 (sweet potato)"
	elog " 0.6.11 provides refinements and bugfixes"
	elog " 0.6.12 adds fsl-imx8mq-phanbell (TinkerEdgeT/CoralDev)"
	elog " 0.7.0 is a rewrite w header fns, cli processing, fixes, etc."
	elog " 0.7.1-5 provides bugfixes and refinements"
	elog " 0.7.6 enables eselect handling of custom image content"
	elog " 0.7.7 provides bugfixes and refinements"
	elog " 0.7.8 adds cb-assemble-make-conf framework"
	elog " 0.7.9 adds smaller_script_common_usage_message"
	elog " 0.7.10/11 add symlink-repo step to cb-mkenv"
	elog " 0.7.12 updates cb-mkenv, cb-chroot-target, finalize-chroot"
	elog " 0.7.14 updates cb-buildtarget-qemu, mkenv, common-functions"
	elog " 0.7.15 cb-buildtarget-qemu, -quickpkg-toolchain -> cb-mkenv"
	elog " 0.7.16 adds bugfixes and saves completed .img as BOARD.env"
	elog " 0.7.17 final mods to cb-mkenv -mkimg w cb-umount, stockpile"
	elog " 0.8.0 introduced cb-mount/umount-binhost"
	elog " 0.8.1 adds meson-g12b-a311d-libretech-cc (alta)"
	elog " 0.8.2 adds refinements and bugfixes"
	elog " 0.8.3 adds meson-sm1-s905d3-libretech-cc (solitude)"
	elog " 0.8.4/5 update make-conf-files, fix cb-populate-image.eselect"
	elog " 0.8.6 uses joetoo-platform-meta's board-specific configs"
	elog " 0.8.7 adds steps to change and edit configs before use"
	elog " 0.8.8-10 fix TARGET-emerge joetoo-platform-meta and USEs"
	elog " 0.8.11 ads a dispatch-conf step to cb-mkenv"
	elog " 0.8.12-14 provide refinements and bugfixes"
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
