# joe brendler (c)  2026-7854
# Distributed under the terms of the MIT License

EAPI=8

DESCRIPTION="custom scripts for client and server side of dynamic dns update process in dual-stack ipv4/ipv6 local net"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

S="${WORKDIR%/}/${PN}"

LICENSE="MIT"
SLOT="0"
# revert to testing this version
KEYWORDS="~amd64 ~arm ~arm64"

IUSE="+client daemon direct vpn dns"

REQUIRED_USE="
	^^ ( client dns )
"

RESTRICT="mirror"

RDEPEND="
	dns? (
		>=net-dns/dnsmasq-2.91
		>=net-misc/radvd-2.20
		>=net-dns/getdns-1.7.3
		>=net-dns/unbound-1.23.0-r1
		>=net-vpn/openvpn-2.6.17-r1[openssl]
		>=dev-util/joetoolkit-0.8.4[router]
		)
	>=net-dns/bind-tools-9.18.0-r1
	>=net-dns/openresolv-3.16.5
	>=dev-util/joetoolkit-0.8.4
	>=dev-util/script_header_joetoo-0.6.10
"

BDEPEND="${RDEPEND}"

src_install() {
	# Note: utility script header still installs in /usr/local/sbin
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "T=${T}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	elog "in src_install"
	if use dns; then elog "USE flag dns was selected"; else elog "USE flag dns was not selected"; fi
	if use client; then elog "USE flag client was selected"; else elog "USE flag client was not selected"; fi
# (legacy - retain until fully retired)
#  if use direct; then elog "USE flag direct was selected"; else elog "USE flag direct was not selected"; fi
#  if use daemon; then elog "USE flag daemon was selected"; else elog "USE flag daemon was not selected"; fi
#  if use vpn; then elog "USE flag vpn was selected"; else elog "USE flag vpn was not selected"; fi

	if use dns; then
		elog "installing for USE flag dns"
		# install openvpn_dns_updater.sh to /usr/sbin/
		target="/usr/sbin/"
		einfo "Installing (exe) openvpn_dns_updater.sh into ${target}"
		exeinto "${target}"
		newexe "${S}/dns/openvpn_dns_updater.sh" "openvpn_dns_updater.sh" || die "failed to install openvpn_dns_updater.sh"
		elog "Installed (newexe) openvpn_dns_updater.sh into ${target}"

		# install dhcpcd.conf to /etc/ (this is dns/router version of the .conf)
		target="/etc/"
		einfo "Installing (ins) dhcpcd.conf into ${target}"
		insinto "${target}"
		newins "${S}/dns/dhcpcd.conf.router" "dhcpcd.conf" || die "failed to install dhcpcd.conf"
		elog "Installed (newins) dhcpcd.conf into ${target}"

		# install update-client-host.sh /etc/ddns_update/ (this is the script run by sudo when the ssh
			# user connects and sends "${COMMAND_ARGS} (="${ACTION_IPV6_ADDRESS} ${FQDN} ${INTERFACE} $(timestamp)")
		target="/etc/ddns_update/"
		einfo "Installing (exe) update-client-host.sh into ${target}"
		exeinto "${target}"
		newexe "${S}/dns/update-client-host.sh" "update-client-host.sh" || die "failed to install update-client-host.sh"
		elog "Installed (newexe) update-client-host.sh into ${target}"

		# install 99-ddns-update to /etc/sudoers.d/ (allows remote connect to run specified commands)
		target="/etc/sudoers.d/"
		einfo "Installing (ins) 99-ddns-update into ${target}"
		insinto "${target}"
		newins "${S}/dns/99-ddns-update" "99-ddns-update" || die "failed to install 99-ddns-update"
		elog "Installed (newins) 99-ddns-update into ${target}"
	elif use client; then
		elog "installing for USE flag client"
# note: leaving legacy modes commented out as tracker for what to retire deliberately in future updates
#		if use direct; then
#			elog "installing for USE flag direct (legacy mode)"
#			# install 99-ddns-update-hook as /usr/lib/dhcpcd/dhcpcd-hooks/99-ddns-update-hook (calls /etc/dhcpcd.ddns-update.sh)
#			target="/usr/lib/dhcpcd/dhcpcd-hooks/"
#			einfo "Installing (exe) 99-ddns-update-hook into ${target}"
#			exeinto "${target}"
#			newexe "${S}/client/99-ddns-update-hook" "99-ddns-update-hook" || die "failed to install 99-ddns-update-hook"
#			elog "Installed (newexe) 99-ddns-update-hook into ${target}"
#
#			# install dhcpcd.ddns-update.sh to /etc/ (called by hook, to send update to dns)
#			target="/etc/"
#			einfo "Installing (exe) dhcpcd.ddns-update.sh into ${target}"
#			exeinto "${target}"
#			newexe "${S}/client/dhcpcd.ddns-update.sh" "dhcpcd.ddns-update.sh" || die "failed to install dhcpcd.ddns-update.sh"
#			elog "Installed (newexe) dhcpcd.ddns-update.sh into ${target}"
#
#		elif use daemon; then
		elog "installing for USE flag daemon (new ddns mode)"
		# install ddns init script as /etc/init.d/ddns
		target="/etc/init.d/"
		einfo "Installing (exe) ddns into ${target}"
		exeinto "${target}"
		newexe "${S}/client/ddns" "ddns" || die "failed to install ddns init script"
		elog "Installed (newexe) ddns into ${target}"

		# install ddns-daemon to /usr/sbin
		target="/usr/sbin/"
		einfo "Installing (exe) ddns-daemon into ${target}"
		exeinto "${target}"
		newexe "${S}/client/ddns-daemon" "ddns-daemon" || die "failed to install ddns-daemon"
		elog "Installed (newexe) ddns-daemon into ${target}"

		# install ddns-update to /usr/sbin
		target="/usr/sbin/"
		einfo "Installing (exe) ddns-update into ${target}"
		exeinto "${target}"
		newexe "${S}/client/ddns-update" "ddns-update" || die "failed to install ddns-update"
		elog "Installed (newexe) ddns-update into ${target}"

#		elif use vpn; then
#			elog "installing for USE flag vpn"
#
#		fi  # direct/daemon/vpn

		# for all client cases - install dhcpcd.conf and 99-ula-ndp-fix.start

		# install dhcpcd.conf.client as /etc/dhcpcd.conf (client version)
		einfo "Installing (ins) dhcpcd.conf into ${target}"
		insinto "${target}"
		newins "${S}/client/dhcpcd.conf.client" "dhcpcd.conf" || die "failed to install dhcpcd.conf"
		elog "Installed (newins) dhcpcd.conf into ${target}"

		# install 99-ula-ndp-fix.start to /etc/local.d/; chmod +x (fix selected interfaces)
		target="/etc/local.d/"
		einfo "Installing (exe) 99-ula-ndp-fix.start into ${target}"
		exeinto "${target}"
		newexe "${S}/client/99-ula-ndp-fix.start" "99-ula-ndp-fix.start" || die "failed to install 99-ula-ndp-fix.start"
		elog "Installed (newexe) 99-ula-ndp-fix.start into ${target}"

	fi  # dns/client
	elog "done src_install for ${PN}"
}

