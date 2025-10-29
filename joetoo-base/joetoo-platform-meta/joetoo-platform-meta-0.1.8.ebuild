# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2+

EAPI=8

DESCRIPTION="Baseline platform-specific config files for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm ~amd64 ~arm64 arm amd64 arm64"
RESTRICT="mirror"

IUSE="
	headless plasma gnome
	+grub
	-sbc
	-bcm2712-rpi-cm5-cm5io -bcm2712-rpi-5-b -bcm2711-rpi-cm4-io -bcm2711-rpi-4-b -bcm2710-rpi-3-b-plus
	-bcm2710-rpi-3-b -bcm2709-rpi-2-b -bcm2708-rpi-b
	-rk3288-tinker-s
	-rk3399-rock-pi-4c-plus -rk3399-rock-4se -rk3399-tinker-2
	-rk3588-rock-5b -rk3588-radxa-rock-5b+ -rk3588s-orangepi-5 -rk3588s-orangepi-5b -rk3588s-rock-5c
	-meson-gxl-s905x-libretech-cc-v2 -meson-sm1-s905d3-libretech-cc -meson-g12b-a311d-libretech-cc
	-fsl-imx8mq-phanbell
	-generic-armv6j -generic-armv7a -generic-aarch64
	-generic-amd64
"

#-----[ to-do: add board USE flags for non-sbc systems, such as ]----------------------
#    i7-3xxx[UK] [3537[U]|3770[K]]
#    i7-4xxx[K] [4790[K]]
#    i9-9900K
#    i9-12900HK
#    N100
#    N97
#    etc
#--------------------------------------------------------------------------------------

REQUIRED_USE="
	^^ ( headless plasma gnome )
	sbc? ( ^^ (
		bcm2712-rpi-cm5-cm5io
		bcm2712-rpi-5-b
		bcm2711-rpi-cm4-io
		bcm2711-rpi-4-b
		bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b
		bcm2709-rpi-2-b
		bcm2708-rpi-b
		rk3288-tinker-s
		rk3399-rock-pi-4c-plus
		rk3399-rock-4se
		rk3399-tinker-2
		rk3588-rock-5b
		rk3588-radxa-rock-5b+
		rk3588s-orangepi-5
		rk3588s-orangepi-5b
		rk3588s-rock-5c
		meson-gxl-s905x-libretech-cc-v2
		meson-sm1-s905d3-libretech-cc
		meson-g12b-a311d-libretech-cc
		fsl-imx8mq-phanbell
		generic-armv6j
		generic-armv7a
		generic-aarch64
		generic-amd64
		)
	)
	bcm2712-rpi-cm5-cm5io? ( sbc )
	bcm2712-rpi-5-b? ( sbc )
	bcm2711-rpi-cm4-io? ( sbc )
	bcm2711-rpi-4-b? ( sbc )
	bcm2710-rpi-3-b-plus? ( sbc )
	bcm2710-rpi-3-b? ( sbc )
	bcm2709-rpi-2-b? ( sbc )
	bcm2708-rpi-b? ( sbc )
	rk3288-tinker-s? ( sbc )
	rk3399-rock-pi-4c-plus? ( sbc )
	rk3399-rock-4se? ( sbc )
	rk3399-tinker-2? ( sbc )
	rk3588-rock-5b? ( sbc )
	rk3588-radxa-rock-5b+? ( sbc )
	rk3588s-orangepi-5? ( sbc )
	rk3588s-orangepi-5b? ( sbc )
	rk3588s-rock-5c? ( sbc )
	meson-gxl-s905x-libretech-cc-v2? ( sbc grub )
	meson-sm1-s905d3-libretech-cc? ( sbc grub )
	meson-g12b-a311d-libretech-cc? ( sbc grub )
	fsl-imx8mq-phanbell? ( sbc )
"

S="${WORKDIR}/${PN}"

# (1) do not depend on joetoo-platform-meta (circular)
# (2) leave kernel-sources dependency to sbc-headless-meta
# (3) leave plasma/gnome dependencies to joetoo-common-meta
# (4) just install platform-specific config files

