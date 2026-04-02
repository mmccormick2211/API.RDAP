---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Search-RDAPNameserver
---

# Search-RDAPNameserver

## SYNOPSIS

Searches for nameserver registrations using an RDAP server.

## SYNTAX

### ByName (Default)

```
Search-RDAPNameserver [-Name] <string> [-Server <string>] [<CommonParameters>]
```

### ByIp

```
Search-RDAPNameserver -IpAddress <string> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries an RDAP server for nameserver registration records matching the
specified search criteria.
Supports searching by nameserver name pattern
or IP address.
Wildcards are permitted in name patterns per RFC 9082.

## EXAMPLES

### EXAMPLE 1

Search-RDAPNameserver -Name 'ns*.example.com'

Searches for nameservers matching the pattern ns*.example.com.

### EXAMPLE 2

Search-RDAPNameserver -IpAddress '192.0.2.1'

Searches for nameservers with the given IP address.

## PARAMETERS

### -IpAddress

An IPv4 or IPv6 address associated with the nameserver.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByIp
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

A nameserver LDH name pattern to search for (e.g., "ns*.example.com").

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByName
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Server

The base URL of the RDAP server to query.
Defaults to https://rdap.org.

```yaml
Type: System.String
DefaultValue: https://rdap.org
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### RdapNameserver

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
