---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Get-RDAPNameserver
---

# Get-RDAPNameserver

## SYNOPSIS

Retrieves the RDAP record for a nameserver.

## SYNTAX

### __AllParameterSets

```
Get-RDAPNameserver [-Name] <string[]> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries an RDAP server for a nameserver registration record using the
nameserver's LDH name.
Returns a strongly typed RdapNameserver object
containing IP addresses, entities, events, and status information.

## EXAMPLES

### EXAMPLE 1

Get-RDAPNameserver -Name 'ns1.example.com'

Retrieves the RDAP record for ns1.example.com.

### EXAMPLE 2

'ns1.example.com', 'ns2.example.com' | Get-RDAPNameserver

Retrieves RDAP records for multiple nameservers via the pipeline.

## PARAMETERS

### -Name

The LDH name of the nameserver to query (e.g., "ns1.example.com").
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

### RdapNameserver

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
