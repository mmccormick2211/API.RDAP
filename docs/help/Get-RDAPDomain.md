---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Get-RDAPDomain
---

# Get-RDAPDomain

## SYNOPSIS

Retrieves the RDAP record for a domain name.

## SYNTAX

### __AllParameterSets

```
Get-RDAPDomain [-Name] <string[]> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries an RDAP server for a domain registration record using the domain
name.
Returns a strongly typed RdapDomain object containing registration
details including nameservers, entities, events, and status information.

## EXAMPLES

### EXAMPLE 1

Get-RDAPDomain -Name 'example.com'

Retrieves the RDAP record for example.com from the default RDAP server.

### EXAMPLE 2

'example.com', 'example.net' | Get-RDAPDomain

Retrieves RDAP records for multiple domains via the pipeline.

### EXAMPLE 3

Get-RDAPDomain -Name 'example.com' -Server 'https://rdap.verisign.com/com/v1'

Queries a registry-specific RDAP server for the domain record.

## PARAMETERS

### -Name

The domain name to query (e.g., "example.com").
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

### RdapDomain

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