RDEPEND="
	>=joetoo-base/joetoo-per-package-env-0.1.0
	sbc? ( >=dev-lang/rust-bin-1.66.1-r1 )
"

BDEPEND="${RDEPEND}"

pkg_setup() {
	# we need to know which board/platform we are using
	# maker specifies what kernel sources we are using
	einfo "pkg_setup: Assigning board and maker ..."
	if use bcm2712-rpi-cm5-cm5io ; then export board="bcm2712-rpi-cm5-cm5io" ; export maker="raspi"
	elif use bcm2712-rpi-5-b ; then export board="bcm2712-rpi-5-b" ; export maker="raspi"
	elif use bcm2711-rpi-cm4-io ; then export board="bcm2711-rpi-cm4-io" ; export maker="raspi"
	elif use bcm2711-rpi-4-b ; then export board="bcm2711-rpi-4-b" ; export maker="raspi"
	elif use bcm2710-rpi-3-b-plus ; then export board="bcm2710-rpi-3-b-plus" ; export maker="raspi"
	elif use bcm2710-rpi-3-b ; then export board="bcm2710-rpi-3-b" ; export maker="raspi"
	elif use bcm2709-rpi-2-b ; then export board="bcm2709-rpi-2-b" ; export maker="raspi"
	elif use bcm2708-rpi-b ; then export board="bcm2708-rpi-b" ; export maker="raspi"
	elif use rk3288-tinker-s ; then export board="rk3288-tinker-s" ; export maker="rockchip"
	elif use rk3399-rock-pi-4c-plus ; then export board="rk3399-rock-pi-4c-plus" ; export maker="rockchip"
	elif use rk3399-rock-4se ; then export board="rk3399-rock-4se" ; export maker="rockchip"
	elif use rk3399-tinker-2 ; then export board="rk3399-tinker-2" ; export maker="rockchip"
	elif use rk3588-rock-5b ; then export board="rk3588-rock-5b" ; export maker="rockchip"
	elif use rk3588-radxa-rock-5b+ ; then export board="rk3588-radxa-rock-5b+" ; export maker="rockchip"
	elif use rk3588s-orangepi-5 ; then export board="rk3588s-orangepi-5" ; export maker="rockchip"
	elif use rk3588s-orangepi-5b ; then export board="rk3588s-orangepi-5b" ; export maker="rockchip"
	elif use rk3588s-rock-5c ; then export board="rk3588s-rock-5c" ; export maker="rockchip"
	elif use fsl-imx8mq-phanbell ; then export board="fsl-imx8mq-phanbell" ; export maker="nxp"
	elif use meson-gxl-s905x-libretech-cc-v2 ; then export board="meson-gxl-s905x-libretech-cc-v2" ; export maker="amlogic"
	elif use meson-sm1-s905d3-libretech-cc ; then export board="meson-sm1-s905d3-libretech-cc" ; export maker="amlogic"
	elif use meson-g12b-a311d-libretech-cc ; then export board="meson-g12b-a311d-libretech-cc" ; export maker="amlogic"
	elif use generic-armv6j ; then export board="generic-armv6j" ; export maker="raspi" # mimics bcm2708-rpi-b
	elif use generic-armv7a ; then export board="generic-armv7a" ; export maker="raspi" # mimics bcm2709-rpi-2-b
	elif use generic-aarch64 ; then export board="generic-aarch64" ; export maker="raspi" # mimics bcm2712-rpi-5-b
	elif use generic-amd64 ; then export board="generic-amd64" ; export maker="gentoo"
	else export board="" ; export maker=""
	fi
	if ! use sbc ; then
		einfo "USE sbc is NOT selected, implying no sbc/platform USE flag is selected either (generic)"
		export board="generic-amd64" ; export maker="gentoo"
	fi
	elog "pkg_setup complete. board = ${board}; maker = ${maker}"
}

