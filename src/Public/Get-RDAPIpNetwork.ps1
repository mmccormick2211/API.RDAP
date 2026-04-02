function Get-RDAPIpNetwork {
    <#
    .SYNOPSIS
        Retrieves the RDAP record for an IP network or address.

    .DESCRIPTION
        Queries an RDAP server for an IP network registration record using an
        IPv4 address, IPv6 address, or CIDR prefix (e.g., 192.0.2.0/24).
        Returns a strongly typed RdapIpNetwork object containing allocation
        details, entities, and status information.

    .PARAMETER Address
        The IPv4 address, IPv6 address, or CIDR prefix to query
        (e.g., "192.0.2.1", "2001:db8::/32"). Accepts pipeline input.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Get-RDAPIpNetwork -Address '192.0.2.0/24'

        Retrieves the RDAP record for the 192.0.2.0/24 IP network.

    .EXAMPLE
        Get-RDAPIpNetwork -Address '2001:db8::'

        Retrieves the RDAP record for the specified IPv6 address.

    .INPUTS
        System.String

    .OUTPUTS
        RdapIpNetwork

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding()]
    [OutputType('RdapIpNetwork')]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $Address,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Server = 'https://rdap.org'
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {
        foreach ($ipAddress in $Address) {
            try {
                Write-Verbose "Querying RDAP for IP network: $ipAddress"
                $response = InvokeRDAPRequest -Server $Server -Path "/ip/$ipAddress"
                [RdapIpNetwork]::new($response)
            }
            catch {
                Write-Verbose "$($MyInvocation.MyCommand) failed for '$ipAddress': $_"
                throw $_
            }
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
