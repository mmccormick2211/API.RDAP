---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Get-RDAPEntity
---

# Get-RDAPEntity

## SYNOPSIS

Retrieves the RDAP record for an entity (registrant, registrar, or contact).

## SYNTAX

### __AllParameterSets

```
Get-RDAPEntity [-Handle] <string[]> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries an RDAP server for an entity registration record using the entity
handle.
Entities represent registrants, registrars, administrative contacts,
technical contacts, and other registered individuals or organizations.
Returns a strongly typed RdapEntity object.

## EXAMPLES

### EXAMPLE 1

Get-RDAPEntity -Handle 'IANA-1'

Retrieves the RDAP record for entity handle IANA-1.

### EXAMPLE 2

'IANA-1', 'BLD-ARIN' | Get-RDAPEntity

Retrieves RDAP records for multiple entity handles via the pipeline.

## PARAMETERS

### -Handle

The entity handle to query (e.g., "IANA-1", "BLD-ARIN").
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

### RdapEntity

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
