# Copyright (c) brendlefly  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=8

inherit linux-info

DESCRIPTION="joetoo program to run and configure sbc emulation instances with qemu"
HOMEPAGE="https://github.com/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${P}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm ~arm64 ~amd64"
IUSE="
	bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3288-tinker-s
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 rk3588s-rock-5c
"

# Install for selected board(s) from above different choices, like joetoo-meta does via pkg_setup(),
# but note that where joetoo-meta is "exactly-one-of" board, this is "at-least-one-of"...
# Therefor, need to do in src_install and use for loop to install selected boards
REQUIRED_USE="
	|| (
		bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
		rk3288-tinker-s
		rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 rk3588s-rock-5c
	)
"

S="${WORKDIR}"

BDEPEND="
	>=app-admin/eselect-1.4.27-r1
"

# to do: version 0.0.4 starts migration of required packages to joetoo
#   so you won't need the genpi overlay
RDEPEND="
	${BDEPEND}
	app-emulation/qemu[bzip2(+),lzo(+),ncurses(+),usb(+),sdl(+),xattr(+),gtk(+)]
	bcm2711-rpi-4-b? (
		>=app-emulation/qemu-9.2.0[bzip2(+),lzo(+),ncurses(+),usb(+),sdl(+),xattr(+),gtk(+)]
		)
"

pkg_pretend() {
	if linux_config_exists ; then
		# first check for routine y/n/m settings
		# define what to check for --
		#   ''  no prefix means "required"
		#   '~' prefix means "not required"
		#   '@' prefix means "must be a module"
		#   '!' prefix means "must not set"
		local CONFIG_CHECK="\
			HIGH_RES_TIMERS KVM ~KVM_INTEL ~KVM_AMD VIRTUALIZATION VHOST_NET HPET \
			~COMPACTION ~MIGRATION ~KSM SYSFS PROC_FS TRANSPARENT_HUGEPAGE \
			~CGROUPS ~KVM_HYPERV \
			NET_CORE TUN ~IPV6 BRIDGE \
			VFIO_MDEV ~DRM_I915_GVT ~DRM_I915_GVT_KVMGT \
			"
		check_extra_config && elog "check_extra_config passed" || elog "check_extra_config failed"
	fi
}
#		fat_def_codepage=$(linux_chkconfig_string FAT_DEFAULT_CODEPAGE)
#		[[ ${fat_def_codepage} -eq 437 ]] && \
#			elog "FAT_DEFAULT_CODEPAGE ok (${fat_def_codepage})" || \
#			ewarn "FAT_DEFAULT_CODEPAGE NOT ok (${fat_def_codepage}) should be 437"


pkg_setup() {
	# for sbc systems we need to know which board we are using
	boards=""
	einfo "Assigning boards..."
	if use bcm2712-rpi-5-b ; then export boards+=" bcm2712-rpi-5-b"; fi
	if use bcm2711-rpi-4-b ; then export boards+=" bcm2711-rpi-4-b"; fi
	if use bcm2710-rpi-3-b-plus; then export boards+=" bcm2710-rpi-3-b-plus"; fi
	if use bcm2710-rpi-3-b; then export boards+=" bcm2710-rpi-3-b"; fi
	if use bcm2709-rpi-2-b; then export boards+=" bcm2709-rpi-2-b"; fi
	if use bcm2708-rpi-b; then export boards+=" bcm2708-rpi-b"; fi
	if use rk3288-tinker-s; then export boards+=" rk3288-tinker-s"; fi
	if use rk3399-rock-pi-4c-plus; then export boards+=" rk3399-rock-pi-4c-plus"; fi
	if use rk3399-tinker-2; then export boards+=" rk3399-tinker-2"; fi
	if use rk3588s-orangepi-5; then export boards+=" rk3588s-orangepi-5"; fi
	if use rk3588s-rock-5c; then export boards+=" rk3588s-rock-5c"; fi
	einfo "boards: ${boards}"
}

src_install() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "A=${A}"
	einfo "T=${T}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"

	# Install config files and README
	elog "Installing (ins) into /etc/${PN}/"
	# install the .conf files for each USE'd board in ${boards}
	insinto "/etc/${PN}/"
	for board in ${boards}; do
		if [ -e ${S}/${PN}/${PN}_${board}_template.conf ] ; then
			newins "${S}/${PN}/${PN}_${board}_template.conf" "${PN}_${board}_template.conf"
			elog "  Installed (newins) ${PN}_${board}_template.conf"
		else
			elog "  Tried to install (newins) but could not find ${S}/${PN}/${PN}_${board}_template.conf"
		fi
	done
	newins "${FILESDIR}/README" "README"
	elog "  Installed (newins) README"

	# Install executables
	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	for x in $(find ${S}/${PN}/ -type f -executable); do
		y=$(basename $x)
		newexe "${x}" "${y}"
		elog "Installed (newexe) ${y}"
	done

	# Install eselect module
	elog "Installing the joetoo ${PN}.conf eselect module..."
	insinto "/usr/share/eselect/modules/"
	newins "${S}/${PN}/${PN}.eselect" "${PN}.eselect"
	elog "Done installing the joetoo ${PN}.conf eselect module."

}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "BDEPEND=${BDEPEND}"
	einfo "boards=${boards}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "You can create additional configurations in /etc/${PN}"
	elog "Use eselect ${PN} to pick one of them"
	elog ""
	elog ""
	elog "version 0.0.1 is the initial build"
	elog ""
	elog "Thank you for using ${PN}"
}
