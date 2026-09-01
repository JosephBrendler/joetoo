# Copyright 2024-2026 Joseph Brendler
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: joetoo_license.eclass
# @MAINTAINER:
# Joseph Brendler <joseph.brendler@gmail.com>
# @BLURB: deploy the joetoo root license and other license(s) applicable to the package

case ${EAPI} in
	8) ;;   # ok
	*) die "EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_JOETOO_LICENSE_ECLASS} ]]; then
	_JOETOO_LICENSE_ECLASS=1

# @FUNCTION: joetoo_license_src_install
# @USAGE:
# @DESCRIPTION: install joetoo license and license(s) applicable to package
joetoo_license_src_install() {
	local target="/usr/share/licenses/${PN}/"
	# install the root license for $PN
		local x="LICENSE"
		einfo "Installing (ins) $x into $target ..."
		insinto "$target"
		newins "${S%/}/${x}" "$x" || die "failed to install $x into $target"
		elog "Installed $x in $target"
		target="/usr/share/licenses/${PN}/LICENSES/"
	# install other licenses applicable to parts of $PN
		for x in $(find "${S%/}/LICENSES/" -maxdepth 1 -mindepth 1 -type f); do
			local y=${x#${S}}   # strip ${S} from the prefix of x
			local bn=${y##*/}   # basename of y
			local dn=${y%/*}    # dirname of y
			einfo "working with y: $y   dn: $dn   bn: $bn"
			einfo "Installing (ins) $y into $target ..."
			insinto "$target"
			newins "${x}" "$bn" || die "failed to install $x into $target"
			elog "Installed $x in $target"
		done
}

EXPORT_FUNCTIONS joetoo_license_src_install

fi
