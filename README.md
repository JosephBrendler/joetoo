# joetoo

`joetoo` is a custom Gentoo Linux ebuild repository containing packages, profiles, metadata, and system-integration components used to build and maintain joetoo systems.

The corresponding upstream source repository is [myUtilities](https://github.com/JosephBrendler/myUtilities).

## Purpose

This repository packages the software and configuration that make up the joetoo environment for installation and management through Gentoo Portage.

joetoo began as a simple set of personal Linux utilities but grew and added substantial support for ARM single-board computers and has since expanded into a common platform model covering SBCs and conventional systems across ARM, ARM64, and amd64/x86_64 architectures. As the author(s) capacity to work and interest dictates, this may further evolve through refinement/expansion of existing categories of content or by the addition of new architectures or other categories.

## Contents

* system construction and installation
* platform and base-system configuration
* cross-building and QEMU support
* SBC and non-SBC board-specific support
* kernel building, packaging, installation, and updating
* script headers used to easily source UI assets, core logic functions, and tools
* joetoo system utilities
* Portage and package-management integration
* joetoo meta packages

## Relationship to `myUtilities`

The [myUtilities](https://github.com/JosephBrendler/myUtilities) repository contains the source implementation for most of the software packaged here.

These two repositories deliberately use the same category/package organization where appropriate:

```text
myUtilities                         joetoo
(source)                            (Gentoo repository)

dev-build/...        ----------->  dev-build/...
dev-sbc/...          ----------->  dev-sbc/...
dev-util/...         ----------->  dev-util/...
joetoo-base/...      ----------->  joetoo-base/...
sys-kernel/...       ----------->  sys-kernel/...
```
Note: Some of these categories (e.g. dev-sbc) do not exist in upstream Gentoo profiles, and are only defined in profiles maintained in the joetoo repository

`myUtilities` is the source/implementation side of joetoo, while this repository provides the Gentoo packaging and integration side. Joe Brendler is the original/primary author of both.

## Platform Architecture

Each joetoo installation has a hardware **board** identity used to resolve the properties needed to build and configure that system. dev-sbc/crossbuild-tools and dev-build/joetoobuild-tools packages include tools used to discover this board identity and its properties from existing systems and document that so that their other tools can use that information in the automated build processes they facilitate.

Historically board identity represented an SBC board (and only SBCs) directly by simply adopting the name of the device tree file (*.dtb) describing the board as the board name - e.g. meson-gxl-s905x-libretech-cc-v2 for the Libre Computer AML-S905X-CC V2 (SweetPotato) or bcm2712-rpi-cm5-cm5io for the Raspberry Pi Compute Module 5 Rev 1.0). The **board** abstraction is retained but expanded as applied for conventional x86_64 systems, where the corresponding hardware **platform** is effectively the populated motherboard: motherboard, processor/chipset, and other characteristics relevant to system construction. Because these systems universally support UEFI/BIOS, thus not requiring device tree support, there are no *.dtb files from with to name them.

Accordingly, joetoo retains existing `BOARD` terminology for hardware identification while conceptually using **platform** as the broader term for the environment resolved from that identity, and the board naming format adopted for x86_64 systems reflects this platform information - e.g. dell:skylake:optiplex-7040, mktec:alderlake-n:nucbox-g3, lattepanda:alderlake-n:lattepanda-iota, or even asus:amd-k8-athlon-x2:a8n-sli-premium.

Note: transition ongoing to efolve joetoo from "SBC and generic x86_64" support to the framework described above.

Conceptually, this board name describing the platform via the format <vendor>:<cpu_class>:<board_model> provides a unique description of the platform and its constituent hardware, so that from it the details needed for automated processes area easily known - processes such as -
* dev-build/joetoobuild-tools' jb-mksys (automated interactive initial- or re-build of a matching system from a liveCD/liveUSB start point)
* dev-sbc/crossbuild-tools cb-mkimg (automated interactive crossbuild of an image file that can be deployed to a real physical system, or mounted on the build host to serve as a binary package server for systems of that architecture - e.g. a binhost for Raspberry Pi 5 bcm2712-rpi-5-b arm64/aarch64, hosted on your amd64 development workstation)
* dev-sbc/crossbuild-tools cb-mkupd (automated interactive crossbuild-update of an image file containing a complete system previously built with cb-mkimg or captured with dd from a working systems block device(s)).

This board and platform framework also facilitates the development and maintenance of policies implemented by joetoo ebuilds (determining what software components are required to support the current system running the ebuild to install joetoo packages).  User-control of this process is implemented in USE flags in several joetoo packages, principally joetoo-base/joetoo-platform-meta

One near-term architectural goal for joetoo is the centralization this knowledge described above, so individual packages do not each maintain independent lists or `case` statements for every supported board (as is currently the case in supporting ebuilds).  To that end a joetoo platform eclass is beginning development.

See the [joetoo Platform Architecture](https://github.com/JosephBrendler/myUtilities/blob/master/docs/platform-architecture.md).

## Repository Organization

### `joetoo-base`

Packages defining or installing config files defining platform-specific and common joetoo system configuration policy, features, and functionality.

### `dev-build`

Packages providing joetoo system-building automation infrastructure.

This includes the packaging used to install and execute the tools that construct Gentoo/joetoo systems for supported architectures and platforms.

### `dev-sbc`

Packages for automated interactive cross-building, QEMU support, SBC integration, status/control facilities, and related board-oriented infrastructure.

The category name reflects the historical origin of these packages; some components now participate in the architecture-independent joetoo platform model.

### `dev-util`

General joetoo utilities installed on target systems, including joetoolkit, the script_header_joetoo family, and mkinitramfs (joetoo's automated custom initramfs builder).

### `sys-kernel`

Kernel-related packages supporting kernel construction (including crossbuilding), resulting published pre-built/platform-specific kernel images, installation, and update workflows.

### Other Categories

The repository also contains packages and configuration supporting Portage, boot infrastructure, firmware, networking, system utilities, and other facilities required by or useful in joetoo installations.

## Binary Packages

Board identity, CPU architecture, and binary-package compatibility are related but distinct concepts.

Two joetoo systems may use different board identities while still being sufficiently compatible to share binary packages; conversely, systems of the same broad architecture may require different binary-package policies because of CPU features, ABI choices, profiles, USE configuration, or other build characteristics.

Binary-package compatibility is therefore treated as a separate architectural concern rather than being inferred solely from `BOARD`. For example, `BOARD`is used to deploy standardized values in make.conf's COMMON_FLAGS and package.use/00cpu-flags, and joetoo may be updated to deploy selected binrepos/joetoo-<platform>-binhosts.conf, but the user must ensure those configurations are in fact consistent with binpkg compatibility before adding a new host to an existing -binhosts.conf or enabling a new host to subscribe to existing binhosts by installing an active -binhosts.conf file.

See [Binary Package Architecture](https://github.com/JosephBrendler/myUtilities/blob/master/docs/architecture/binpkg-architecture.md).

## Adding a Supported Platform

The long-term platform model is intended to make support for a new board approximately:

```text
identify boardby using platform resolver to exposes common properties
      |
      v
add board to eclass
      |
      v
update existing joetoo packages to implement policy
(IAW discovered properties for the inherited new board)
```

See [Adding a Platform](https://github.com/JosephBrendler/myUtilities/blob/master/docs/architecture/adding-a-platform.md).

## Documentation

Architecture documentation is maintained with the source infrastructure in `myUtilities`:

[**joetoo Platform Architecture**](https://github.com/JosephBrendler/myUtilities/blob/master/docs/platform-architecture.md)

Detailed topics are maintained under:

```text
myUtilities/docs/architecture/
```

The README in this repository describes joetoo from the Gentoo repository and packaging perspective; the architecture documentation describes the system as a whole.

## Status

joetoo is an actively developed personal Gentoo infrastructure project originally begun in 2014. Some names and package categories reflect its evolution from a simple provider of utilities to the addition of SBC-specific tooling, toward a more general multi-architecture platform-management system.

## Development and AI Policy

joetoo's human developer(s) may use AI tools for research, discussion, debugging, design review, and suggestions.  AI tools may be used in an advisory capacity only. Developers may not authorize any agentic AI system to modify the repository, execute its development workflow, or commit changes.

All changes to this repository are made, reviewed, tested as appropriate, documented in the VCS workflow, and committed by a human developer. The human developer(s) retain responsibility for the design, implementation, correctness, licensing, and provenance of committed content.

## License

See [LICENSE](LICENSE) and the licensing metadata associated with individual packages.
