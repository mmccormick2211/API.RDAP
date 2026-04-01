function Search-RDAPNameserver {
    <#
    .SYNOPSIS
        Searches for nameserver registrations using an RDAP server.

    .DESCRIPTION
        Queries an RDAP server for nameserver registration records matching the
        specified search criteria. Supports searching by nameserver name pattern
        or IP address. Wildcards are permitted in name patterns per RFC 9082.

    .PARAMETER Name
        A nameserver LDH name pattern to search for (e.g., "ns*.example.com").

    .PARAMETER IpAddress
        An IPv4 or IPv6 address associated with the nameserver.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Search-RDAPNameserver -Name 'ns*.example.com'

        Searches for nameservers matching the pattern ns*.example.com.

    .EXAMPLE
        Search-RDAPNameserver -IpAddress '192.0.2.1'

        Searches for nameservers with the given IP address.

    .INPUTS
        None

    .OUTPUTS
        RdapNameserver

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType('RdapNameserver')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByName', Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByIp')]
        [ValidateNotNullOrEmpty()]
        [string] $IpAddress,

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
                'ByName' { "name=$([System.Uri]::EscapeDataString($Name))" }
                'ByIp'   { "ip=$([System.Uri]::EscapeDataString($IpAddress))" }
            }

            Write-Verbose "Searching RDAP nameservers: $queryString"
            $response = InvokeRDAPRequest -Server $Server -Path "/nameservers?$queryString"

            foreach ($item in $response.nameserverSearchResults) {
                [RdapNameserver]::new($item)
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
