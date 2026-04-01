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

Describe 'Get-RDAPEntity' {

    Context 'Parameter Validation' {

        It 'Should not accept null or empty Handle' {
            { Get-RDAPEntity -Handle $null } | Should -Throw
            { Get-RDAPEntity -Handle '' }    | Should -Throw
        }
    }

    Context 'Successful lookup' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'IANA-1'
                    objectClassName = 'entity'
                    vcardArray      = $null
                    roles           = @('registrar')
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @()
                    remarks         = @()
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the correct path' {
            Get-RDAPEntity -Handle 'IANA-1'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -eq '/entity/IANA-1'
            }
        }

        It 'Should pass Server to InvokeRDAPRequest' {
            Get-RDAPEntity -Handle 'IANA-1' -Server 'https://rdap.example.org'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Server -eq 'https://rdap.example.org'
            }
        }

        It 'Should return an RdapEntity object' {
            $result = Get-RDAPEntity -Handle 'IANA-1'

            $result.GetType().Name | Should -Be 'RdapEntity'
        }

        It 'Should map Handle from the response' {
            $result = Get-RDAPEntity -Handle 'IANA-1'

            $result.Handle | Should -Be 'IANA-1'
        }

        It 'Should preserve the raw response' {
            $result = Get-RDAPEntity -Handle 'IANA-1'

            $result.RawResponse | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Pipeline support' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'TEST-1'
                    objectClassName = 'entity'
                    vcardArray      = $null
                    roles           = @()
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @()
                    remarks         = @()
                }
            }
        }

        It 'Should accept multiple handles via pipeline' {
            $results = 'IANA-1', 'BLD-ARIN' | Get-RDAPEntity

            Should -Invoke InvokeRDAPRequest -Times 2
            $results | Should -HaveCount 2
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Not found' }

            { Get-RDAPEntity -Handle 'NOTEXIST-1' } | Should -Throw
        }
    }
}
