# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2
# Originally inspired (as raspberry-headless-meta) by "genpi64" work done by sakaki, abandoned in 2020

EAPI=8

DESCRIPTION="Baseline for a joetoo system"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
#KEYWORDS="~amd64 ~arm64"
#getting dependency error because jus, cloudsync, mkinitramfs don't have these keywords, just **
# (to do) - make distcc a USE choice? or remove from innercore and let jus choose
#         - different per-package files for headless vs plasma, gnome, etc (or sed -i below)
IUSE="+innercore +headless -plasma -gnome +lamp +nextcloud +mysql -mariadb +mkinitramfs +ntp -chrony +sysklogd -syslog-ng +netifrc -networkmanager +jus +cloudsync +script_header_brendlefly +compareConfigs +Terminal -gentoo_pv_kernel_image -samba -raspberry"

REQUIRED_USE="
	innercore
	nextcloud? ( lamp )
	lamp? ( ^^ ( mysql mariadb ) )
	^^ ( ntp chrony )
	^^ ( sysklogd syslog-ng )
	^^ ( netifrc networkmanager )
	^^ ( headless plasma gnome )
	compareConfigs? ( Terminal )
	jus ( script_header_brendlefly )
	cloudsync ( script_header_brendlefly )
	"
# disable mkinitramfs if raspberry is selected
RESTRICT="
	raspberry? ( mkinitramfs )
	"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0"

RDEPEND="
	${DEPEND}
	innercore? (
		>=app-admin/logrotate-3.15.1
		>=app-admin/sudo-1.8.29-r2
		>=app-eselect/eselect-repository-8
		>=app-crypt/gnupg-2.2.19
		>=app-editors/nano-4.6
		>=app-misc/screen-4.7.0
		>=app-portage/eix-0.33.9
		>=app-portage/gentoolkit-0.4.6
		>=app-text/tree-1.8.0
		>=dev-libs/elfutils-0.178
		>=dev-vcs/git-2.24.1
		>=sys-apps/util-linux-2.34-r3
		>=net-analyzer/nmap-7.80
		>=net-vpn/openvpn-2.4.7-r1
		>=net-wireless/wpa_supplicant-2.9-r1
		>=sys-apps/busybox-1.32.0[-static(-)]
		>=sys-apps/lshw-02.19.2b_p20210121-r3
		>=sys-apps/mlocate-0.26-r2
		>=sys-apps/rng-tools-6.8
		>=sys-apps/usbutils-012
		>=sys-devel/bc-1.07.1
		>=sys-devel/distcc-3.3.3
		>=sys-fs/cryptsetup-2.3.2[urandom(+),openssl(+)]
		>=sys-fs/dosfstools-4.1
		>=sys-fs/lvm2-2.02.187[-udev(-)]
		!raspberry? (
			>=sys-kernel/gentoo-sources-5.15.26
			>=sys-boot/grub-2.06-r1
		)
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
		networkmanager? (
			>=net-misc/networkmanager-1.36.4
		)
	)
	lamp? (
		mysql? ( >=dev-db/mysql-5.7.27-r1 )
		mariadb? ( >=dev-db/mariadb-10.5 )
		>=www-servers/apache-2.4.41
		dev-lang/php
	)
	nextcloud? (
		>=www-apps/nextcloud-18.0.1[vhosts(+),mysql(+)]
	)
	mkinitramfs? (
		dev-util/mkinitramfs
	jus? ( app-portage/jus )
	script_header_brendlefly? ( dev-util/script_header_brendlefly )
	Terminal? ( dev-util/Terminal )
	compareConfigs? ( dev-util/compareConfigs )
	gentoo_pv_kernel_image? ( sys-kernel/gentoo_pv_kernel_image )
	cloudsync? ( net-misc/cloudsync )
	samba? ( >=net-fs/samba-4.15.4-r2 )
	)
"
# To Do: add to above different choices for headless vs desktop, note that this will probably
#   also impact the choice of configuration files that should be installed, below
#   for example, php w/ USE -xpm for headless

