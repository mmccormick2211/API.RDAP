---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Get-RDAPAutnum
---

# Get-RDAPAutnum

## SYNOPSIS

Retrieves the RDAP record for an autonomous system number (ASN).

## SYNTAX

### __AllParameterSets

```
Get-RDAPAutnum [-Asn] <uint[]> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries an RDAP server for an autonomous system number registration record.
Returns a strongly typed RdapAutnum object containing the AS number range,
owning organization, entities, and status information.

## EXAMPLES

### EXAMPLE 1

Get-RDAPAutnum -Asn 64496

Retrieves the RDAP record for AS64496.

### EXAMPLE 2

64496, 64511 | Get-RDAPAutnum

Retrieves RDAP records for multiple ASNs via the pipeline.

## PARAMETERS

### -Asn

The autonomous system number to query (e.g., 64496).
Accepts pipeline input.

```yaml
Type: System.UInt32[]
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

### System.UInt32

{{ Fill in the Description }}

### System.UInt32[]

{{ Fill in the Description }}

## OUTPUTS

### RdapAutnum

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
