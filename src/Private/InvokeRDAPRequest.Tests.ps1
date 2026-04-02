[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables used in Pester test contexts')]
param()

BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'InvokeRDAPRequest' {

    Context 'Parameter Validation' {

        It 'Should throw when Server is empty' {
            { InvokeRDAPRequest -Server '' -Path '/help' } | Should -Throw
        }

        It 'Should throw when Path is empty' {
            { InvokeRDAPRequest -Server 'https://rdap.org' -Path '' } | Should -Throw
        }
    }

    Context 'Successful request' {

        BeforeEach {
            Mock Invoke-RestMethod {
                [PSCustomObject]@{ rdapConformance = @('rdap_level_0') }
            }
        }

        It 'Should call Invoke-RestMethod with the correct URI' {
            InvokeRDAPRequest -Server 'https://rdap.org' -Path '/help'

            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://rdap.org/help'
            }
        }

        It 'Should trim a trailing slash from Server before building the URI' {
            InvokeRDAPRequest -Server 'https://rdap.org/' -Path '/help'

            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://rdap.org/help'
            }
        }

        It 'Should set the Accept header to application/rdap+json' {
            InvokeRDAPRequest -Server 'https://rdap.org' -Path '/help'

            Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                $Headers['Accept'] -eq 'application/rdap+json'
            }
        }

        It 'Should return the response object' {
            $result = InvokeRDAPRequest -Server 'https://rdap.org' -Path '/help'

            $result.rdapConformance | Should -Contain 'rdap_level_0'
        }
    }

    Context 'Error handling' {

        It 'Should re-throw exceptions from Invoke-RestMethod' {
            Mock Invoke-RestMethod { throw 'connection refused' }

            { InvokeRDAPRequest -Server 'https://rdap.org' -Path '/help' } | Should -Throw
        }
    }
}
