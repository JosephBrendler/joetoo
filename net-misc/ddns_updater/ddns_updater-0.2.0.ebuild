# joe brendler (c)  2026-7854
# Distributed under the terms of the MIT License

EAPI=8

DESCRIPTION="custom scripts for client and server side of dynamic dns update process in dual-stack ipv4/ipv6 local net"
HOMEPAGE="https://github.com/JosephBrendler/joetoo"
SRC_URI="https://raw.githubusercontent.com/JosephBrendler/myUtilities/master/${CATEGORY}/${PN}-${PV}.tbz2"

# 20260425 - update: daemon ONLY goes to dnsmasq/SLAAC clients (not vpn)

S="${WORKDIR%/}/${PN}"

LICENSE="MIT"
SLOT="0"
# revert to testing this version
KEYWORDS="~amd64 ~arm ~arm64"

IUSE="+client +ipv4 +ipv6 daemon_4 +daemon_6 +dhcpcd_4 dhcpcd_6 openvpn_4 openvpn_6 wsl_4 wsl_6 server openvpn_status emaint"

REQUIRED_USE="
	^^ ( client server )
	client? (
		|| ( ipv4 ipv6 )
		ipv4? ( || ( daemon_4 dhcpcd_4 openvpn_4 wsl_4 ) )
		ipv6? ( || ( daemon_6 dhcpcd_6 openvpn_6 wsl_6 ) )
		!server !openvpn_status !emaint
	)
	server? (
		|| ( openvpn_status emaint )
		|| ( ipv4 ipv6 )
		!client !daemon_4 !daemon_6 !dhcpcd_4 !dhcpcd_6
		!openvpn_4 !openvpn_6 !wsl_4 !wsl_6
	)
"

RESTRICT="mirror"

