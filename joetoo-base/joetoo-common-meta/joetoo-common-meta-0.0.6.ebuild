# Copyright 2022-2052 Joe Brendler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Baseline for a joetoo system"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm ~amd64 ~arm64 arm amd64 arm64"

RESTRICT="mirror"

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
	>=joetoo-base/joetoo-per-package-env-0.0.3
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
		>=sys-auth/elogind-255.17
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
	# install the basic set of configuration files for joetoo (joetoo-common-meta tree)
	einfo "Installing (ins) files into file system tree ..."
	for x in $(find ${S} -type f); do
		z=$(echo $x | sed "s|${S}||")
		dn=$(dirname $z)
		bn=$(basename $z)
		insinto "${dn}"
		newins "${x}" "${bn}" || die "failed to install ${bn} in ${dn}"
		elog "Installed ${bn} in ${dn}"
	done
	elog "Done installing (ins) files into file system tree"
	# install symlinks for basic openvpn configs for joetoo
	target="/etc/openvpn/"
		einfo "Installing (sym) files into ${target} ..."
		insinto "${target}"
		dosym /etc/openvpn/openvpnkeys_2024/brendler-local.ovpn /etc/openvpn/local.conf  || die "failed to symlink local.conf"
		elog "Installed symlink ${target%/}/local.conf"
		dosym /etc/openvpn/openvpnkeys_2024/brendler-remote.ovpn /etc/openvpn/remote.conf  || die "failed to symlink remote.conf"
		elog "Installed symlink ${target%/}/remote.conf"
		elog "Done installing (sym) links into ${target}"
	# install symlinks in init.d for openvpn services
	target="/etc/init.d/"
		einfo "Installing (sym) files into ${target} ..."
		insinto "${target}"
		dosym ${target%/}/openvpn ${target%/}/openvpn.local || die "failed to symlink openvpn.local"
		elog "Installed symlink ${target%/}/openvpn.local"
		dosym ${target%/}/openvpn ${target%/}/openvpn.remote || die "failed to symlink openvpn.remote"
		elog "Installed symlink ${target%/}/openvpn.remote"
		elog "Done installing (sym) vpn links into ${target} ..."
	# install symlink in init.d for user services (assume valid users have shell programs named *sh)
	target="/etc/init.d/"
		einfo "Installing (sym) files into ${target} ..."
		insinto "${target}"
		# look for entries in /etc/passwd, the last field of which is the user's shell
		# (most entries end "nologin" or "false"
		#  users will end in an actual shell program path name)
		for username in $(grep 'sh$' /etc/passwd | grep -v '^root' | cut -d':' -f1); do
			dosym ${target%/}/user ${target%/}/user.${username} || \
				die "failed to symlink user.${username}"
			elog "Installed symlink ${target%/}/user.${username}"
		done
		elog "Done installing (sym) user service links into ${target} ..."
	# install symlinks for basic chrony config for joetoo
	target="/etc/"
		einfo "Installing (sym) files into ${target} ..."
		insinto "${target}"
		dosym /etc/chrony/chrony.conf /etc/chrony.conf || die "failed to symlink /etc/chrony.conf"
		elog "Installed symlink /etc/chrony.conf"
		elog "Done installing (sym) links into ${target} ..."
	# install elogind service in boot runlevel if install symlinks for basic chrony config for joetoo
	if [ -z "$( find /etc/runlevels/boot/ -iname 'elogind' )" ] ; then
		target="/etc/runlevels/boot/"
			einfo "Installing (sym) files into ${target} ..."
			insinto "${target}"
			dosym /etc/init.d/elogind ${target%/}/elogind || die "failed to symlink ${target%/}/elogind"
			elog "Installed symlink ${target%/}/elogind"
			elog "Done installing (sym) elogind link into ${target} ..."
	fi
	# if XDG_RUNTIME_DIR is not set in user(s) .bashrc, then append that
	for username in $(grep 'sh$' /etc/passwd | grep -v '^root' | cut -d':' -f1); do
		if [ -z "$(grep XDG_RUNTIME_DIR /home/${username}/.bashrc 2>/dev/null)" ] ; then
			# append to .bashrc
			einfo "XDG_RUNTIME_DIR does not appear to be set in /home/${username}/.bashrc already; fixing ..."
			einfo "appending to .bashrc in temp scratch space"
			cat /home/${username}/.bashrc ${FILESDIR}/XDG_RUNTIME_DIR-setting > ${T}/.bashrc || \
				die "failed to assemble new .bashrc in scratch space"
			target="/home/${username}/"
			einfo "Installing (ins) updated .bashrc into ${target}"
			insinto "${target}"
			newins "${T}/.bashrc" ".bashrc"  || die "failed to install updated .bashrc"
			elog "Done installing (ins) updated .bashrc into ${target}"
		else
			elog "XDG_RUNTIME_DIR appears to be set in /home/${username}/.bashrc already; skipping"
		fi
		einfo "Done handling XDG_RUNTIME_DIR for user ${username}"
	done
	elog "Done handling XDG_RUNTIME_DIR for all users"
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "T=${T}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	einfo "FILESDIR=${FILESDIR}"
	elog ""
	elog "${P} installed"
	elog "Please report bugs to the maintainer."
	elog ""
	elog "version_history can be found in the ebuild files directory."
	elog "ver 0.0.1 splits joetoo-meta into ${PN} and joetoo-platform-meta"
	elog " 0.0.1-r1/2 provide refinements and bugfixes"
	elog " 0.0.2 updates /root/.bashrc and /etc/env.d/99joetoo-common-meta"
	elog " 0.0.3 updates cloudsync.conf; -r1 adds openvpn.remote/local symlinks"
	elog " 0.0.3-r2 adds RESTRICT=\"mirror\""
	elog " 0.0.4 moves README to /etc/portage/package.use/ and updates ebuild"
	elog " 0.0.5 provides refinements and bugfixes"
	elog " 0.0.5-r1 adds support for openrc user services stabled in Gentoo 9/5/25"
	elog " 0.0.6 updates /root/.bashrc"
	elog ""
	if use gnome; then
		eerror "USE = gnome was specified, and this package would pull in dependencies"
		eerror "for that, but that functionality is not implemented yet..."
	fi
	elog ""
	elog "Thank you for using ${PN}"
}
