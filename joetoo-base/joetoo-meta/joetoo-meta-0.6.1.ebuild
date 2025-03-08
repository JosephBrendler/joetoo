# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Baseline for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
#KEYWORDS="~arm ~amd64 ~arm64"
#getting dependency error because jus, cloudsync, mkinitramfs don't have these keywords, just **
# Note: ver 0.6.0 moved per-package-env files to a separate package
# Note: ver 0.6.1 makes distcc a USE choice (default yes)

IUSE="
	+innercore
	+joetoolkit
	+headless -plasma -gnome
	-lamp -nextcloud -mysql -mariadb
	+cloudsync
	+distcc
	+mkinitramfs +jus
	+netifrc -networkmanager
	-ntp +chrony
	+sysklogd -syslog-ng
	+script_header_brendlefly
	-compareConfigs -Terminal
	-domU
	-samba
	-sbc
	-bcm2712-rpi-5-b -bcm2711-rpi-4-b -bcm2710-rpi-3-b-plus
	-bcm2710-rpi-3-b -bcm2709-rpi-2-b -bcm2708-rpi-b
	-rk3288-tinker-s
	-rk3399-rock-pi-4c-plus -rk3399-tinker-2 -rk3588s-orangepi-5 -rk3588s-rock-5c
	"

REQUIRED_USE="
	innercore
	nextcloud? ( lamp )
	lamp? ( ^^ ( mysql mariadb ) )
	sbc? ( ^^ (
		bcm2712-rpi-5-b
		bcm2711-rpi-4-b
		bcm2710-rpi-3-b-plus
		bcm2710-rpi-3-b
		bcm2709-rpi-2-b
		bcm2708-rpi-b
		rk3288-tinker-s
		rk3399-rock-pi-4c-plus
		rk3399-tinker-2
		rk3588s-orangepi-5
		rk3588s-rock-5c
		)
	)
	^^ ( ntp chrony )
	^^ ( sysklogd syslog-ng )
	^^ ( netifrc networkmanager )
	^^ ( headless plasma gnome )
	compareConfigs? ( Terminal )
	jus ( script_header_brendlefly )
	cloudsync ( script_header_brendlefly )
	"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND="
	>=joetoo-base/joetoo-per-package-env-0.0.1
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0
	innercore? (
		>=app-admin/eselect-1.4.26
		>=app-admin/logrotate-3.15.1
		>=app-admin/sudo-1.8.29-r2
		>=app-eselect/eselect-python-20200719
		>=app-eselect/eselect-repository-8
		>=app-crypt/gnupg-2.2.19
		>=app-editors/nano-4.6
		>=app-misc/screen-4.7.0
		>=app-portage/eix-0.33.9
		>=app-portage/gentoolkit-0.4.6
		>=app-shells/bash-completion-2.14.0
		>=app-text/tree-1.8.0
		>=app-text/wgetpaste-2.33-r3[ssl(+)]
		>=dev-libs/elfutils-0.178
		>=dev-vcs/git-2.24.1
		>=sys-apps/util-linux-2.34-r3
		>=net-analyzer/nmap-7.80
		>=net-vpn/openvpn-2.4.7-r1
		>=net-wireless/wpa_supplicant-2.8
		>=sys-apps/busybox-1.32.0[-static(-)]
		>=sys-apps/lshw-02.19.2b_p20210121-r3
		>=sys-apps/mlocate-0.26-r2
		>=sys-apps/rng-tools-6.8
		>=sys-apps/usbutils-012
		>=sys-devel/bc-1.07.1
		>=sys-fs/cryptsetup-2.3.2[urandom(+),openssl(+)]
		>=sys-fs/dosfstools-4.1
		>=sys-fs/lvm2-2.02.187[-udev(-)]
		sbc? ( >=dev-lang/rust-bin-1.66.1-r1 )
		!sbc? (
			>=sys-kernel/gentoo-sources-5.15.26
			>=sys-boot/grub-2.06-r1
		)
		>=sys-kernel/installkernel-48-r1
		>=sys-kernel/linux-firmware-20200619
		>=sys-kernel/linux-headers-5.4
		>=sys-process/cronie-1.5.5
		sysklogd? ( >=app-admin/sysklogd-2.1.2 )
		syslog-ng? ( >=app-admin/syslog-ng-3.36 )
		ntp? ( >=net-misc/ntp-4.2.8 )
		chrony? ( >=net-misc/chrony-3.5-r2 )
		netifrc? (
			>=net-misc/netifrc-0.7.3
			>=net-misc/dhcpcd-9.4.0
		)
		networkmanager? ( >=net-misc/networkmanager-1.36.4 )
	)
	lamp? (
		mysql? ( >=dev-db/mysql-5.7.27-r1 )
		mariadb? ( >=dev-db/mariadb-10.5 )
		>=www-servers/apache-2.4.41
		dev-lang/php
	)
	joetoolkit? ( >=dev-util/joetoolkit-0.4.13 )
	nextcloud? (
		>=www-apps/nextcloud-18.0.1[vhosts(+),mysql(+)]
	)
	distcc? ( >=sys-devel/distcc-3.3.3 )
	mkinitramfs? ( >=dev-util/mkinitramfs-6.5 )
	jus? ( >=app-portage/jus-6.2.5 )
	script_header_brendlefly? ( >=dev-util/script_header_brendlefly-0.3.7 )
	Terminal? ( >=dev-util/Terminal-0.1.0 )
	compareConfigs? ( >=dev-util/compareConfigs-0.1.0 )
	domU? ( sys-kernel/linux-domU_joetoo_kernelimage )
	cloudsync? ( >=net-misc/cloudsync-2.1 )
	samba? ( >=net-fs/samba-4.15.4-r2 )
	plasma? (
		app-misc/wayland-utils
		kde-apps/kde-apps-meta
		kde-apps/kwalletmanager
		kde-plasma/kwallet-pam
		kde-plasma/plasma-meta
		lxde-base/lxterminal
		media-fonts/corefonts
		media-fonts/croscorefonts
		media-fonts/liberation-fonts
		media-fonts/terminus-font
		media-fonts/ubuntu-font-family
		nextcloud? ( net-misc/nextcloud-client )
		x11-apps/mesa-progs
		x11-apps/xdpyinfo
		x11-apps/xrandr
		x11-base/xorg-fonts
		x11-base/xorg-server
		x11-libs/libxcb
		x11-misc/xdotool
	)
