# Copyright (c) 2022-2052 Joe Brendler <joe.brendler@gmail.com>
# adapted from work abandoned by sakaki <sakaki@deciban.com>
# ${FILESDIR} populated from /home/joe/firmware-nonfree/debian/config/brcm80211/brcm/brcmfmac434{30,55}*
# (downloaded from HOMEPAGE below with --
# git clone --depth 1 https://github.com/RPi-Distro/firmware-nonfree.git )
# License: GPL v3+
# NO WARRANTY

EAPI=8

KEYWORDS="~arm ~arm64"

DESCRIPTION="Configuration file required for integrated WiFi on RPi3/4"
HOMEPAGE="https://github.com/RPi-Distro/firmware-nonfree"
SRC_URI=""
LICENSE="Broadcom"
SLOT="0"
IUSE="43455-fix"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-kernel/linux-firmware-20190726-r2[43455-fix(-)?]"

# We just bundle the config in files/, since otherwise we'd have to download
# the whole firmware git archive to install...
src_install() {
	insinto "/lib/firmware/brcm"
	newins "${FILESDIR}/brcmfmac43430-sdio.txt-${PV}" brcmfmac43430-sdio.txt
	newins "${FILESDIR}/brcmfmac43430-sdio.raspberrypi-rpi.txt-${PV}" brcmfmac43430-sdio.raspberrypi-rpi.txt
	newins "${FILESDIR}/brcmfmac43455-sdio.txt-${PV}" brcmfmac43455-sdio.txt
	newins "${FILESDIR}/brcmfmac43455-sdio.clm_blob-${PV}" brcmfmac43455-sdio.clm_blob
	if use 43455-fix; then
		newins "${FILESDIR}/brcmfmac43455-sdio.bin-${PV}" brcmfmac43455-sdio.bin
	fi
}
