# Copyright (c) joe brendler  2025-4976
# joseph.brendler@gmail.com
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
	dev-lang/rust-bin[rust-src]
	dev-libs/openssl
	dev-python/pkgconfig
	dev-util/joetoolkit
	dev-util/script_header_joetoo
	net-misc/curl
	net-misc/wget
	sys-apps/arch-chroot
	sys-apps/coreutils
	sys-apps/dtc
	sys-apps/grep
	sys-apps/portage
	sys-apps/util-linux
	sys-block/parted
	sys-devel/crossdev
	sys-fs/dosfstools
	sys-fs/e2fsprogs
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

	# install mkupd-files into /etc/${PN}/
	for x in $(find ${S}/mkupd-files/ -type f) ; do
		z=$(echo ${x} | sed "s|${S}/||")
		DN=$(dirname $z)
		[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
		cp -p ${x} ${D}/etc/${PN}/${DN}
	done
	elog "Done installing mkupd-files config files and scripts"

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

	# install cb-layout-device templates into /etc/${PN}/
	for template_dir in cb-layout-device-sfdisk-templates cb-layout-device-blkid-templates cb-layout-device-lsblk-templates ; do
		for x in $(find ${S}/${template_dir}/ -type f) ; do
			z=$(echo ${x} | sed "s|${S}/||")
			DN=$(dirname $z)
			[ ! -d ${D}/etc/${PN}/${DN} ] && mkdir -p ${D}/etc/${PN}/${DN}
			cp -p ${x} ${D}/etc/${PN}/${DN}
		done
		elog "Done installing mkimg-files config files and scripts"
	done

	# install RUST_CROSS_TARGETS configuration
	insinto "/etc/portage/env/dev-lang/"
        newins "${S}/etc_portage_dev-lang_rust" "rust" || die "Install failed!"
        elog "Done installing RUST_CROSS_TARGETS configuration"

	# install README.md, BUILD, BPN files into /etc/${PN}/
	elog "Installing (ins) into /etc/${PN}/"
	target="/etc/${PN}/"
	insinto "${target}"
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

        # also install cb-layout-device.local and its local.cmdline_arguments, local.cmdline_compound_arguments, local.usage
	target="/etc/${PN}/cb-layout-device.local/"
	insinto "${target}"
	newins "${S}/cb-layout-device.local/local.cmdline_arguments" "local.cmdline_arguments"  || die "Install failed!"
	elog "Done installing local.cmdline_arguments for cb-layout-device.local"
	newins "${S}/cb-layout-device.local/local.cmdline_compound_arguments" "local.cmdline_compound_arguments"  || die "Install failed!"
	elog "Done installing local.cmdline_compound_arguments for cb-layout-device.local"
	newins "${S}/cb-layout-device.local/local.usage" "local.usage"  || die "Install failed!"
	elog "Done installing local.usage for cb-layout-device.local"

        # also install cb-mkupd.local and its local.cmdline_arguments, local.cmdline_compound_arguments, local.usage
	target="/etc/${PN}/cb-mkupd.local/"
	insinto "${target}"
	newins "${S}/cb-mkupd.local/local.cmdline_arguments" "local.cmdline_arguments"  || die "Install failed!"
	elog "Done installing local.cmdline_arguments for cb-mkupd.local"
	newins "${S}/cb-mkupd.local/local.cmdline_compound_arguments" "local.cmdline_compound_arguments"  || die "Install failed!"
	elog "Done installing local.cmdline_compound_arguments for cb-mkupd.local"
	newins "${S}/cb-mkupd.local/local.usage" "local.usage"  || die "Install failed!"
	elog "Done installing local.usage for cb-mkupd.local"

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
	einfo "Installing (ins) the custom_content/mkimg-files (cb-populate-img.eselect) module into /usr/share/eselect/modules/ ..."
	insinto "/usr/share/eselect/modules/"
	z="cb-populate-img.eselect"
	newins "${S}/${z}" "${z}"
	elog "Installed custom_content/mkimg-files (cb-populate-img.eselect) module."

	# Install cb-mount-binhosts_template.start in /etc/local.d
	target="/etc/local.d/"
	# use insinto/newins rather than exeinto/newexe b/c don't want it executable by default
	# (user should modify first)
	einfo "Installing (ins) cb-mount-binhosts_template.start in ${target}"
	exeinto "${target}"
	z="cb-mount-binhosts_template.start"
	newexe "${S}/${z}" "${z}"

	elog "Installed cb-mount-binhosts_template.start in ${target}"
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
	elog " 0.14.0 adds a temporary package.env for cb-perl-wrapper"
	elog " 0.14.1-4 provide bugfixes, rationalizations, and enhancements"
	elog " 0.14.5 sorted out sequenced deps in finalize-chroot-common-functions"
	elog " 0.14.6-8 provides bugfixes, rationalizations, and enhancements"
	elog " 0.14.9 updates crossbuild-tools for new script_header_joetoo"
	elog " 0.14.10-16 add/bugfix layout templates for rk3588-radxa-rock-5b+"
	elog ""
	ewarn "Notes:"
	ewarn "  (1) cb-mount-binhosts_template.start is installed in /etc/local.d/"
	ewarn "  You should modify, rename, and chmod +x a customized version so your"
	ewarn "  system can mount cross-built binary package hosts at system-startup"
	elog ""
	ewarn "  (2) ${PN} has installed files in /etc/${PN}"
	ewarn "  By default, these files will be config-protect'd and you will"
	ewarn "  need to use (e.g.) dispatch-conf to complete their"
	ewarn "  installation.  To override this behavior, add"
	ewarn "  /etc/${PN}/ to CONFIG_PROTECT_MASK in"
	ewarn "  /etc/portage/make.conf"
	elog ""
	ewarn "  (3) Use the cb-populate-image eselect module to populate"
	ewarn "  /etc/${PN}/custom-content/mkimg-files/"
	ewarn "  by linking your own content, granting you privacy and control."
	elog ""
	ewarn "  (4) Though not recommended, you can also edit the"
	ewarn "  finalize-chroot-env|img|upd scripts at"
	ewarn "  /etc/${PN}/mk[env|img|upd]-files/common/usr/local/sbin/"
	ewarn "  to tailor system crossbuild template(s) to your needs"
	elog ""
	ewarn "  (5) Use the cb-layout-device eselect module to choose a device-"
	ewarn "  layout template to be used by cb-mkdev to make an actual"
	ewarn "  bootable media device for your board"
	elog ""
	ewarn "  (6) You may still need to install a bootloader like u-boot"
	ewarn "  cb-mkdev does not automate that yet (you do it, separately)"
	elog ""
	elog "Thank you for using ${PN}"
}
