---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Test-RDAPObject
---

# Test-RDAPObject

## SYNOPSIS

Tests whether an RDAP object exists on a server without retrieving its record.

## SYNTAX

### __AllParameterSets

```
Test-RDAPObject [-Type] <RdapObjectType> [-Handle] <string> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Sends an HTTP HEAD request to an RDAP server to determine if a specific
object exists, as described in RFC 7480 Section 4.1.
Returns $true if
the server responds with HTTP 200, or $false if the object does not exist
(HTTP 404).
All other HTTP errors and network failures are re-thrown.

## EXAMPLES

### EXAMPLE 1

Test-RDAPObject -Type Domain -Handle 'example.com'

Returns $true if example.com exists on the default RDAP server.

### EXAMPLE 2

Test-RDAPObject -Type IpNetwork -Handle '192.0.2.0/24' -Server 'https://rdap.arin.net/registry'

Checks whether the IP network exists on ARIN's RDAP server.

## PARAMETERS

### -Handle

The object identifier: domain LDH name, nameserver LDH name, entity handle,
IP address/prefix, or ASN.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

### -Type

The type of RDAP object to check (Domain, Nameserver, Entity, IpNetwork, Autnum).

```yaml
Type: RdapObjectType
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
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

### System.Boolean

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
