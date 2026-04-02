# API.RDAP Usage Guide

## Overview

API.RDAP provides a PowerShell-native interface to any
[RDAP](https://tools.ietf.org/html/rfc7480) (Registration Data Access Protocol)
server. It replaces ad-hoc `Invoke-RestMethod` calls against RDAP endpoints with
typed cmdlets that return structured objects you can pipeline, filter, and export
without manually parsing JSON.

All cmdlets default to `https://rdap.org` as the upstream server and accept a
`-Server` parameter to target any RFC 7480-compliant endpoint.

---

## Key Features

- **10 cmdlets** covering lookup (Get-*), search (Search-*), and utility (Test-*, Get-RDAPHelp) operations
- **Typed return objects** — `RdapDomain`, `RdapNameserver`, `RdapEntity`, `RdapIpNetwork`, `RdapAutnum`, `RdapHelp`
- **Configurable server** — point any cmdlet at a registry-specific RDAP server
- **Pipeline support** — pipe domain names, handles, or IP ranges through lookup cmdlets
- **RFC compliant** — built against RFC 7480, RFC 7481, RFC 9082, and RFC 9083

---

## Core Functions

| Cmdlet | Description |
| --- | --- |
| `Get-RDAPDomain` | Look up a domain name |
| `Get-RDAPNameserver` | Look up a nameserver by handle |
| `Get-RDAPEntity` | Look up an entity (registrar, registrant) by handle |
| `Get-RDAPIpNetwork` | Look up an IP network by address or CIDR prefix |
| `Get-RDAPAutnum` | Look up an autonomous system number |
| `Search-RDAPDomain` | Search domains by name, NS name, or NS IP |
| `Search-RDAPNameserver` | Search nameservers by name or IP |
| `Search-RDAPEntity` | Search entities by full name or handle |
| `Get-RDAPHelp` | Retrieve server capabilities and conformance data |
| `Test-RDAPObject` | Test whether a domain, entity, IP, or ASN exists (returns bool) |

---

## Complete Workflow Example

```powershell
Import-Module API.RDAP

# 1. Check server capabilities
$help = Get-RDAPHelp
$help.RdapConformance

# 2. Look up a domain
$domain = Get-RDAPDomain -Name 'example.com'
$domain.Name
$domain.Status
$domain.Nameservers

# 3. Look up the registrar entity from the domain result
$registrarHandle = ($domain.Entities | Where-Object { $_.Roles -contains 'registrar' })[0]
Get-RDAPEntity -Handle $registrarHandle.Handle

# 4. Check IP ownership
$network = Get-RDAPIpNetwork -Address '8.8.8.8'
$network.Name
$network.StartAddress
$network.EndAddress

# 5. Look up the ASN for the same network
Get-RDAPAutnum -Asn 15169
```

---

## Pipeline Examples

Bulk domain existence checks from a list:

```powershell
@('example.com', 'iana.org', 'doesnotexist.invalid') |
    ForEach-Object {
        [pscustomobject]@{
            Domain = $_
            Exists = Test-RDAPObject -Type Domain -Handle $_
        }
    }
```

Export domain registration status to CSV:

```powershell
'example.com', 'iana.org' |
    Get-RDAPDomain |
    Select-Object -Property Name, Status, @{ n='Expiry'; e={ $_.Events | Where-Object Action -eq 'expiration' | Select-Object -ExpandProperty Date } } |
    Export-Csv -Path domains.csv -NoTypeInformation
```

Search all domains delegated through a nameserver pattern and collect statuses:

```powershell
$results = Search-RDAPDomain -NsName '*.iana-servers.net'
$results | Select-Object Name, Status
```

---

## Error Handling

All cmdlets throw on HTTP errors so you can catch them with standard PowerShell error handling:

```powershell
try {
    Get-RDAPDomain -Name 'doesnotexist.invalid'
} catch {
    if ($_.Exception.Response.StatusCode -eq 404) {
        Write-Warning 'Domain not found in RDAP registry.'
    } else {
        throw
    }
}
```

Use `Test-RDAPObject` for safe existence checks without try/catch:

```powershell
if (Test-RDAPObject -Type Domain -Handle 'example.com') {
    Get-RDAPDomain -Name 'example.com'
}
```

---

## Best Practices

- **Use `Test-RDAPObject` before bulk lookups** to skip non-existent records and
  avoid exception noise.
- **Cache `Get-RDAPHelp` output** — server capabilities rarely change mid-session.
  Store the result in a variable rather than calling it repeatedly.
- **Prefer registry-specific servers** for authoritative data. For example, use
  `https://rdap.arin.net/registry` for ARIN-managed resources rather than the
  global redirect at `rdap.org`.
- **Inspect `$result.RawResponse`** when you need fields beyond the typed
  properties. Every return object carries the full API response.

---

## Security Considerations

- All requests use HTTPS. Do not override `-Server` with an HTTP endpoint — RDAP over plain HTTP is not compliant and exposes responses to tampering.
- RDAP responses are public registration data. No credentials are sent or stored.
- Rate-limiting is enforced server-side. Space bulk queries appropriately or target multiple registries to avoid throttling.

---

## Troubleshooting

| Symptom | Likely Cause | Resolution |
| --- | --- | --- |
| `404` error on a valid domain | Registry redirects differ from rdap.org | Try registry-specific server via `-Server` |
| Empty `Nameservers` or `Entities` | RDAP server omits optional fields | Check `$result.RawResponse` for raw JSON |
| `Test-RDAPObject` returns `$false` for known domain | TLD RDAP service unreachable | Verify with `Get-RDAPHelp -Server <tld-rdap-url>` |
| `Invoke-RestMethod` timeout | RDAP server slow or unavailable | Retry with `-ErrorAction SilentlyContinue` |

---

## Resources

- [RFC 7480 — HTTP Usage in RDAP](https://tools.ietf.org/html/rfc7480)
- [RFC 9082 — RDAP Query Format](https://tools.ietf.org/html/rfc9082)
- [RFC 9083 — JSON Responses for RDAP](https://tools.ietf.org/html/rfc9083)
- [IANA RDAP Bootstrap Registry](https://data.iana.org/rdap/dns.json)
- [rdap.org — Global RDAP Redirect Service](https://rdap.org)