"

DEPEND="${RDEPEND}"

pkg_setup() {
	# for sbc systems we need to know which board we are using
	if use sbc ; then
		einfo "USE sbc is selected. Assigning board ..." ;
		if use bcm2712-rpi-5-b ; then
			export board="bcm2712-rpi-5-b"
		else if use bcm2711-rpi-4-b ; then
			export board="bcm2711-rpi-4-b"
		else if use bcm2710-rpi-3-b-plus ; then
			export board="bcm2710-rpi-3-b-plus"
		else if use bcm2710-rpi-3-b ; then
			export board="bcm2710-rpi-3-b"
		else if use bcm2709-rpi-2-b ; then
			export board="bcm2709-rpi-2-b"
		else if use bcm2708-rpi-b ; then
			export board="bcm2708-rpi-b"
		else if use rk3288-tinker-s ; then
			export board="rk3288-tinker-s"
		else if use rk3399-rock-pi-4c-plus ; then
			export board="rk3399-rock-pi-4c-plus"
		else if use rk3399-tinker-2 ; then
			export board="rk3399-tinker-2"
		else if use rk3588s-orangepi-5 ; then
			export board="rk3588s-orangepi-5"
		else if use rk3588s-rock-5c ; then
			export board="rk3588s-rock-5c"
		fi; fi; fi; fi; fi; fi; fi; fi; fi; fi; fi
	else
		einfo "USE sbc is NOT selected"
		export board=""
	fi
	elog "pkg_setup complete. board = ${board}"
}

