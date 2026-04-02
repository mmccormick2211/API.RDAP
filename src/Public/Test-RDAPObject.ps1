function Test-RDAPObject {
    <#
    .SYNOPSIS
        Tests whether an RDAP object exists on a server without retrieving its record.

    .DESCRIPTION
        Sends an HTTP HEAD request to an RDAP server to determine if a specific
        object exists, as described in RFC 7480 Section 4.1. Returns $true if
        the server responds with HTTP 200, or $false if the object does not exist
        (HTTP 404). All other HTTP errors and network failures are re-thrown.

    .PARAMETER Type
        The type of RDAP object to check (Domain, Nameserver, Entity, IpNetwork, Autnum).

    .PARAMETER Handle
        The object identifier: domain LDH name, nameserver LDH name, entity handle,
        IP address/prefix, or ASN.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Test-RDAPObject -Type Domain -Handle 'example.com'

        Returns $true if example.com exists on the default RDAP server.

    .EXAMPLE
        Test-RDAPObject -Type IpNetwork -Handle '192.0.2.0/24' -Server 'https://rdap.arin.net/registry'

        Checks whether the IP network exists on ARIN's RDAP server.

    .INPUTS
        None

    .OUTPUTS
        System.Boolean

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [RdapObjectType] $Type,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $Handle,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Server = 'https://rdap.org'
    )

    process {
        try {
            $typeString  = $Type.ToString().ToLower()
            $typeSegment = if ($typeString -eq 'ipnetwork') { 'ip' } else { $typeString }
            $uri         = $Server.TrimEnd('/') + "/$typeSegment/$Handle"

            Write-Verbose "$($MyInvocation.MyCommand) HEAD $uri"

            $response = Invoke-WebRequest -Uri $uri -Method Head `
                -Headers @{ Accept = 'application/rdap+json' } `
                -SkipHttpErrorCheck -ErrorAction Stop

            $response.StatusCode -eq 200
        }
        catch {
            Write-Verbose "$($MyInvocation.MyCommand) failed for '$Handle': $_"
            throw $_
        }
    }
}
