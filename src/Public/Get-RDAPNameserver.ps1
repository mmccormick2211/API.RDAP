function Get-RDAPNameserver {
    <#
    .SYNOPSIS
        Retrieves the RDAP record for a nameserver.

    .DESCRIPTION
        Queries an RDAP server for a nameserver registration record using the
        nameserver's LDH name. Returns a strongly typed RdapNameserver object
        containing IP addresses, entities, events, and status information.

    .PARAMETER Name
        The LDH name of the nameserver to query (e.g., "ns1.example.com").
        Accepts pipeline input.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Get-RDAPNameserver -Name 'ns1.example.com'

        Retrieves the RDAP record for ns1.example.com.

    .EXAMPLE
        'ns1.example.com', 'ns2.example.com' | Get-RDAPNameserver

        Retrieves RDAP records for multiple nameservers via the pipeline.

    .INPUTS
        System.String

    .OUTPUTS
        RdapNameserver

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding()]
    [OutputType('RdapNameserver')]
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
        foreach ($nsName in $Name) {
            try {
                Write-Verbose "Querying RDAP for nameserver: $nsName"
                $response = InvokeRDAPRequest -Server $Server -Path "/nameserver/$nsName"
                [RdapNameserver]::new($response)
            }
            catch {
                Write-Verbose "$($MyInvocation.MyCommand) failed for '$nsName': $_"
                throw $_
            }
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