pkg_postinst() {
	einfo "S=${S}"
	einfo "D=${D}"
	einfo "T=${T}"
	einfo "CATEGORY=${CATEGORY}"
	einfo "P=${P}"
	einfo "PN=${PN}"
	einfo "PV=${PV}"
	einfo "PVR=${PVR}"
	elog "${P} installed"
	elog "version 0.0.1 is the initial ebuild"
	elog " 0.0.2-11 provide bugfixes and enhancements"
	elog " 0.1.0 introduced dual-stack ipv4/6 for both slaac/openvpn environments"
	elog " 0.1.1 fixes ipv4 for dnsmasq clients and overhauls ever component"
	elog ""
	ewarn "notes:"
	ewarn "(1) version 0.1.0 instroduces dual-stack ipv4/6 for both slaac/openvpn environments"
	ewarn "(2) router must now have /home/joe/.ssh/id_ddns_update_46.pub (new public key)"
	ewarn " (a) router must also install sudoers file distributed by ebuild for USE=dns"
	ewarn " (b) router must also update /home/${user}/.ssh/authorized_keys file for new ssh hey and command"
	elog " (again for log) router must also update /home/${user}/.ssh/authorized_keys file for new ssh hey and command"
	elog "  this should resemble:"
	elog "  command=\"/usr/bin/sudo /usr/sbin/ddns-update-server $SSH_ORIGINAL_COMMAND\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-ed25519 <pubkey> joe@brendler-ddns-dualstack"
	ewarn "(3) client connects to submit update with /home/joe/.ssh/id_ddns_update_46 (new private key)"
	ewarn " (a) client sub-USE flags for vpn, direct, daemon are deprecated; all use daemon now"
	ewarn " (b) client 99-ula-ndp-fix.start insstalled in /etc/local.d/;"
	ewarn " (c) client must also run sudo rc-update add ddns default"
	ewarn "    must be executable to run (also fix selected interfaces)"
	elog "Thank you for using ${PN}"
}
