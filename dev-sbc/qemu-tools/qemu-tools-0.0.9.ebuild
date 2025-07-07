# Copyright (c) joe brendler  joseph.brendler@gmail.com
# License: GPL v3+
# NO WARRANTY

EAPI=8

inherit linux-info

DESCRIPTION="joetoo program to run and configure sbc emulation instances with qemu"
HOMEPAGE="https://github.com/joetoo"
#SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${P}.tbz2"  ## let -r1 get same sources
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm ~arm64 ~amd64"
IUSE="
	bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2711-rpi-cm4-io bcm2710-rpi-3-b-plus
	bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
	rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588-rock-5b rk3588s-orangepi-5 rk3588s-rock-5c
	rk3288-tinker-s
	meson-gxl-s905x-libretech-cc-v2
"

# Install for selected board(s) from above different choices, like joetoo-meta does via pkg_setup(),
# but note that where joetoo-meta is "exactly-one-of" board, this is "at-least-one-of"...
# Therefor, need to do in src_install and use for loop to install selected boards
REQUIRED_USE="
	|| (
		bcm2712-rpi-cm5-cm5io bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2711-rpi-cm4-io bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b bcm2709-rpi-2-b bcm2708-rpi-b
		rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588-rock-5b rk3588s-orangepi-5 rk3588s-rock-5c
		rk3288-tinker-s
		meson-gxl-s905x-libretech-cc-v2
	)
"

S="${WORKDIR}"

BDEPEND="
	>=app-admin/eselect-1.4.27-r1
"

# as of 20250201 stable qemu does not have a raspi4b model, so use ~arm64 version of qemu for that board
RDEPEND="
	${BDEPEND}
	app-emulation/qemu[bzip2(+),lzo(+),ncurses(+),usb(+),sdl(+),xattr(+),gtk(+)]
	bcm2711-rpi-4-b? (
		>=app-emulation/qemu-9.1.0[bzip2(+),lzo(+),ncurses(+),usb(+),sdl(+),xattr(+),gtk(+)]
		)
	bcm2711-rpi-cm4-io? (
		>=app-emulation/qemu-9.1.0[bzip2(+),lzo(+),ncurses(+),usb(+),sdl(+),xattr(+),gtk(+)]
		)
	bcm2712-rpi-5-b? (
		>=app-emulation/qemu-9.1.0[bzip2(+),lzo(+),ncurses(+),usb(+),sdl(+),xattr(+),gtk(+)]
		)
	bcm2712-rpi-cm5-cm5io? (
		>=app-emulation/qemu-9.1.0[bzip2(+),lzo(+),ncurses(+),usb(+),sdl(+),xattr(+),gtk(+)]
		)
	meson-gxl-s905x-libretech-cc-v2? (
		>=app-emulation/qemu-9.1.0[bzip2(+),lzo(+),ncurses(+),usb(+),sdl(+),xattr(+),gtk(+)]
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
# keeping this below as example of how to check specific CONFIG_ settings with linux_chkconfig_string
#		fat_def_codepage=$(linux_chkconfig_string FAT_DEFAULT_CODEPAGE)
#		[[ ${fat_def_codepage} -eq 437 ]] && \
#			elog "FAT_DEFAULT_CODEPAGE ok (${fat_def_codepage})" || \
#			ewarn "FAT_DEFAULT_CODEPAGE NOT ok (${fat_def_codepage}) should be 437"


pkg_setup() {
	# for sbc systems we need to know which board we are using
	boards=""
	einfo "Assigning boards..."
	if use bcm2712-rpi-cm5-cm5io ; then export boards+=" bcm2712-rpi-cm5-cm5io"; fi
	if use bcm2712-rpi-5-b ; then export boards+=" bcm2712-rpi-5-b"; fi
	if use bcm2711-rpi-cm4-io ; then export boards+=" bcm2711-rpi-cm4-io"; fi
	if use bcm2711-rpi-4-b ; then export boards+=" bcm2711-rpi-4-b"; fi
	if use bcm2710-rpi-3-b-plus; then export boards+=" bcm2710-rpi-3-b-plus"; fi
	if use bcm2710-rpi-3-b; then export boards+=" bcm2710-rpi-3-b"; fi
	if use bcm2709-rpi-2-b; then export boards+=" bcm2709-rpi-2-b"; fi
	if use bcm2708-rpi-b; then export boards+=" bcm2708-rpi-b"; fi
	if use rk3288-tinker-s; then export boards+=" rk3288-tinker-s"; fi
	if use rk3399-rock-pi-4c-plus; then export boards+=" rk3399-rock-pi-4c-plus"; fi
	if use rk3399-tinker-2; then export boards+=" rk3399-tinker-2"; fi
	if use rk3588-rock-5b; then export boards+=" rk3588s-rock-5c"; fi
	if use rk3588s-orangepi-5; then export boards+=" rk3588s-orangepi-5"; fi
	if use rk3588s-rock-5c; then export boards+=" rk3588s-rock-5c"; fi
	if use meson-gxl-s905x-libretech-cc-v2; then export boards+=" meson-gxl-s905x-libretech-cc-v2"; fi
	einfo "boards: ${boards}"
}

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
	# install the .conf files for each USE'd board in ${boards}
	insinto "/etc/${PN}/"
	for board in ${boards}; do
		if [ -e ${S}/${PN}/configs/${PN}_${board}_template.conf ] ; then
			newins "${S}/${PN}/configs/${PN}_${board}_template.conf" "${PN}_${board}_template.conf"
			elog "  Installed (newins) ${PN}_${board}_template.conf"
		else
			elog "  Tried to install (newins) but could not find ${S}/${PN}/${PN}_${board}_template.conf"
		fi
	done
	# install README and BUILD files in /etc/${PN}
	newins "${FILESDIR}/README" "README"
	elog "  Installed (newins) README"
	echo "BUILD=${PVR}" > ${T}/BUILD
	newins "${T}/BUILD" "BUILD"
	elog "  Installed (newins) BUILD"

	# Install qemu-tools executables (but not scripts in sub-directories)
	elog "Installing (exe) into /usr/sbin/"
	exeinto "/usr/sbin/"
	for x in $(find ${S}/${PN}/ -maxdepth 1 -type f -executable); do
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
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "boards=${boards}"
	elog ""
	elog "${P} installed"
	elog ""
	elog "You can create additional configurations in /etc/${PN}"
	elog "Use eselect ${PN} to pick one of them"
	elog ""
	elog ""
	elog "ver 0.0.1 is the initial build"
	elog " 0.0.2 adds qemu-virt-launch and config template"
	elog " 0.0.3 updates qemu-raspi-launch"
	elog " 0.0.4 generalizes qemu-image-mount & qemu-image-launch"
	elog " 0.0.5 updates SRC_URI (location of ${CATEGORY}/${PN} sources)"
	elog " 0.0.6 ebuild incl rk3588-rock-5b (notional support for rockchips)"
	elog " 0.0.7 adds bcm2711-rpi-cm4-io and (notionally) bcm2712-rpi-cm5-cm5io"
	elog " 0.0.8 moves to script_header_joetoo"
	elog " 0.0.9 adds meson-gxl-s905x-libretech-cc-v2 (sweet potato)"
	elog ""
	elog "Thank you for using ${PN}"
}
