function Get-RDAPHelp {
    <#
    .SYNOPSIS
        Retrieves help and service information from an RDAP server.

    .DESCRIPTION
        Queries the /help endpoint of an RDAP server to retrieve service
        information such as terms of service, privacy policy, rate-limiting
        policy, supported authentication methods, supported extensions, and
        technical support contact details.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Get-RDAPHelp

        Retrieves help information from the default RDAP server.

    .EXAMPLE
        Get-RDAPHelp -Server 'https://rdap.arin.net/registry'

        Retrieves help information from ARIN's RDAP server.

    .INPUTS
        None

    .OUTPUTS
        RdapHelp

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding()]
    [OutputType('RdapHelp')]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Server = 'https://rdap.org'
    )

    process {
        try {
            Write-Verbose "Querying RDAP help from: $Server"
            $response = InvokeRDAPRequest -Server $Server -Path '/help'
            [RdapHelp]::new($response)
        }
        catch {
            Write-Verbose "$($MyInvocation.MyCommand) failed: $_"
            throw $_
        }
    }
}
