function InvokeRDAPRequest {
    <#
    .SYNOPSIS
        Sends an HTTP GET request to an RDAP server and returns the parsed response.

    .DESCRIPTION
        Internal helper that builds the full request URI from a server base URL and
        a path, sets the required Accept header, and returns the deserialized JSON
        response body. All errors are logged to the Verbose stream before being
        re-thrown to the caller.

    .PARAMETER Server
        The base URL of the RDAP server (e.g., https://rdap.org).
        Trailing slashes are trimmed automatically.

    .PARAMETER Path
        The request path including leading slash (e.g., /domain/example.com).

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Private function - not exported from module.
    #>
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Server,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    $uri = $Server.TrimEnd('/') + $Path
    Write-Verbose "$($MyInvocation.MyCommand) GET $uri"

    try {
        Invoke-RestMethod -Uri $uri -Headers @{ Accept = 'application/rdap+json' } -ErrorAction Stop
    }
    catch {
        Write-Verbose "$($MyInvocation.MyCommand) failed for '$uri': $_"
        throw $_
    }
}
