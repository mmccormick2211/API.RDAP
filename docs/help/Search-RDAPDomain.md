---
document type: cmdlet
external help file: API.RDAP-Help.xml
HelpUri: https://github.com/mmccormick2211/API.RDAP
Locale: en-US
Module Name: API.RDAP
ms.date: 04/02/2026
PlatyPS schema version: 2024-05-01
title: Search-RDAPDomain
---

# Search-RDAPDomain

## SYNOPSIS

Searches for domain registrations using an RDAP server.

## SYNTAX

### ByName (Default)

```
Search-RDAPDomain [-Name] <string> [-Server <string>] [<CommonParameters>]
```

### ByNsName

```
Search-RDAPDomain -NsName <string> [-Server <string>] [<CommonParameters>]
```

### ByNsIp

```
Search-RDAPDomain -NsIp <string> [-Server <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries an RDAP server for domain registration records matching the
specified search criteria.
Supports searching by domain name pattern,
nameserver name, or nameserver IP address.
Wildcards are permitted in
name patterns per RFC 9082.

## EXAMPLES

### EXAMPLE 1

Search-RDAPDomain -Name 'exam*.com'

Searches for domain names matching the pattern exam*.com.

### EXAMPLE 2

Search-RDAPDomain -NsName 'ns1.example.com'

Searches for domains delegated to the nameserver ns1.example.com.

### EXAMPLE 3

Search-RDAPDomain -NsIp '192.0.2.1'

Searches for domains whose nameserver has the given IP address.

## PARAMETERS

### -Name

A domain name pattern to search for (e.g., "exam*.com").

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

### -NsIp

An IPv4 or IPv6 address of a nameserver associated with the domain.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByNsIp
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NsName

The LDH name of a nameserver associated with the domain.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByNsName
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

### RdapDomain

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

- [](https://github.com/mmccormick2211/API.RDAP)
