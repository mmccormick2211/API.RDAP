---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Get-RDAPIpNetwork
---

# Get-RDAPIpNetwork

## SYNOPSIS

Retrieves the RDAP record for an IP network or address.

## SYNTAX

### __AllParameterSets

```
Get-RDAPIpNetwork [-Address] <string[]> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries an RDAP server for an IP network registration record using an
IPv4 address, IPv6 address, or CIDR prefix (e.g., 192.0.2.0/24).
Returns a strongly typed RdapIpNetwork object containing allocation
details, entities, and status information.

## EXAMPLES

### EXAMPLE 1

Get-RDAPIpNetwork -Address '192.0.2.0/24'

Retrieves the RDAP record for the 192.0.2.0/24 IP network.

### EXAMPLE 2

Get-RDAPIpNetwork -Address '2001:db8::'

Retrieves the RDAP record for the specified IPv6 address.

## PARAMETERS

### -Address

The IPv4 address, IPv6 address, or CIDR prefix to query
(e.g., "192.0.2.1", "2001:db8::/32").
Accepts pipeline input.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
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

### System.String

{{ Fill in the Description }}

### System.String[]

{{ Fill in the Description }}

## OUTPUTS

### RdapIpNetwork

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
