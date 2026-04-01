function Get-RDAPDomain {
    <#
    .SYNOPSIS
        Retrieves the RDAP record for a domain name.

    .DESCRIPTION
        Queries an RDAP server for a domain registration record using the domain
        name. Returns a strongly typed RdapDomain object containing registration
        details including nameservers, entities, events, and status information.

    .PARAMETER Name
        The domain name to query (e.g., "example.com"). Accepts pipeline input.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Get-RDAPDomain -Name 'example.com'

        Retrieves the RDAP record for example.com from the default RDAP server.

    .EXAMPLE
        'example.com', 'example.net' | Get-RDAPDomain

        Retrieves RDAP records for multiple domains via the pipeline.

    .EXAMPLE
        Get-RDAPDomain -Name 'example.com' -Server 'https://rdap.verisign.com/com/v1'

        Queries a registry-specific RDAP server for the domain record.

    .INPUTS
        System.String

    .OUTPUTS
        RdapDomain

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding()]
    [OutputType('RdapDomain')]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Server = 'https://rdap.org'
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {
        foreach ($domainName in $Name) {
            try {
                Write-Verbose "Querying RDAP for domain: $domainName"
                $response = InvokeRDAPRequest -Server $Server -Path "/domain/$domainName"
                [RdapDomain]::new($response)
            } catch {
                Write-Verbose "$($MyInvocation.MyCommand) failed for '$domainName': $_"
                throw $_
            }
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
