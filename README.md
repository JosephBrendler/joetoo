# joetoo

`joetoo` is a custom Gentoo Linux ebuild repository containing packages, profiles, metadata, and system-integration components used to build and maintain joetoo systems.

The corresponding upstream source repository is [myUtilities](https://github.com/JosephBrendler/myUtilities).

## Purpose

The repository packages the software and configuration that make up the joetoo environment for installation and management through Gentoo Portage.

joetoo began with substantial support for ARM single-board computers and has expanded into a common platform model covering SBCs and conventional systems across ARM, ARM64, and amd64/x86_64 architectures.

The repository includes packages for:

* system construction and installation
* platform and base-system configuration
* cross-building and QEMU support
* SBC and board-specific support
* kernel building, packaging, installation, and updating
* joetoo system utilities
* Portage and package-management integration
* joetoo meta packages

## Relationship to `myUtilities`

The [myUtilities](https://github.com/JosephBrendler/myUtilities) repository contains the source implementation for much of the software packaged here.

The repositories deliberately use related category/package organization where appropriate:

```text
myUtilities                         joetoo
(source)                            (Gentoo repository)

dev-build/...        ----------->  dev-build/...
dev-sbc/...          ----------->  dev-sbc/...
dev-util/...         ----------->  dev-util/...
joetoo-base/...      ----------->  joetoo-base/...
sys-kernel/...       ----------->  sys-kernel/...
```

`myUtilities` should generally be regarded as the source/implementation side of joetoo, while this repository provides the Gentoo packaging and integration side.

## Platform Architecture

Each joetoo installation has a hardware **board** identity used to resolve the properties needed to build and configure that system.

Historically this identity represented an SBC board directly. The abstraction is retained for conventional systems, where the corresponding hardware platform is effectively the populated motherboard: motherboard, processor/chipset, and other characteristics relevant to system construction.

Accordingly, joetoo retains existing `BOARD` terminology for hardware identification while using **platform** as the broader term for the environment resolved from that identity.

Conceptually:

```text
                       BOARD
             hardware identity / key
                         |
                         v
                platform resolution
                         |
          +--------------+---------------+
          |              |               |
          v              v               v
    architecture       target         profile
          |              |               |
          +--------------+---------------+
                         |
          +--------------+---------------+
          |              |               |
          v              v               v
        QEMU           kernel          build
       support         policy          policy
                         |
                         v
                joetoo installation
```

The architectural goal is to centralize this knowledge so individual packages do not each maintain independent lists or `case` statements for every supported board.

See the [joetoo Platform Architecture](https://github.com/JosephBrendler/myUtilities/blob/master/docs/platform-architecture.md) for the canonical architecture description.

## Repository Organization

### `joetoo-base`

Packages defining or installing common joetoo base-system behavior, platform configuration, and meta-package functionality.

Platform-independent policy should live here, or in common joetoo interfaces, wherever practical.

### `dev-build`

Packages providing joetoo system-building infrastructure.

This includes the packaging used to install and execute the tools that construct Gentoo/joetoo systems.

### `dev-sbc`

Packages for cross-building, QEMU support, SBC integration, status/control facilities, and related board-oriented infrastructure.

The category name reflects the historical origin of these packages; some components now participate in the architecture-independent joetoo platform model.

### `dev-util`

General joetoo utilities installed on target systems.

### `sys-kernel`

Kernel-related packages supporting kernel construction, pre-built/platform-specific kernel images, installation, and update workflows.

### Other Categories

The repository also contains packages and configuration supporting Portage, boot infrastructure, firmware, networking, system utilities, and other facilities required by joetoo installations.

## Platform-Aware Packages

Several joetoo packages need information about the system on which they are operating or the system being constructed.

Rather than adding a new board name independently to every such package, joetoo is moving toward a shared platform interface in which board-specific knowledge is defined once and consumed by packages that require it.

This includes packages concerned with:

* system building
* cross-building
* platform meta packages
* headless/SBC configuration
* status and hardware support
* QEMU integration
* kernel selection and installation
* general joetoo utilities

The objective is that adding a supported board or platform becomes primarily a **platform-definition operation**, rather than a maintenance exercise across numerous unrelated ebuilds.

## Binary Packages

Board identity, CPU architecture, and binary-package compatibility are related but distinct concepts.

Two joetoo systems may use different board identities while still being sufficiently compatible to share binary packages; conversely, systems of the same broad architecture may require different binary-package policies because of CPU features, ABI choices, profiles, USE configuration, or other build characteristics.

Binary-package compatibility is therefore treated as a separate architectural concern rather than being inferred solely from `BOARD`.

See [Binary Package Architecture](https://github.com/JosephBrendler/myUtilities/blob/master/docs/architecture/binpkg-architecture.md).

## Adding a Supported Platform

The long-term platform model is intended to make support for a new board approximately:

```text
identify board
      |
      v
define platform properties
      |
      v
platform resolver exposes common properties
      |
      v
existing joetoo packages consume them
```

Packages should require modification only when the new hardware actually introduces new behavior, not merely because its board name is new.

See [Adding a Platform](https://github.com/JosephBrendler/myUtilities/blob/master/docs/architecture/adding-a-platform.md).

## Documentation

The canonical architecture documentation is maintained with the source infrastructure in `myUtilities`:

[**joetoo Platform Architecture**](https://github.com/JosephBrendler/myUtilities/blob/master/docs/platform-architecture.md)

Detailed topics are maintained under:

```text
myUtilities/docs/architecture/
```

The README in this repository describes joetoo from the Gentoo repository and packaging perspective; the architecture documentation describes the system as a whole.

## Status

joetoo is an actively developed personal Gentoo infrastructure project originally begun in 2014. Some names and package categories reflect its evolution from SBC-specific tooling toward a more general multi-architecture platform-management system.

## Development and AI Assistance

Since 2025, development of this repository is AI-assisted. The human developer may use tools including ChatGPT, GitHub Copilot, Google Gemini, and AI-assisted search for research, discussion, debugging, design review, and suggestions.

AI tools are used in an advisory capacity. No agentic AI system is authorized to independently modify the repository, execute its development workflow, or commit changes.

All changes to this repository are selected, reviewed, tested as appropriate, documented, and committed by a human author. Human authors retain responsibility for the design, implementation, correctness, licensing, and provenance of committed content.

## License

See [LICENSE](LICENSE) and the licensing metadata associated with individual packages.
