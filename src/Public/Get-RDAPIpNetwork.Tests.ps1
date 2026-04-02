[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables used in Pester test contexts')]
param()

BeforeAll {
    if (-not ([System.Management.Automation.PSTypeName]'RdapDomain').Type) {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../Enum/RdapObjectType.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../Classes/RdapTypes.ps1')
    }
    . (Join-Path -Path $PSScriptRoot -ChildPath '../Private/InvokeRDAPRequest.ps1')
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Get-RDAPIpNetwork' {

    Context 'Parameter Validation' {

        It 'Should not accept null or empty Address' {
            { Get-RDAPIpNetwork -Address $null } | Should -Throw
            { Get-RDAPIpNetwork -Address '' }    | Should -Throw
        }
    }

    Context 'Successful lookup' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = '192-0-2-0-24'
                    objectClassName = 'ip network'
                    startAddress    = '192.0.2.0'
                    endAddress      = '192.0.2.255'
                    ipVersion       = 'v4'
                    name            = 'EXAMPLE-NET'
                    type            = 'ASSIGNED'
                    country         = 'US'
                    parentHandle    = $null
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @('active')
                    remarks         = @()
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the correct path' {
            Get-RDAPIpNetwork -Address '192.0.2.0/24'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -eq '/ip/192.0.2.0/24'
            }
        }

        It 'Should pass Server to InvokeRDAPRequest' {
            Get-RDAPIpNetwork -Address '192.0.2.0/24' -Server 'https://rdap.arin.net/registry'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Server -eq 'https://rdap.arin.net/registry'
            }
        }

        It 'Should return an RdapIpNetwork object' {
            $result = Get-RDAPIpNetwork -Address '192.0.2.0/24'

            $result.GetType().Name | Should -Be 'RdapIpNetwork'
        }

        It 'Should map StartAddress from the response' {
            $result = Get-RDAPIpNetwork -Address '192.0.2.0/24'

            $result.StartAddress | Should -Be '192.0.2.0'
        }

        It 'Should map IpVersion from the response' {
            $result = Get-RDAPIpNetwork -Address '192.0.2.0/24'

            $result.IpVersion | Should -Be 'v4'
        }

        It 'Should preserve the raw response' {
            $result = Get-RDAPIpNetwork -Address '192.0.2.0/24'

            $result.RawResponse | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Pipeline support' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'TEST-NET'
                    objectClassName = 'ip network'
                    startAddress    = '10.0.0.0'
                    endAddress      = '10.0.0.255'
                    ipVersion       = 'v4'
                    name            = $null
                    type            = $null
                    country         = $null
                    parentHandle    = $null
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @()
                    remarks         = @()
                }
            }
        }

        It 'Should accept multiple addresses via pipeline' {
            $results = '192.0.2.0/24', '2001:db8::' | Get-RDAPIpNetwork

            Should -Invoke InvokeRDAPRequest -Times 2
            $results | Should -HaveCount 2
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Not found' }

            { Get-RDAPIpNetwork -Address '0.0.0.0' } | Should -Throw
        }
    }
}