src_install() {
	# basic set of configuration files for joetoo
	target="/etc/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_cloudsync-conf_joetoo" "cloudsync.conf"
		newins "${FILESDIR}/etc_crontab_joetoo" "crontab"
		newins "${FILESDIR}/etc_dhcpcd-conf_joetoo" "dhcpcd.conf"
		newins "${FILESDIR}/etc_logrotate-conf_joetoo" "logrotate.conf"
		newins "${FILESDIR}/etc_nanorc_joetoo" "nanorc"
		newins "${FILESDIR}/etc_resolv-conf_joetoo" "resolv.conf"
		newins "${FILESDIR}/etc_rsyncd-conf_joetoo" "rsyncd.conf"
		newins "${FILESDIR}/etc_syslog-conf_joetoo" "syslog.conf"
		newins "${FILESDIR}/etc_wgetpaste-conf_joetoo" "wgetpaste.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/apache2/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_apache2_httpd-conf_joetoo" "httpd.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/apache2/vhosts.d"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_apache2_00_default_ssl_vhost-conf_joetoo" "00_default_ssl_vhost.conf"
		newins "${FILESDIR}/etc_apache2_00_default_vhost-conf_joetoo" "00_default_vhost.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/chrony/"
		einfo "Installing (ins) files into ${target} ..."
		# note: /etc/chrony.conf is an upstream symlink to /etc/chrony/chrony.conf
		insinto "${target}"
		newins "${FILESDIR}/etc_chrony_chrony-conf_joetoo" "chrony.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/conf.d/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_conf-d_apache2_joetoo" "apache2"
		newins "${FILESDIR}/etc_conf-d_ntp-client_joetoo" "ntp-client"
		newins "${FILESDIR}/etc_conf-d_net_joetoo" "net"
		if use distcc ; then
			newins "${FILESDIR}/etc_conf-d_distccd_joetoo" "distccd"
			elog "Done installing (ins) files into ${target} ..."
		else
			elog "USE distcc not selected; /etc/conf.d/distccd not installed"
		fi
	target="/etc/default/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_default_grub_joetoo" "grub"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/dhcp/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_dhcp_dhcpd-conf_joetoo" "dhcpd"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/distcc/"
		if use distcc ; then
			einfo "Installing (ins) files into ${target} ..."
			insinto "${target}"
			newins "${FILESDIR}/etc_distcc_hosts_joetoo" "hosts"
			elog "Done installing (ins) files into ${target} ..."
		else
			elog "USE distcc not selected; /etc/distcc/hosts not installed"
		fi
	target="/etc/eixrc/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_eixrc_00-eixrc_joetoo" "00-eixrc"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/env.d/"
		einfo "Installing (envd) files into ${target} ..."
		insinto "${target}"
		newenvd "${FILESDIR}/etc_env-d_joetoo_joetoo" "joetoo"
		newenvd "${FILESDIR}/etc_env.d_joetoo" 99${PN}
		elog "Done installing (envd) files into ${target} ..."
	target="/etc/grub.d/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_grub-d_10_linux_joetoo" "10_linux"
		newins "${FILESDIR}/etc_grub-d_20_linux_xen_joetoo" "20_linux_xen"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/init.d/"
		einfo "Installing (sym) files into ${target} ..."
		insinto "${target}"
		dosym /etc/init.d/openvpn /etc/init.d/openvpn.remote
		dosym /etc/init.d/openvpn /etc/init.d/openvpn.local
		elog "Done installing (sym) files into ${target} ..."
	target="/etc/local.d/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_local-d_led-start_joetoo" "led.start"
		newins "${FILESDIR}/etc_local-d_vpn-start_joetoo" "vpn.start"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/logrotate.d/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_logrotate-d_admin_msg_joetoo" "admin_msg"
		newins "${FILESDIR}/etc_logrotate-d_apache2_joetoo" "apache2"
		newins "${FILESDIR}/etc_logrotate-d_conntrackd_joetoo" "conntrackd"
		newins "${FILESDIR}/etc_logrotate-d_cron_joetoo" "cron"
		newins "${FILESDIR}/etc_logrotate-d_elog-save-summary_joetoo" "elog-save-summary"
		newins "${FILESDIR}/etc_logrotate-d_libvirtd_joetoo" "libvirtd"
		newins "${FILESDIR}/etc_logrotate-d_mysql_joetoo" "mysql"
		newins "${FILESDIR}/etc_logrotate-d_nextcloud_joetoo" "nextcloud"
		newins "${FILESDIR}/etc_logrotate-d_openrc_joetoo" "openrc"
		newins "${FILESDIR}/etc_logrotate-d_openvpn_joetoo" "openvpn"
		newins "${FILESDIR}/etc_logrotate-d_php-fpm.logrotate_joetoo" "php-fpm.logrotate"
		newins "${FILESDIR}/etc_logrotate-d_portage_joetoo" "portage"
		newins "${FILESDIR}/etc_logrotate-d_rkhunter_joetoo" "rkhunter"
		newins "${FILESDIR}/etc_logrotate-d_rsyncd_joetoo" "rsyncd"
		newins "${FILESDIR}/etc_logrotate-d_sysklogd_joetoo" "sysklogd"
		if use distcc ; then
			newins "${FILESDIR}/etc_logrotate-d_distcc_joetoo" "distcc"
		else
			elog "USE distcc not selected; /etc/logrotate.d/distcc not installed"
		fi
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/openvpn/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_openvpn_server.conf_joetoo" "server.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/openvpn/openvpnkeys_2024/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_openvpn_openvpnkeys_brendler-local-ovpn_joetoo" "brendler-local.ovpn"
		newins "${FILESDIR}/etc_openvpn_openvpnkeys_brendler-remote-ovpn_joetoo" "brendler-remote.ovpn"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/portage/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		if use sbc ; then
			newins "${FILESDIR}/etc_portage_make_conf_joetoo_${board}" "make.conf"
		else
			newins "${FILESDIR}/etc_portage_make_conf_joetoo_amd64" "make.conf"
		fi
		elog "Done installing (ins) files into ${target} ..."
# Note targets "/etc/portage/env" and "/etc/portage/package.env/"
#   have been moved to separate package joetoo-base/joetoo-per-package-env 6 Mar 2025
	target="/etc/portage/package.use/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_portage_package.use_joetoo" "joetoo"
		if use sbc ; then
			newins "${FILESDIR}/etc_portage_package.use_00cpu_flags_${board}" "00cpu_flags"
		else
			newins "${FILESDIR}/etc_portage_package.use_00cpu_flags_amd64" "00cpu_flags"
		fi
		if use plasma ; then
			newins "${FILESDIR}/etc_portage_package.use_plasma" "plasma"
		fi
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/portage/package.accept_keywords/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		if use sbc ; then
			case $board in
				"bcm2712-rpi-5-b"|"bcm2711-rpi-4-b"|"bcm2710-rpi-3-b-plus"|"rk3399-rock-pi-4c-plus"|"rk3399-tinker-2"|"rk3588s-orangepi-5"|"rk3588s-rock-5c")
					# arch=arm64
					newins "${FILESDIR}/etc_portage_package.accept_keywords_joetoo_arm64" "joetoo" ;;
				"bcm2708-rpi-b"|"bcm2709-rpi-2-b"|"bcm2710-rpi-3-b"|"rk3288-tinker-s")
					# arch=arm
					newins "${FILESDIR}/etc_portage_package.accept_keywords_joetoo_arm" "joetoo" ;;
			esac
		else
			# arch=amd64
			newins "${FILESDIR}/etc_portage_package.accept_keywords_joetoo" "joetoo"
		fi
		if use plasma ; then
			if use sbc ; then
				case $board in
					"bcm2712-rpi-5-b"|"bcm2711-rpi-4-b"|"bcm2710-rpi-3-b-plus"|"rk3399-rock-pi-4c-plus"|"rk3399-tinker-2"|"rk3588s-orangepi-5"|"rk3588s-rock-5c")
						# arch=arm64
						newins "${FILESDIR}/etc_portage_package.accept_keywords_plasma_arm64" "plasma" ;;
					"bcm2708-rpi-b"|"bcm2709-rpi-2-b"|"bcm2710-rpi-3-b"|"rk3288-tinker-s")
						# arch=arm
						newins "${FILESDIR}/etc_portage_package.accept_keywords_plasma_arm" "plasma" ;;
				esac
			else
				# arch=amd64
				newins "${FILESDIR}/etc_portage_package.accept_keywords_plasma" "plasma"
			fi
		fi
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/portage/binrepos.conf/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		if use sbc; then
			case $board in
				"bcm2712-rpi-5-b")
					newins "${FILESDIR}/etc_portage_binrepos_conf-rpi5_binhosts_conf_joetoo" "joetoo_rpi5_binhosts.conf" ;;
				"bcm2711-rpi-4-b")
					newins "${FILESDIR}/etc_portage_binrepos_conf-rpi4_binhosts_conf_joetoo" "joetoo_rpi4_binhosts.conf" ;;
				"bcm2710-rpi-3-b-plus")
					newins "${FILESDIR}/etc_portage_binrepos_conf-rpi3_binhosts_conf_joetoo" "joetoo_rpi3_binhosts.conf" ;;
				"bcm2709-rpi-2-b")
					newins "${FILESDIR}/etc_portage_binrepos_conf-rpi2_binhosts_conf_joetoo" "joetoo_rpi2_binhosts.conf" ;;
				"bcm2710-rpi-3-b"|"bcm2708-rpi-b"|"rk3399-rock-pi-4c-plus"|"rk3288-tinker-s"|"rk3399-tinker-2"|"rk3588s-orangepi-5"|"rk3588s-rock-5c")
					# nothing, yet - I only have one of each of these
					;;
			esac
		else
			# nothing, yet
			einfo "not an sbc install, no binhost configured for joetoo, yet"
		fi
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/portage/repos.conf/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_portage_repos-conf_gentoo-conf_joetoo" "gentoo.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/rsync/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_rsync_rsyncd-motd_joetoo" "rsyncd.motd"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/ssh/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_ssh_sshd_banner_joetoo" "sshd_banner"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/ssh/ssh_config.d/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_ssh_ssh_config_joetoo" "01_joetoo_ssh_config.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/ssh/sshd_config.d/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_ssh_sshd_config_joetoo" "01_joetoo_sshd_config.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/ssl/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_ssl_openssl-conf_joetoo" "openssl.cnf"
		elog "Done installing (ins) files into ${target} ..."
	target="/etc/wpa_supplicant/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/etc_wpa_supplicant_wpa_supplicant-conf_joetoo" "wpa_supplicant.conf"
		elog "Done installing (ins) files into ${target} ..."
	target="/var/db/repos/joetoo/profiles/"
		einfo "Installing (ins) files into ${target} ..."
		insinto "${target}"
		newins "${FILESDIR}/var_db_repos_joetoo_profiles_categories" "categories"
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
	elog ""
	elog "${P} installed"
	elog "Please report bugs to the maintainer."
	elog ""
	elog "version_history can be found in the ebuild files directory."
	elog " 0.6.0 moves per-package configs to joetoo-base/joetoo-per-package-env"
	elog " 0.6.1 makes distcc an optional USE choice vs part of innercore"
	elog ""
	if use gnome; then
		ewarn "USE = gnome was specified, but is not implemented yet..."
		elog "USE = gnome was specified, but is not implemented yet..."
		elog ""
	fi
	elog ""
	elog "Thank you for using ${PN}"
}
