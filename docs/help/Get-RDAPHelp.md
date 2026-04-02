---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Get-RDAPHelp
---

# Get-RDAPHelp

## SYNOPSIS

Retrieves help and service information from an RDAP server.

## SYNTAX

### __AllParameterSets

```
Get-RDAPHelp [[-Server] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries the /help endpoint of an RDAP server to retrieve service
information such as terms of service, privacy policy, rate-limiting
policy, supported authentication methods, supported extensions, and
technical support contact details.

## EXAMPLES

### EXAMPLE 1

Get-RDAPHelp

Retrieves help information from the default RDAP server.

### EXAMPLE 2

Get-RDAPHelp -Server 'https://rdap.arin.net/registry'

Retrieves help information from ARIN's RDAP server.

## PARAMETERS

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
  Position: 0
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

### RdapHelp

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
