---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Search-RDAPEntity
---

# Search-RDAPEntity

## SYNOPSIS

Searches for entity registrations using an RDAP server.

## SYNTAX

### ByFn (Default)

```
Search-RDAPEntity [-Fn] <string> [-Server <string>] [<CommonParameters>]
```

### ByHandle

```
Search-RDAPEntity -Handle <string> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries an RDAP server for entity registration records matching the
specified search criteria.
Entities represent registrants, registrars,
administrative contacts, technical contacts, and other registered
individuals or organizations.
Supports searching by full name (fn) or
entity handle.

## EXAMPLES

### EXAMPLE 1

Search-RDAPEntity -Fn 'Example Registrar*'

Searches for entities whose formatted name matches the pattern.

### EXAMPLE 2

Search-RDAPEntity -Handle 'IANA*'

Searches for entities whose handle matches the pattern.

## PARAMETERS

### -Fn

The formatted name (fn vCard property) of the entity to search for.
Wildcards are permitted per RFC 9082.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByFn
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Handle

The entity handle to search for.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByHandle
  Position: Named
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

### RdapEntity

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
