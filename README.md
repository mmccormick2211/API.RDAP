# API.RDAP

[![Build Status](https://img.shields.io/github/actions/workflow/status/mmccormick2211/API.RDAP/ci.yml?branch=main&logo=github&style=flat-square)](https://github.com/mmccormick2211/API.RDAP/actions/workflows/ci.yml)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/API.RDAP.svg)](https://www.powershellgallery.com/packages/API.RDAP)
[![Downloads](https://img.shields.io/powershellgallery/dt/API.RDAP.svg)](https://www.powershellgallery.com/packages/API.RDAP)
[![License](https://img.shields.io/github/license/mmccormick2211/API.RDAP)](LICENSE)

## About

API.RDAP is a PowerShell 7+ module for querying RDAP (Registration Data Access Protocol)
services using a clean, typed command surface. It supports common lookup and search
operations for domains, nameservers, entities, IP networks, and autonomous system numbers.

## Why API.RDAP?

API.RDAP helps you automate registration and ownership lookups without manually building RDAP URLs or parsing raw JSON for every request.

- Typed return objects for core RDAP entities
- Consistent PowerShell cmdlets for lookup and search operations
- Configurable RDAP server endpoint (defaults to `https://rdap.org`)
- Built-in utility commands for server capability checks and object existence tests

## 🚀 Getting Started

### Prerequisites

**Required:**

- **PowerShell 7.0+**

### Installation

Install the module from the PowerShell Gallery:

```powershell
Install-Module -Name API.RDAP -Scope CurrentUser
```

### Usage

Import the module and use its commands:

```powershell
Import-Module API.RDAP
Get-Command -Module API.RDAP
```

### Quick Examples

Lookup a domain:

```powershell
Get-RDAPDomain -Name 'example.com'
```

Lookup an autonomous system number:

```powershell
Get-RDAPAutnum -Asn 15169
```

Search domains by nameserver name:

```powershell
Search-RDAPDomain -NsName '*.iana.org'
```

Check if an entity handle exists:

```powershell
Test-RDAPObject -Type Entity -Handle 'IANA'
```

Query an alternate RDAP server:

```powershell
Get-RDAPIpNetwork -Address '8.8.8.0/24' -Server 'https://rdap.arin.net/registry'
```

## 📘 Documentation

Comprehensive documentation is available in the [`docs/`](docs/) directory:

- 🚀 **[Getting Started](docs/getting-started.md)** - Practical examples and usage scenarios
- 📘 **[Module Help](docs/)** - Help files for cmdlets and functions

## 🤝 Contributing

Contributions are welcome. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:

- Pull request workflow
- Code style and conventions
- Testing and quality requirements

## ⭐ Support This Project

If this module helps your workflow, consider supporting the project:

- ⭐ Star the repository to show your support
- 🔁 Share it with other PowerShell developers
- 💬 Provide feedback via issues or discussions
- ❤️ Sponsor ongoing development via GitHub Sponsors

---

Built with ❤️ by [mmccormick2211](https://github.com/mmccormick2211)
