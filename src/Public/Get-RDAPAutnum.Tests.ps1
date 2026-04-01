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

Describe 'Get-RDAPAutnum' {

    Context 'Parameter Validation' {

        It 'Should not accept null Asn' {
            { Get-RDAPAutnum -Asn $null } | Should -Throw
        }
    }

    Context 'Successful lookup' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'AS64496'
                    objectClassName = 'autnum'
                    startAutnum     = 64496
                    endAutnum       = 64511
                    name            = 'EXAMPLE-ASN'
                    type            = 'DIRECT ALLOCATION'
                    country         = 'US'
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @('active')
                    remarks         = @()
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the correct path' {
            Get-RDAPAutnum -Asn 64496

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -eq '/autnum/64496'
            }
        }

        It 'Should pass Server to InvokeRDAPRequest' {
            Get-RDAPAutnum -Asn 64496 -Server 'https://rdap.arin.net/registry'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Server -eq 'https://rdap.arin.net/registry'
            }
        }

        It 'Should return an RdapAutnum object' {
            $result = Get-RDAPAutnum -Asn 64496

            $result.GetType().Name | Should -Be 'RdapAutnum'
        }

        It 'Should map StartAutnum from the response' {
            $result = Get-RDAPAutnum -Asn 64496

            $result.StartAutnum | Should -Be 64496
        }

        It 'Should map EndAutnum from the response' {
            $result = Get-RDAPAutnum -Asn 64496

            $result.EndAutnum | Should -Be 64511
        }

        It 'Should preserve the raw response' {
            $result = Get-RDAPAutnum -Asn 64496

            $result.RawResponse | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Pipeline support' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'AS-TEST'
                    objectClassName = 'autnum'
                    startAutnum     = 1
                    endAutnum       = 1
                    name            = $null
                    type            = $null
                    country         = $null
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @()
                    remarks         = @()
                }
            }
        }

        It 'Should accept multiple ASNs via pipeline' {
            $results = [uint32]64496, [uint32]64511 | Get-RDAPAutnum

            Should -Invoke InvokeRDAPRequest -Times 2
            $results | Should -HaveCount 2
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Not found' }

            { Get-RDAPAutnum -Asn 0 } | Should -Throw
        }
    }
}
