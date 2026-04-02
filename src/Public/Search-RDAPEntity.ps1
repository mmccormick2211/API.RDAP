function Search-RDAPEntity {
    <#
    .SYNOPSIS
        Searches for entity registrations using an RDAP server.

    .DESCRIPTION
        Queries an RDAP server for entity registration records matching the
        specified search criteria. Entities represent registrants, registrars,
        administrative contacts, technical contacts, and other registered
        individuals or organizations. Supports searching by full name (fn) or
        entity handle.

    .PARAMETER Fn
        The formatted name (fn vCard property) of the entity to search for.
        Wildcards are permitted per RFC 9082.

    .PARAMETER Handle
        The entity handle to search for.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Search-RDAPEntity -Fn 'Example Registrar*'

        Searches for entities whose formatted name matches the pattern.

    .EXAMPLE
        Search-RDAPEntity -Handle 'IANA*'

        Searches for entities whose handle matches the pattern.

    .INPUTS
        None

    .OUTPUTS
        RdapEntity

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByFn')]
    [OutputType('RdapEntity')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByFn', Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Fn,

        [Parameter(Mandatory, ParameterSetName = 'ByHandle')]
        [ValidateNotNullOrEmpty()]
        [string] $Handle,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Server = 'https://rdap.org'
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {
        try {
            $queryString = switch ($PSCmdlet.ParameterSetName) {
                'ByFn'     { "fn=$([System.Uri]::EscapeDataString($Fn))" }
                'ByHandle' { "handle=$([System.Uri]::EscapeDataString($Handle))" }
            }

            Write-Verbose "Searching RDAP entities: $queryString"
            $response = InvokeRDAPRequest -Server $Server -Path "/entities?$queryString"

            foreach ($item in $response.entitySearchResults) {
                [RdapEntity]::new($item)
            }
        }
        catch {
            Write-Verbose "$($MyInvocation.MyCommand) failed: $_"
            throw $_
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