RDEPEND="
	server? (
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
	if use client; then elog "USE flag client was selected"; else elog "USE flag client was not selected"; fi
	if use daemon_4; then elog "USE flag daemon_4 was selected"; else elog "USE flag daemon_4 was not selected"; fi
	if use daemon_6; then elog "USE flag daemon_6 was selected"; else elog "USE flag daemon_6 was not selected"; fi
	if use dhcpcd_4; then elog "USE flag dhcpcd_4 was selected"; else elog "USE flag dhcpcd_4 was not selected"; fi
	if use dhcpcd_6; then elog "USE flag dhcpcd_6 was selected"; else elog "USE flag dhcpcd_6 was not selected"; fi
	if use openvpn_4; then elog "USE flag openvpn_4 was selected"; else elog "USE flag openvpn_4 was not selected"; fi
	if use openvpn_6; then elog "USE flag openvpn_6 was selected"; else elog "USE flag openvpn_6 was not selected"; fi
	if use wsl_4; then elog "USE flag wsl_4 was selected"; else elog "USE flag wsl_4 was not selected"; fi
	if use wsl_6; then elog "USE flag wsl_6 was selected"; else elog "USE flag wsl_6 was not selected"; fi
	if use server; then elog "USE flag server was selected"; else elog "USE flag server was not selected"; fi
	if use openvpn_status; then elog "USE flag openvpn_status was selected"; else elog "USE flag openvpn_status was not selected"; fi
	if use emaint; then elog "USE flag emaint was selected"; else elog "USE flag emaint was not selected"; fi
	if use ipv4; then elog "USE flag ipv4 was selected"; else elog "USE flag ipv4 was not selected"; fi
	if use ipv6; then elog "USE flag ipv6 was selected"; else elog "USE flag ipv6 was not selected"; fi

# (**[LEGACY]** - retain code until fully retired)
#  if use direct; then elog "USE flag direct was selected"; else elog "USE flag direct was not selected"; fi

	# gobal: install this for all USE cases but edit to reflect ipv4 and ipv6
	# draft, edit, and install /etc/conf.d/ddns
	# First - copy /etc/conf.d/ddns draft (config_d_ddns) to temp scratch space to edit
	einfo "copying config_d_ddns to temporary scratch work space T: ${T} ..."
	cp "${S}/config_d_ddns" "${T}/" || \
	die "failed to copy config_d_ddns to $T"
	# Next - edit config_d_ddns assignment of BUILD env variable
	einfo "editing config_d_ddns to set BUILD=${PVR} ..."
	NEW_BUILD_STR="${PVR}    # dynamically updated by ebuild"  # note: .* matches any char followed by anything
	sed -i "s|^BUILD=.*|BUILD=${NEW_BUILD_STR}|" "${T}/config_d_ddns" || \
		die "failed to edit config_d_ddns for BUILD"
	# Next - enable ipv4/ipv6 support according to USE flags
	if use ipv4; then
		sed -i 's|^IPV4_SUPPORT=.*|IPV4_SUPPORT=$TRUE|' "${T}/config_d_ddns" || \
			die "failed to edit config_d_ddns for IPV4_SUPPORT"
	else
		sed -i 's|^IPV4_SUPPORT=.*|IPV4_SUPPORT=$FALSE|' "${T}/config_d_ddns" || \
			die "failed to edit config_d_ddns for IPV4_SUPPORT"
	fi
	if use ipv6; then
		sed -i 's|^IPV6_SUPPORT=.*|IPV6_SUPPORT=$TRUE|' "${T}/config_d_ddns" || \
			die "failed to edit config_d_ddns for IPV6_SUPPORT"
	else
		sed -i 's|^IPV6_SUPPORT=.*|IPV6_SUPPORT=$FALSE|' "${T}/config_d_ddns" || \
			die "failed to edit config_d_ddns for IPV6_SUPPORT"
	fi
	# Finally - install the draft as final
	target="/etc/conf.d/"
	einfo "Installing (ins) config_d_ddns as ddns into ${target}"
	insinto "${target}"
	newins "${T}/config_d_ddns" "ddns" || die "failed to install /etc/conf.d/ddns"
	elog "Installed (newexe) ddns into ${target}"

	if use server; then
		# server-specific: only the ddns server gets /server/ddns-update-server,
		#    /server/dhcpcd.conf.router, /server/99-ddns-update-server
		elog "installing for USE flag server"
		# install ddns-update-server to /usr/sbin (client ssh command calls this)
		target="/usr/sbin/"
		einfo "Installing (exe) ddns-update-server into ${target}"
		exeinto "${target}"
		newexe "${S}/server/ddns-update-server" "ddns-update-server" || \
			die "failed to install ddns-update-server"
		elog "Installed (newexe) ddns-update-server into ${target}"

# to do - edit both dhcpcd.conf and 99-ddns-update according to ipv4/ipv6 USE
		# install dhcpcd.conf to /etc/ (this is dns/router version of the .conf)
		target="/etc/"
		einfo "Installing (ins) dhcpcd.conf into ${target}"
		insinto "${target}"
		newins "${S}/server/dhcpcd.conf.router" "dhcpcd.conf" || \
			die "failed to install dhcpcd.conf"
		elog "Installed (newins) dhcpcd.conf into ${target}"

		# install 99-ddns-update to /etc/sudoers.d/ (allows remote connect to run specified commands)
		target="/etc/sudoers.d/"
		einfo "Installing (ins) 99-ddns-update-server into ${target}"
		insinto "${target}"
		newins "${S}/server/99-ddns-update-server" "99-ddns-update-server" || \
			die "failed to install 99-ddns-update"
		elog "Installed (newins) 99-ddns-update-server into ${target}"

		if use openvpn_status; then
			# **[ To Do: REFACTOR openvpn_dns_updater.sh to split off emaint_ddns**
			#  install openvpn_dns_updater.sh to /usr/sbin/
			# (this scrapes /var/log/openvpn-status.log)
			target="/usr/sbin/"
			einfo "Installing (exe) openvpn_dns_updater.sh into ${target}"
			exeinto "${target}"
			newexe "${S}/server/openvpn_dns_updater.sh" "openvpn_dns_updater.sh" || \
				die "failed to install openvpn_dns_updater.sh"
			elog "Installed (newexe) openvpn_dns_updater.sh into ${target}"
		fi
		if use emaint; then
			# **[ To Do: REFACTOR openvpn_dns_updater.sh to split off emaint_ddns**
			#  install openvpn_dns_updater.sh to /usr/sbin/
			# (this scrapes /var/log/openvpn-status.log)
			target="/usr/sbin/"
			einfo "Installing (exe) placeholder for emaint_ddns into ${target}"
			exeinto "${target}"
			echo 'echo "I am just a placeholder"' > "${T}/emaint_ddns"
			cp  "${T}/emaint_ddns"
			newexe "${T}/emaint_ddns" "emaint_ddns" || \
				die "failed to install emaint_ddns"
#			newexe "${S}/server/emaint_ddns" "emaint_ddns" || \
#				die "failed to install emaint_ddns"
			elog "Installed (newexe) openvpn_dns_updater.sh into ${target}"
		fi


	elif use client; then
		# client-common: all clients (vpn and dnsmasq/SLAAC get ddns-update, dhcpcd.conf, and /etc/local.d/99-ula-ndp-fix.start
		elog "installing for USE flag client"

		# install ddns-update to /usr/sbin (this uses ssh to submit update to dns)
		target="/usr/sbin/"
		einfo "Installing (exe) ddns-update into ${target}"
		exeinto "${target}"
		newexe "${S}/client/ddns-update" "ddns-update" || die "failed to install ddns-update"
		elog "Installed (newexe) ddns-update into ${target}"

# to do - edit both dhcpcd.conf and 99-ddns-update according to ipv4/ipv6 USE
		# install dhcpcd.conf.client as /etc/dhcpcd.conf (client version)
		target="/etc/"
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

		# install openrc service ddns and ddns-daemon for both use daemon_4 and daemon_6
		#   because ddns-daemon reads ipv4/6 support requirement from /etc/conf.d/ddns
		if use daemon_4 || use daemon_6; then
			elog "installing for USE flag daemon_4 || daemon_6"
			# install ddns init script as /etc/init.d/ddns (this is the openrc service to run under supervise-daemon)
			target="/etc/init.d/"
			einfo "Installing (exe) ddns into ${target}"
			exeinto "${target}"
			newexe "${S}/client/ddns" "ddns" || die "failed to install ddns init script"
			elog "Installed (newexe) ddns into ${target}"

			# install ddns-daemon to /usr/sbin (this calls ddns-update for ipv6)
			target="/usr/sbin/"
			einfo "Installing (exe) ddns-daemon into ${target}"
			exeinto "${target}"
			newexe "${S}/client/ddns-daemon" "ddns-daemon" || die "failed to install ddns-daemon"
			elog "Installed (newexe) ddns-daemon into ${target}"

		fi
		if use dhcpcd_4; then
			# install 99-ddns-update-hook-ipv4 as /lib/dhcpcd/dhcpcd-hooks/99-ddns-update-ipv4
			# (this calls /usr/sbin/ddns-update for ipv4)
			target="/lib/dhcpcd/dhcpcd-hooks/"
			einfo "Installing (exe) 99-ddns-update-ipv4 into ${target}"
			exeinto "${target}"
			newexe "${S}/client/99-ddns-update-hook-ipv4" "99-ddns-update-ipv4" || die "failed to install 99-ddns-update-ipv4 hook script"
			elog "Installed (newexe) 99-ddns-update-ipv4 hook script into ${target}"
		fi
		if use dhcpcd_6; then
			# install 99-ddns-update-hook-ipv6 as /lib/dhcpcd/dhcpcd-hooks/99-ddns-update-ipv6
			# (this calls /usr/sbin/ddns-update for ipv6)
			target="/lib/dhcpcd/dhcpcd-hooks/"
			einfo "Installing (exe) 99-ddns-update-ipv6 into ${target}"
			exeinto "${target}"
			newexe "${S}/client/99-ddns-update-hook-ipv6" "99-ddns-update-ipv6" || die "failed to install 99-ddns-update-ipv6 hook script"
			elog "Installed (newexe) 99-ddns-update-ipv6 hook script into ${target}"
		fi
		if use openvpn_4 || use openvpn_6; then
			elog "use openvpn_4 and/or openvpn_6 was set but is not yet implemented"
		fi

		if use wsl_4 || use wsl_6; then
			# install files required by either/both use wsl_4 || use wsl_6
			# *.ps1 --> /mnt/c/Scripts/ - Powershell scripts to set up and launch a WSL instance
			target="/mnt/c/Scripts/"
			[ -d "$target" ] || die "wsl use flag set but $target not found"
			einfo "Installing (exe) powershell scripts into ${taraget}"
			exeinto "${target}"
			doexe "${S}/client/ddns-parts-wsl"/*.ps1 || die "failed to install \*.ps1 into ${target}"
			elog "Installed (doexe) \*.ps1 into ${target}"
			# .wslconfig* --> /mnt/c/Users/joebr/ - Windows User config - [wsl2] sets networkingMode=nat
			target="/mnt/c/Users/joebr/"
			[ -d "$target" ] || die "wsl use flag set but $target not found"
			einfo "Installing (ins) .wslconfigs into ${target}"
			insinto "${target}"
			doins "${S}/client/ddns-parts-wsl"/.wslconfig* || \
				die "failed to install .wslconfig\* into ${target}"
			elog "Installed (doins) .wslconfig\* into ${target}"
			# wsl.conf --> /etc/ - [boot] starts openrc; plus [network] & [user]
			target="/etc/"
			einfo "Installing (ins) wsl.conf into ${target}"
			insinto "${target}"
			newins "${S}/client/ddns-parts-wsl/wsl.conf" "wsl.conf" || \
				die "failed to install .wslconfig\* into ${target}"
			elog "Installed (newins) wsl.conf into ${target}"

			# ddns-trigger-wsl* --> /usr/sbin/ - ipv4 and ipv6 trigger scripts
			if use wsl_4; then
				target="/usr/sbin/"
				einfo "Installing (exe) ddns-trigger-wsl-ipv4 into ${taraget}"
				exeinto "${target}"
				newexe "${S}/client/ddns-parts-wsl/ddns-trigger-wsl-ipv4" "ddns-trigger-wsl-ipv4" || \
					die "failed to install ddns-trigger-wsl-ipv4 into ${target}"
				elog "Installed (doexe) ddns-trigger-wsl-ipv4 into ${target}"
			fi
			if use wsl_6; then
				target="/usr/sbin/"
				einfo "Installing (exe) ddns-trigger-wsl-ipv6 into ${taraget}"
				exeinto "${target}"
				newexe "${S}/client/ddns-parts-wsl/ddns-trigger-wsl-ipv6" "ddns-trigger-wsl-ipv6" || \
					die "failed to install ddns-trigger-wsl-ipv6 into ${target}"
				elog "Installed (doexe) ddns-trigger-wsl-ipv6 into ${target}"
			fi
			if use wsl_4 || use wsl_6; then
				# ddns-trigger-wsl.crontab --> /etc/cron.d/ - cron job to trigger ea 5 min
				target="/etc/cron.d/"
				einfo "Installing (ins) ddns-trigger-wsl.crontab into ${target}"
				cp "${S}/client/ddns-parts-wsl/ddns-trigger-wsl.crontab" "${T}/"
				if use wsl4; then
					# enable the cron trigger for ipv4 (edit existing line)
					sed -i 's|ddns-trigger-wsl|ddns-trigger-wsl-ipv4|' "${T}/ddns-trigger-wsl.crontab"
				else
					# comment it out
					sed -i 's|^|#|' "${T}/ddns-trigger-wsl.crontab"
				fi
				if use wsl6; then
					# enable the cron trigger for ipv6 (append a line)
					echo "*/5 * * * * root /usr/sbin/ddns-trigger-wsl-ipv6 wsl-cron" >> "${T}//ddns-trigger-wsl.crontab"
				fi
				insinto "${target}"
				newins "${T}/ddns-trigger-wsl.crontab" "ddns-trigger-wsl.crontab" || \
					die "failed to install ddns-trigger-wsl.crontab into ${target}"
				elog "Installed (newins) ddns-trigger-wsl.crontab into ${target}"
			fi
# to do - 99-ddns-wsl-host-proxy.start, resolvconf.conf.wsl according to ipv4/ipv6 USE
			# 99-ddns-wsl-host-proxy.start --> /etc/local.d/ - .start file (ddns-update on boot)
			target="/usr/sbin/"
			einfo "Installing (exe) ddns-trigger-wsl into ${taraget}"
			exeinto "${target}"
			newexe "${S}/client/ddns-parts-wsl/99-ddns-wsl-host-proxy.start" "99-ddns-wsl-host-proxy.start"   || \
				die "failed to 99-ddns-wsl-host-proxy.start into ${target}"
			elog "Installed (doexe) 99-ddns-wsl-host-proxy.start into ${target}"
			# resolvconf.conf.wsl --> /etc//resolvconf.conf - WSL-specific version to set up resolv.conf
			target="/etc/"
			einfo "Installing (ins) resolvconf.conf into ${target}"
			insinto "${target}"
			newins "${S}/client/ddns-parts-wsl/resolvconf.conf.wsl" "resolvconf.conf" || \
				die "failed to install resolvconf.conf into ${target}"
			elog "Installed (newins) resolvconf.conf into ${target}"

		fi

# to do:
#   - rationalize (assuming client side works) a vpn option as a third client choice (both ipv4 and ipv6)
#   - rationalize (assuming client side works) offering vpn server vs client responsibility for updates
#      (for clients that may be a "if your server runs ... then you don't need..."
# - give server a choice about running openvpn_dns_updater and/or emaint script (when such exists)
#   - develop USE flag dependencies and install logic to implement these choices

	fi  # server/client
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
	elog " 0.1.2-18 provide bugfixes and enhancements"
	elog " 0.2.0 splits -ipv4/6 hooks and triggers, T/F in conf.d/ddns for daemon; adds WSL client support"
	elog ""
	elog "notes:"
	elog "(1) version 0.2.0 splits dual-stack ipv4/6 modules for slaac/dhcp/vpn/WSL environments"
	elog "(2) router must now have /home/<user>/.ssh/id_ddns_update_46.pub (new public key)"
	elog " (a) router must also install sudoers file distributed by ebuild for USE=dns"
	elog " (b) router must also update /home/${user}/.ssh/authorized_keys file for new ssh hey and command"
	elog "  this should resemble:"
	elog "  command=\"/usr/bin/sudo /usr/sbin/ddns-update-server $SSH_ORIGINAL_COMMAND\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-ed25519 <pubkey> joe@brendler-ddns-dualstack"
	elog "(3) client connects to submit update with /home/<user>/.ssh/id_ddns_update_46 (new private key)"
	elog " (a) client sub-USE flags for vpn, direct, daemon are deprecated; all use daemon now"
	elog " (b) client 99-ula-ndp-fix.start insstalled in /etc/local.d/;"
	elog " (c) client must also run sudo rc-update add ddns default"
	elog "    must be executable to run (also fix selected interfaces)"
	elog "Thank you for using ${PN}"
}
