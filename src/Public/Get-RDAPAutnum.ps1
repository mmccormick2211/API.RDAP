function Get-RDAPAutnum {
    <#
    .SYNOPSIS
        Retrieves the RDAP record for an autonomous system number (ASN).

    .DESCRIPTION
        Queries an RDAP server for an autonomous system number registration record.
        Returns a strongly typed RdapAutnum object containing the AS number range,
        owning organization, entities, and status information.

    .PARAMETER Asn
        The autonomous system number to query (e.g., 64496). Accepts pipeline input.

    .PARAMETER Server
        The base URL of the RDAP server to query. Defaults to https://rdap.org.

    .EXAMPLE
        Get-RDAPAutnum -Asn 64496

        Retrieves the RDAP record for AS64496.

    .EXAMPLE
        64496, 64511 | Get-RDAPAutnum

        Retrieves RDAP records for multiple ASNs via the pipeline.

    .INPUTS
        System.UInt32

    .OUTPUTS
        RdapAutnum

    .LINK
        https://github.com/mmccormick2211/API.RDAP
    #>
    [CmdletBinding()]
    [OutputType('RdapAutnum')]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [ValidateRange(0, 4294967295)]
        [uint32[]] $Asn,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Server = 'https://rdap.org'
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {
        foreach ($asnValue in $Asn) {
            try {
                Write-Verbose "Querying RDAP for ASN: $asnValue"
                $response = InvokeRDAPRequest -Server $Server -Path "/autnum/$asnValue"
                [RdapAutnum]::new($response)
            }
            catch {
                Write-Verbose "$($MyInvocation.MyCommand) failed for '$asnValue': $_"
                throw $_
            }
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
