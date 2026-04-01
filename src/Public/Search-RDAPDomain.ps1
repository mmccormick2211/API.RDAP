function Search-RDAPDomain {
    <#
    .SYNOPSIS
        Searches for domain registrations using an RDAP server.

    .DESCRIPTION
        Queries an RDAP server for domain registration records matching the
        specified search criteria. Supports searching by domain name pattern,
        nameserver name, or nameserver IP address. Wildcards are permitted in
        name patterns per RFC 9082.

    .PARAMETER Name
        A domain name pattern to search for (e.g., "exam*.com").

    .PARAMETER NsName
        The LDH name of a nameserver associated with the domain.

    .PARAMETER NsIp
        An IPv4 or IPv6 address of a nameserver associated with the domain.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Search-RDAPDomain -Name 'exam*.com'

        Searches for domain names matching the pattern exam*.com.

    .EXAMPLE
        Search-RDAPDomain -NsName 'ns1.example.com'

        Searches for domains delegated to the nameserver ns1.example.com.

    .EXAMPLE
        Search-RDAPDomain -NsIp '192.0.2.1'

        Searches for domains whose nameserver has the given IP address.

    .INPUTS
        None

    .OUTPUTS
        RdapDomain

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType('RdapDomain')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByName', Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByNsName')]
        [ValidateNotNullOrEmpty()]
        [string] $NsName,

        [Parameter(Mandatory, ParameterSetName = 'ByNsIp')]
        [ValidateNotNullOrEmpty()]
        [string] $NsIp,

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
                'ByNsName' { "nsLdhName=$([System.Uri]::EscapeDataString($NsName))" }
                'ByNsIp' { "nsIp=$([System.Uri]::EscapeDataString($NsIp))" }
            }

            Write-Verbose "Searching RDAP domains: $queryString"
            $response = InvokeRDAPRequest -Server $Server -Path "/domains?$queryString"

            foreach ($item in $response.domainSearchResults) {
                [RdapDomain]::new($item)
            }
        } catch {
            Write-Verbose "$($MyInvocation.MyCommand) failed: $_"
            throw $_
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
