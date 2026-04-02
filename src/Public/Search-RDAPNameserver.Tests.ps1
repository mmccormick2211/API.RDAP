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

Describe 'Search-RDAPNameserver' {

    Context 'Parameter Validation' {

        It 'Should not accept empty Name in ByName parameter set' {
            { Search-RDAPNameserver -Name '' } | Should -Throw
        }

        It 'Should not accept empty IpAddress in ByIp parameter set' {
            { Search-RDAPNameserver -IpAddress '' } | Should -Throw
        }
    }

    Context 'Search by Name' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    nameserverSearchResults = @(
                        [PSCustomObject]@{
                            handle = 'NS1-EXAMPLE'; objectClassName = 'nameserver'
                            ldhName = 'ns1.example.com'; unicodeName = $null
                            ipAddresses = $null; entities = @()
                            events = @(); links = @(); status = @('active'); remarks = @()
                        }
                    )
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the name query parameter' {
            Search-RDAPNameserver -Name 'ns*.example.com'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -like '/nameservers?name=*'
            }
        }

        It 'Should return RdapNameserver objects' {
            $results = Search-RDAPNameserver -Name 'ns*.example.com'

            $results | Should -HaveCount 1
            $results[0].GetType().Name | Should -Be 'RdapNameserver'
        }
    }

    Context 'Search by IpAddress' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{ nameserverSearchResults = @() }
            }
        }

        It 'Should call InvokeRDAPRequest with the ip query parameter' {
            Search-RDAPNameserver -IpAddress '192.0.2.1'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -like '/nameservers?ip=*'
            }
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Server error' }

            { Search-RDAPNameserver -Name 'ns.example.com' } | Should -Throw
        }
    }
}