src_install() {
	#-----[ make.conf section ]-----------------------------------------------------------------
	target="/etc/portage/"
	einfo "Installing (ins) files into ${target} ..."
	insinto "${target}"
	# Install both crossbuild and chroot versions of headless/desktop make.conf,
	# and use chroot version as initial make.conf for all platforms
	# Expect dev-sbc/crossbuild-tools to deliberately use the crossbuild version for crossbuilding
	if use headless ; then
		# install headless versions
			newins "${S}/make_conf/make.conf.headless.crossbuild.${board}" "make.conf.crossbuild" || \
			die "failed to install make.conf.crossbuild for headless sbc"
		elog "Installed make.conf.crossbuild for headless sbc"
		newins "${S}/make_conf/make.conf.headless.chroot.${board}" "make.conf.chroot" || \
			die "failed to install make.conf.chroot for headless sbc"
		elog "Installed make.conf.chroot for headless sbc"
		newins "${S}/make_conf/make.conf.headless.chroot.${board}" "make.conf" || \
			die "failed to install make.conf for headless sbc"
		elog "Installed make.conf for headless sbc"
	else
		# install desktop versions
		newins "${S}/make_conf/make.conf.desktop.crossbuild.${board}" "make.conf.crossbuild" || \
			die "failed to install make.conf.crossbuild for desktop sbc"
		elog "Installed make.conf.crossbuild for desktop sbc"
		newins "${S}/make_conf/make.conf.desktop.chroot.${board}" "make.conf.chroot" || \
			die "failed to install make.conf.chroot for desktop sbc"
		elog "Installed make.conf.chroot for desktop sbc"
		newins "${S}/make_conf/make.conf.desktop.chroot.${board}" "make.conf" || \
			die "failed to install make.conf for desktop sbc"
		elog "Installed make.conf for desktop sbc"
	fi
	elog "Done installing (ins) make.conf files into ${target} ..."

	#-----[ package.use section ]--------------------------------------------------------------
	target="/etc/portage/package.use/"
	einfo "Installing (ins) files into ${target} ..."
	insinto "${target}"
	# install the joetoo common USE flag file
	newins "${S}/package_use/package.use.joetoo.80joetoo_common" "80joetoo_common" || \
		die "failed to install ${target}/80joetoo_common"
	# prepare and install the cpu-flags and joetoo platform-specific USE flag file for this platform
	if use sbc ; then
		# install the joetoo 00cpu-flags USE flag file for this platform
		newins "${S}/package_use/package.use.00cpu-flags.${board}" "00cpu-flags" || \
			die "failed to install 00cpu-flags for ${board}"
		elog "Installed ${target}/00cpu-flags for ${board}"
		# prepare and install the board-specific platform package.use file
		einfo "copying 90platform_template to temporary scratch work space T: ${T} ..."
		cp ${S}/package_use/package.use.joetoo.90platform_template ${T}/ || \
			die "failed to copy 90platform_template to $T"
		# edit <BOARD> USE flag settings
		einfo "editing 90platform_template for board: ${board} ..."
		sed -i "s|<BOARD>|${board}|g" ${T}/package.use.joetoo.90platform_template || \
			die "failed to edit board"
		# edit <MAKER> USE flag settings
		einfo "editing 90platform_template for maker: ${maker} ..."
		sed -i "s|<MAKER>|${maker}|g" ${T}/package.use.joetoo.90platform_template || \
			die "failed to edit maker"
		if [[ "${maker}" == "raspi" ]] ; then
			sed -i "s|armbian_kernel|kernel|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit kernel for maker: ${maker}"
		fi
		# edit <GRUB> USE flag settings
		if use grub ; then
			einfo "editing 90platform_template for grub ..."
			sed -i "s|<GRUB>|grub|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit grub"
		else
			einfo "editing 90platform_template for -grub ..."
			sed -i "s|<GRUB>|-grub|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit -grub"
		fi
		# edit <HEADLESS> USE flag settings
		if use headless ; then
			einfo "editing 90platform_template for headless ..."
			sed -i "s|<HEADLESS>|headless|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit headless"
		else
			einfo "editing 90platform_template for -headless ..."
			sed -i "s|<HEADLESS>|-headless|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit -headless"
		fi
		# edit <PLASMA> USE flag settings
		if use plasma ; then
			einfo "editing 90platform_template for plasma ..."
			sed -i "s|<PLASMA>|plasma|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit plasma"
		else
			einfo "editing 90platform_template for -plasma ..."
			sed -i "s|<PLASMA>|-plasma|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit -plasma"
		fi
		# edit <GNOME> USE flag settings
		if use gnome ; then
			einfo "editing 90platform_template for gnome ..."
			sed -i "s|<GNOME>|gnome|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit gnome"
		else
			einfo "editing 90platform_template for -gnome ..."
			sed -i "s|<GNOME>|-gnome|g" ${T}/package.use.joetoo.90platform_template || \
				die "failed to edit -gnome"
		fi
		# now install the platform-specific package.use file
		einfo "Installing platform-specific (${maker} ${board}) package.use file"
		newins "${T}/package.use.joetoo.90platform_template" "90joetoo_${board}" || \
			die "failed to install ${target}/90joetoo_${board}"
		elog "Installed ${target}/90joetoo_${board}"
	else
		# install joetoo's neutered template 00cpu-flags USE flag file for this generic platform
		einfo "Installing amd64 platform 00cpu-flags package.use file"
		newins "${S}/package_use/package.use.00cpu-flags.amd64" "00cpu-flags" || \
			die "failed to install 00cpu-flags for amd64"
		elog "Installed 00cpu-flags for amd64"
		# install the amd64 platform package.use file for this non-sbc platform
		einfo "Installing amd64 platform  package.use file"
		newins "${S}/package_use/package.use.joetoo.91joetoo_amd64" "91joetoo_amd64" || \
			die "failed to install ${target}/91amd64"
		elog "Installed ${target}/91amd64"
	fi
	# install the joetoo plasma USE flag file if needed
	if use plasma ; then
		newins "${S}/package_use/package.use.joetoo.99plasma" "99plasma" || \
			die "failed to install ${target}/99plasma"
		elog "USE plasma set; Installed ${target}/99plasma"
	elif use gnome ; then
		newins "${S}/package_use/package.use.joetoo.99gnome" "99gnome" || \
			die "failed to install ${target}/99gnome"
		elog "USE gnome set; Installed ${target}/99gnome"
	elif use headless ; then
		elog "USE headless set; no ${target}/99xxx use flag file required; nothing installed"
	else
		eerror "invalid USE flags; must specify exactly one of headless, plasma, or gnome"
	fi
	elog "Done installing (ins) files into ${target} ..."

	#-----[ package.accept_keywords section ]--------------------------------------------------
	target="/etc/portage/package.accept_keywords/"
	einfo "Installing (ins) files into ${target} ..."
	insinto "${target}"
	newins "${S}/package_accept_keywords/package.accept_keywords.joetoo" "90joetoo"
	if use plasma ; then
		newins "${S}/package_accept_keywords/package.accept_keywords.plasma" "99plasma" || \
			die "failed to install ${target}/99plasma"
		elog "USE plasma set; Installed ${target}/99plasma"
	elif use gnome ; then
		newins "${S}/package_accept_keywords/package.accept_keywords.gnome" "99gnome" || \
			die "failed to install ${target}/99gnome"
		elog "USE gnome set; Installed ${target}/99gnome"
	elif use headless ; then
		elog "USE headless set; no ${target}/99xxx accept_keywords file required; nothing installed"
	else
		eerror "invalid USE flags; must specify exactly one of headless, plasma, or gnome"
	fi
	elog "Done installing (ins) files into ${target} ..."

	#-----[ binrepos section ]-----------------------------------------------------------------
	target="/etc/portage/binrepos.conf/"
	einfo "Installing (ins) files into ${target} ..."
	insinto "${target}"
	if use sbc; then
		# On platforms that have the same package.use/00cpu-flags make.conf:COMMON_FLAGS,
		# compilation should build code for identical instruction sets (i.e. compatible)
		# so such platforms can share binpkgs and serve them to one another.
		# Here we will name the /etc/portage/binrepos.conf/${binhostconfigfile} that will identify
		# these binhost groups and the url(s) for their repositories.
		# These files are then installed by this ebuild, below
		case $board in
			"bcm2712-rpi-5-b"|"bcm2712-rpi-cm5-cm5io") binhostconfigfile="joetoo_rpi5_binhosts.conf" ;;
			"bcm2711-rpi-4-b"|"bcm2711-rpi-cm4-io") binhostconfigfile="joetoo_rpi4_binhosts.conf" ;;
			"bcm2710-rpi-3-b-plus") binhostconfigfile="joetoo_rpi3_binhosts.conf" ;;
			"bcm2709-rpi-2-b"|"bcm2710-rpi-3-b") binhostconfigfile="joetoo_rpi23A_binhosts.conf" ;;
			"bcm2708-rpi-b") binhostconfigfile="joetoo_rpi1_binhosts.conf" ;;
			"rk3399-rock-pi-4c-plus"|"rk3399-rock-4se"|"rk3399-tinker-2") binhostconfigfile="joetoo_rk3399_binhosts.conf" ;;
			"rk3588-rock-5b"|"rk3588-radxa-rock-5b+"|"rk3588s-orangepi-5"|"rk3588s-orangepi-5b"|"rk3588s-rock-5c") binhostconfigfile="joetoo_rk3588_binhosts.conf" ;;
			# TinkerEdgeT, CoralDev are NXP i.MX8M ; SweetPotato is aml-s905x-cc (both SoCs have cortex-A53; same cpu-flags)
			"fsl-imx8mq-phanbell"|"meson-gxl-s905x-libretech-cc-v2") binhostconfigfile="joetoo_sweetpotato_binhosts.conf" ;;
			"meson-sm1-s905d3-libretech-cc") binhostconfigfile="joetoo_solitude_binhosts.conf" ;;
			"meson-g12b-a311d-libretech-cc") binhostconfigfile="joetoo_alta_binhosts.conf" ;;
			# nothing for tinker-s, yet - I only have one of these (and my tinker-s is retired)
			"rk3288-tinker-s") binhostconfigfile="" ;;
			# for generic-amd64, install neutered alderlake config for now
			"generic-amd64") binhostconfigfile="joetoo_gmki9_alderlake_binhosts.conf" ;;
		esac
		# Now install the ${binhostconfigfile} for this platform
		if [ -z "${binhostconfigfile}" ] ; then
			elog "binhostconfigfile is an empty string [${binhostconfigfile}] (nothing installed)"
		elif [ -e "${S}/binrepos/${binhostconfigfile}" ] ; then
			newins "${S}/binrepos/${binhostconfigfile}" "${binhostconfigfile}" || \
				die "failed to install ${binhostconfigfile}"
			elog "Installed ${target}/${binhostconfigfile}"
		else
			elog "${S}/binrepos/${binhostconfigfile} does not exist (nothing installed)"
		fi
	else
		# nothing, yet
		elog "not an sbc install; no joetoo_X_binhost configured for this context, yet"
	fi
	elog "Done installing (ins) files into ${target} ..."
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "board=${board}"
	einfo "maker=${maker}"
	elog ""
	elog "${P} installed"
	elog "Please report bugs to the maintainer."
	elog ""
	elog "version_history can be found in the ebuild files directory."
	elog " 0.1.0 moves assemble-make-conf tool to ${PN}"
	elog " 0.1.1 updates the USE part of make.conf to add pam"
	elog " 0.1.2 updates make.conf, accept_keywords, package.use, binhosts"
	elog " 0.1.2-r1 installs chroot(live) version of make.conf by default"
	elog " 0.1.3 adds USE nls for some packages, to get gentoo binpkgs"
	elog " 0.1.4 adds rk3399-rock-4se; and starts sbc-to-platform migration"
	elog " 0.1.5 fixes USE for joetoolkit"
	elog " 0.1.6 adds boards to package.use headers"
	elog " 0.1.7 removes reference to deprecated raspberrypi-userland"
	elog " 0.1.8 tweaks package.use/80 and 90"
	elog ""
	elog "Thank you for using ${PN}"
}