src_install() {
	# basic set of configuration files for joetoo
	insinto "/etc/"
		newins "${FILESDIR}/etc_cloudsync-conf_joetoo" "cloudsync.conf"
		newins "${FILESDIR}/etc_crontab_joetoo" "crontab"
		newins "${FILESDIR}/etc_dhcpcd-conf_joetoo" "dhcpcd.conf"
		newins "${FILESDIR}/etc_logrotate-conf_joetoo" "logrotate.conf"
		newins "${FILESDIR}/etc_nanorc_joetoo" "nanorc"
		newins "${FILESDIR}/etc_resolv-conf_joetoo" "resolv.conf"
		newins "${FILESDIR}/etc_rsyncd-conf_joetoo" "rsyncd.conf"
		newins "${FILESDIR}/etc_syslog-conf_joetoo" "syslog.conf"
	insinto "/etc/apache2/"
		newins "${FILESDIR}/etc_apache2_httpd-conf_joetoo" "httpd.conf"
	insinto "/etc/apache2/vhosts.d"
		newins "${FILESDIR}/etc_apache2_00_default_ssl_vhost-conf_joetoo" "00_default_ssl_vhost.conf"
		newins "${FILESDIR}/etc_apache2_00_default_vhost-conf_joetoo" "00_default_vhost.conf"
	insinto "/etc/conf.d/"
		newins "${FILESDIR}/etc_conf-d_apache2_joetoo" "apache2"
		newins "${FILESDIR}/etc_conf-d_distccd_joetoo" "distccd"
		newins "${FILESDIR}/etc_conf-d_net_joetoo" "net"
	insinto "/etc/default/"
		newins "${FILESDIR}/etc_default_grub_joetoo" "grub"
	insinto "/etc/dhcp/"
		newins "${FILESDIR}/etc_dhcp_dhcpd-conf_joetoo" "dhcpd"
	insinto "/etc/distcc/"
		newins "${FILESDIR}/etc_distcc_hosts_joetoo" "hosts"
	insinto "/etc/env.d/"
		newins "${FILESDIR}/etc_env-d_joetoo_joetoo" "joetoo"
	insinto "/etc/grub.d/"
		newins "${FILESDIR}/etc_grub-d_10_linux_joetoo" "10_linux"
		newins "${FILESDIR}/etc_grub-d_20_linux_xen_joetoo" "20_linux_xen"
	insinto "/etc/local.d/"
		newins "${FILESDIR}/etc_local-d_led-start_joetoo" "led.start"
		newins "${FILESDIR}/etc_local-d_vpn-start_joetoo" "vpn.start"
	insinto "/etc/logrotate.d/"
		newins "${FILESDIR}/etc_logrotate-d_admin_msg_joetoo" "admin_msg"
		newins "${FILESDIR}/etc_logrotate-d_apache2_joetoo" "apache2"
		newins "${FILESDIR}/etc_logrotate-d_conntrackd_joetoo" "conntrackd"
		newins "${FILESDIR}/etc_logrotate-d_distcc_joetoo" "distcc"
		newins "${FILESDIR}/etc_logrotate-d_elog-save-summary_joetoo" "elog-save-summary"
		newins "${FILESDIR}/etc_logrotate-d_libvirtd_joetoo" "libvirtd"
		newins "${FILESDIR}/etc_logrotate-d_mysql_joetoo" "mysql"
		newins "${FILESDIR}/etc_logrotate-d_nextcloud_joetoo" "nextcloud"
		newins "${FILESDIR}/etc_logrotate-d_openrc_joetoo" "openrc"
		newins "${FILESDIR}/etc_logrotate-d_php-fpm.logrotate_joetoo" "php-fpm.logrotate"
		newins "${FILESDIR}/etc_logrotate-d_portage_joetoo" "portage"
		newins "${FILESDIR}/etc_logrotate-d_rkhunter_joetoo" "rkhunter"
		newins "${FILESDIR}/etc_logrotate-d_rsyncd_joetoo" "rsyncd"
		newins "${FILESDIR}/etc_logrotate-d_sysklogd_joetoo" "sysklogd"
	insinto "/etc/openvpn/openvpnkeys/"
		newins "${FILESDIR}/etc_openvpn_openvpnkeys_brendler-local-ovpn_joetoo" "brendler-local.ovpn"
		newins "${FILESDIR}/etc_openvpn_openvpnkeys_brendler-remote-ovpn_joetoo" "brendler-remote.ovpn"
	insinto "/etc/portage/env"
		newins "${FILESDIR}/etc_portage_env_gold.conf_joetoo" "gold.conf"
		newins "${FILESDIR}/etc_portage_env_j1_makeopts.conf_joetoo" "j1_makeopts.conf"
		newins "${FILESDIR}/etc_portage_env_j4_makeopts.conf_joetoo" "j4_makeopts.conf"
		newins "${FILESDIR}/etc_portage_env_no_collision-protect.conf_joetoo" "no_collision-protect.conf"
		newins "${FILESDIR}/etc_portage_env_nodist_features.conf_joetoo" "nodist_features.conf"
		newins "${FILESDIR}/etc_portage_env_perl-5.26-always-dot_joetoo" "perl-5.26-always-dot"
		newins "${FILESDIR}/etc_portage_env_perl-5.26-unsafe-inc_joetoo" "perl-5.26-unsafe-inc"
		newins "${FILESDIR}/etc_portage_env_safe-cflags.conf_joetoo" "safe-cflags.conf"
		newins "${FILESDIR}/etc_portage_env_serialize-make.conf_joetoo" "serialize-make.conf"
		newins "${FILESDIR}/etc_portage_env_suppress-distcc.conf_joetoo" "suppress-distcc.conf"
		newins "${FILESDIR}/etc_portage_env_suppress-distcc-pump.conf_joetoo" "suppress-distcc-pump.conf"
	insinto "/etc/portage/package.env/"
		newins "${FILESDIR}/etc_portage_package.env_joetoo" "package.env"
	insinto "/etc/portage/package.use/"
		newins "${FILESDIR}/etc_portage_package.use_joetoo" "joetoo"
		newins "${FILESDIR}/etc_portage_package.use_00cpu_flags" "00cpu_flags"
	insinto "/etc/portage/package.accept_keywords/"
		if use raspberry; then
			newins "${FILESDIR}/etc_portage_package.accept_keywords_joetoo_arm64" "joetoo"
		else
			newins "${FILESDIR}/etc_portage_package.accept_keywords_joetoo" "joetoo"
		fi
	insinto "/etc/portage/repos.conf/"
		newins "${FILESDIR}/etc_portage_repos-conf_gentoo-conf_joetoo" "gentoo.conf"
	insinto "/etc/rsync/"
		newins "${FILESDIR}/etc_rsync_rsyncd-motd_joetoo" "rsyncd.motd"
	insinto "/etc/ssh/"
		newins "${FILESDIR}/etc_ssh_sshd_banner_joetoo" "sshd_banner"
	insinto "/etc/ssh/ssh_config.d/"
		newins "${FILESDIR}/etc_ssh_ssh_config_joetoo" "01_joetoo_ssh_config"
	insinto "/etc/ssh/sshd_config.d/"
		newins "${FILESDIR}/etc_ssh_sshd_config_joetoo" "01_joetoo_sshd_config"
	insinto "/etc/wpa_supplicant/"
		newins "${FILESDIR}/etc_wpa_supplicant_wpa_supplicant-conf_joetoo" "wpa_supplicant.conf"
	insinto "/var/db/repos/joetoo/profiles/"
		newins "${FILESDIR}/var_db_repos_joetoo_profiles_categories" "categories"
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "RDEPEND=${RDEPEND}"
	einfo "DEPEND=${DEPEND}"
	elog ""
	elog "joetoo-meta installed"
	elog "This version is preliminary. Please report bugs to the maintainer."
	elog ""
	elog "Note that install phase will fail if config files (such as resolv.conf) have immutable"
	elog "attribute set. If this is so, run as root, for example: chattr -i /etc/resolv.conf"
	elog "and then run again with +i after install"
	elog ""
	elog "Thank you for using joetoo-meta"
}