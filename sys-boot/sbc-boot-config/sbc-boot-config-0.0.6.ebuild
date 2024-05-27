# Copyright (c) 2022-2052 Joe Brendler <joseph.brendler@gmail.com>
# Adapted from work abandoned in 2020 by sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=8

DESCRIPTION="Boot configuration files for single board computers (sbc)s"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~arm64"
RESTRICT="mirror"

IUSE="
bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus bcm2709-rpi-2-b bcm2708-rpi-b
rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5
"

REQUIRED_USE="
^^ ( bcm2712-rpi-5-b bcm2711-rpi-4-b bcm2710-rpi-3-b-plus bcm2709-rpi-2-b bcm2708-rpi-b
rk3288-tinker-s rk3399-rock-pi-4c-plus rk3399-tinker-2 rk3588s-orangepi-5 )
"

DEPEND=""
RDEPEND="
	${DEPEND}"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

pkg_setup() {
	# if /boot is on a separate block device, and it is not mounted, try to mount it
	if grep -v '^#' /etc/fstab | grep boot >/dev/null 2>&1  && \
		! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1
	then
		elog "${ROOT%/}/boot is not mounted, trying to mount it now..."
		! $(mount /boot) && \
			die "Failed to mount /boot" || \
			elog "Succeeded in mounting /boot ; continuing..."
	else
		elog "Verified /boot is mounted ; continuing..."
	fi

	# for sbc systems we need to know which board we are using
if use bcm2712-rpi-5-b ; then
export board="bcm2712-rpi-5-b"
else if use bcm2711-rpi-4-b ; then
export board="bcm2711-rpi-4-b"
else if use bcm2710-rpi-3-b-plus; then
export board="bcm2710-rpi-3-b-plus"
else if use bcm2709-rpi-2-b; then
export board="bcm2709-rpi-2-b"
else if use bcm2708-rpi-b; then
export board="bcm2708-rpi-b"
else if use rk3288-tinker-s; then
export board="rk3288-tinker-s"
else if use rk3399-rock-pi-4c-plus; then
export board="rk3399-rock-pi-4c-plus"
else if use rk3399-tinker-2; then
export board="rk3399-tinker-2"
else if use rk3588s-orangepi-5; then
export board="rk3588s-orangepi-5"
else
export board=""
fi; fi; fi; fi; fi; fi; fi; fi; fi
einfo "Assigned board: ${board}"
}

newins_all() {
	selector="$1"
	for x in $(find ${FILESDIR}/${board}/ -iname "${selector}"); do
		z="$(basename ${x})" ;
		newins "${x}" "${z}" ;
		elog "Installed (ins) ${z} into /boot/"
	done ;
}

src_install() {
# 'starter' versions of these files, will be CONFIG_PROTECTed
	einfo "Installing (ins) configuration files into /boot"
	insinto "/boot/"
	case ${board} in
		"bcm2708-rpi-b"|"bcm2709-rpi-2-b"|"bcm2710-rpi-3-b-plus"|"bcm2711-rpi-4-b"|"bcm2712-rpi-5-b" )
			einfo "Installing (ins) raspberry board config files into /boot" ;
			# install cmdline.txt, config.txt and any other (e.g. README.txt) .txt files
			newins_all "*.txt" ;
			newenvd "${FILESDIR}/config_protect-raspi" "99${PN}" ;;
		"rk3288-tinker-s"|"rk3399-rock-pi-4c-plus"|"rk3399-tinker-2"|"rk3588s-orangepi-5" )
			einfo "Copying rockchip board config files to /boot" ;
			# install boot.cmd, boot.scr, and any other boot.* files
			newins_all "boot.*" ;
			# install joetooEnv.txt and any other (e.g. README.txt) .txt files
			newins_all "*.txt" ;
			newenvd "${FILESDIR}/config_protect-rockchip" "99${PN}" ;;
	esac
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Installed boot config files in /boot/ --"
		case ${board} in
			"bcm2708-rpi-b"|"bcm2709-rpi-2-b"|"bcm2710-rpi-3-b-plus"|"bcm2711-rpi-4-b"|"bcm2712-rpi-5-b" )
				elog "  cmdline.txt -- kernel command line parameters" ;
				elog "  config.txt -- bootloader and overlay configuration options" ;
				elog "  https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md" ;
				elog "  https://www.raspberrypi.org/documentation/configuration/config-txt/README.md" ;;
			"rk3288-tinker-s"|"rk3399-rock-pi-4c-plus"|"rk3399-tinker-2"|"rk3588s-orangepi-5" )
				elog "  boot.scr -- compiled u-boot script (do not modify)." ;
				elog "  boot.cmd -- code from which boot.scr is compiled (do not modify)" ;
				elog "  joetooEnv.txt -- user-configurable u-boot environment variables" ;
				elog "  https://docs.u-boot.org/en/latest/" ;;
		esac
		elog ""
		elog "Thanks for using ${PN}"
	fi
}
