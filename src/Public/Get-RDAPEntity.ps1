function Get-RDAPEntity {
    <#
    .SYNOPSIS
        Retrieves the RDAP record for an entity (registrant, registrar, or contact).

    .DESCRIPTION
        Queries an RDAP server for an entity registration record using the entity
        handle. Entities represent registrants, registrars, administrative contacts,
        technical contacts, and other registered individuals or organizations.
        Returns a strongly typed RdapEntity object.

    .PARAMETER Handle
        The entity handle to query (e.g., "IANA-1", "BLD-ARIN"). Accepts pipeline input.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Get-RDAPEntity -Handle 'IANA-1'

        Retrieves the RDAP record for entity handle IANA-1.

    .EXAMPLE
        'IANA-1', 'BLD-ARIN' | Get-RDAPEntity

        Retrieves RDAP records for multiple entity handles via the pipeline.

    .INPUTS
        System.String

    .OUTPUTS
        RdapEntity

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding()]
    [OutputType('RdapEntity')]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $Handle,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Server = 'https://rdap.org'
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {
        foreach ($entityHandle in $Handle) {
            try {
                Write-Verbose "Querying RDAP for entity: $entityHandle"
                $response = InvokeRDAPRequest -Server $Server -Path "/entity/$entityHandle"
                [RdapEntity]::new($response)
            }
            catch {
                Write-Verbose "$($MyInvocation.MyCommand) failed for '$entityHandle': $_"
                throw $_
            }
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
