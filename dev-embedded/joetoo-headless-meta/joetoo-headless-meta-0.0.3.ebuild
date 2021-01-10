# Copyright 2021-2051 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Baseline packages for a headless server with joetoo"
HOMEPAGE="https://github.com/joetoo"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
IUSE="+innercore +lamp +nextcloud +mkinitramfs"
REQUIRED_USE="
	innercore
	nextcloud? ( lamp )"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=sys-apps/openrc-0.42.1
	>=app-shells/bash-5.0"

# assumes you have the genpi overlay as well as joetoo
RDEPEND="
	${DEPEND}
	innercore? (
		>=app-admin/logrotate-3.15.1
		>=app-admin/sudo-1.8.29-r2
		>=app-admin/sysklogd-2.1.2
		>=app-eselect/eselect-repository-8
		>=app-crypt/gnupg-2.2.19
		>=app-editors/nano-4.6
		>=app-misc/screen-4.7.0
		>=app-portage/eix-0.33.9
		>=app-portage/gentoolkit-0.4.6
		>=app-portage/jus-6.0.4
		>=app-text/tree-1.8.0
		>=dev-libs/elfutils-0.178
		>=dev-vcs/git-2.24.1
		>=net-misc/chrony-3.5-r2
		>=net-misc/cloudsync-2.0.2
		>=net-misc/dhcpcd-8.1.2
		>=net-misc/netifrc-0.5.1
		>=net-misc/ntp-4.2.8
		>=sys-apps/util-linux-2.34-r3
		>=net-analyzer/nmap-7.80
		>=net-analyzer/tcpdump-4.9.3
		>=net-vpn/openvpn-2.4.7-r1
		>=net-wireless/wireless-tools-30_pre9
		>=net-wireless/wpa_supplicant-2.9-r1
		>=sys-apps/file-5.37-r1
		>=sys-apps/mlocate-0.26-r2
		>=sys-apps/rng-tools-6.8
		>=sys-apps/usbutils-012
		>=sys-devel/bc-1.07.1
		>=sys-devel/distcc-3.3.3
		>=sys-fs/dosfstools-4.1
		>=sys-fs/eudev-3.2.9
		>=sys-kernel/linux-firmware-20200619
		>=sys-kernel/linux-headers-5.10
		>=sys-process/cronie-1.5.5
		>=sys-fs/ncdu-1.14.1
		>=sys-power/powertop-2.10
		>=sys-process/htop-2.2.0
		>=sys-process/iotop-0.6
	)
	lamp? (
		>=dev-db/mysql-5.7.27-r1
		>=www-servers/apache-2.4.41
		dev-lang/php:7.3
	)
	nextcloud? (
		>=www-apps/nextcloud-18.0.1[vhosts(-)]
	)
	mkinitramfs? (
		>=sys-apps/busybox-1.32.0[static(-)]
		>=sys-fs/lvm2-2.02.187[udev(-)]
		>=sys-fs/cryptsetup-2.3.2[urandom(+)]
		>=dev-util/mkinitramfs-5.9
	)
"

src_install() {
	# basic framework file to enable / disable USE flags for this package
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${PN}" "${PN}"
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
	elog "joetoo-headless-meta installed"
	elog "version 0.0.1 is preliminary. please report bugs to the maintainer."
	elog ""
	elog "Thank you for using joetoo-headless-meta"
}
