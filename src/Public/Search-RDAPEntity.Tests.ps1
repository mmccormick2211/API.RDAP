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

Describe 'Search-RDAPEntity' {

    Context 'Parameter Validation' {

        It 'Should not accept empty Fn in ByFn parameter set' {
            { Search-RDAPEntity -Fn '' } | Should -Throw
        }

        It 'Should not accept empty Handle in ByHandle parameter set' {
            { Search-RDAPEntity -Handle '' } | Should -Throw
        }
    }

    Context 'Search by Fn' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    entitySearchResults = @(
                        [PSCustomObject]@{
                            handle = 'IANA-1'; objectClassName = 'entity'
                            vcardArray = $null; roles = @('registrar')
                            entities = @(); events = @(); links = @()
                            status = @(); remarks = @()
                        }
                    )
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the fn query parameter' {
            Search-RDAPEntity -Fn 'Example Inc'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -like '/entities?fn=*'
            }
        }

        It 'Should return RdapEntity objects' {
            $results = Search-RDAPEntity -Fn 'Example Inc'

            $results | Should -HaveCount 1
            $results[0].GetType().Name | Should -Be 'RdapEntity'
        }
    }

    Context 'Search by Handle' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{ entitySearchResults = @() }
            }
        }

        It 'Should call InvokeRDAPRequest with the handle query parameter' {
            Search-RDAPEntity -Handle 'IANA*'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -like '/entities?handle=*'
            }
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Server error' }

            { Search-RDAPEntity -Fn 'Test Entity' } | Should -Throw
        }
    }
}
