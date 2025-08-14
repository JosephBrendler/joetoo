# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Baseline for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm ~amd64 ~arm64 arm amd64 arm64"

# gentoo-kernel and gentoo-sources optional, and only for non-sbc
# grub optional
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
	+script_header_joetoo
	-compareConfigs -Terminal
	-domU
	-samba
	+gentoo-kernel -gentoo-sources
	+grub
	"
# ?? = zero or one of, but not multiple ( gentoo-sources gentoo-kernel )
REQUIRED_USE="
	innercore
	nextcloud? ( lamp )
	lamp? ( ^^ ( mysql mariadb ) )
	^^ ( ntp chrony )
	^^ ( sysklogd syslog-ng )
	^^ ( netifrc networkmanager )
	^^ ( headless plasma gnome )
	compareConfigs? ( Terminal )
	jus? ( script_header_joetoo )
	cloudsync? ( script_header_joetoo )
	"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}/${PN}"

# depend on joetoo-base/joetoo-platform-meta, which will have set up
#   make.conf, package.use, and package.accept_keywords settings
#   that will impact the way many of these dependencies install
RDEPEND="
	>=joetoo-base/joetoo-platform-meta-0.0.1
	>=joetoo-base/per-package-env-0.0.3
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
		gentoo-kernel? (
			sys-kernel/gentoo-kernel[-initramfs(-)]
			sys-kernel/installkernel[-dracut(-)]
		)
		gentoo-sources? (
			sys-kernel/gentoo-sources[symlink(+)]
			sys-kernel/installkernel[-dracut(-)]
		)
		grub? (
			>=sys-boot/grub-2.06
			sys-kernel/installkernel[-dracut(-)]
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
	script_header_joetoo? ( dev-util/script_header_joetoo )
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

BDEPEND="${RDEPEND}"

pkg_setup() {
	# sbc board determination no longer needed here - taken care of in joetoo-base/joetoo-platform-meta
	elog "pkg_setup not required; therefor complete."
}

src_install() {
	# install the basic set of configuration files for joetoo
	for x in $(find ${S} -type f); do
		z=$(echo $x | sed "s|${S}||")
		dn=$(dirname $z)
		bn=$(basename $z)
		insinto "${dn}"
		newins "${x}" "${bn}" || die "failed to install ${bn} in ${dn}"
		elog "Installed ${bn} in ${dn}"
	done

	target="/etc/openvpn/"
		einfo "Installing (sym) files into ${target} ..."
		insinto "${target}"
		dosym /etc/openvpn/openvpnkeys_2024/brendler-local.ovpn /etc/openvpn/local.conf
		dosym /etc/openvpn/openvpnkeys_2024/brendler-remote.ovpn /etc/openvpn/remote.conf
		elog "Done installing (sym) files into ${target} ..."
	target="/etc/"
		einfo "Installing (sym) files into ${target} ..."
		insinto "${target}"
		dosym /etc/chrony/chrony.conf /etc/chrony.conf
		elog "Done installing (sym) files into ${target} ..."
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	elog ""
	elog "${P} installed"
	elog "Please report bugs to the maintainer."
	elog ""
	elog "version_history can be found in the ebuild files directory."
	elog "ver 0.0.1 splits joetoo-meta into ${PN} and joetoo-platform-meta"
	elog ""
	if use gnome; then
		eerror "USE = gnome was specified, but is not implemented yet..."
	fi
	elog ""
	elog "Thank you for using ${PN}"
}
