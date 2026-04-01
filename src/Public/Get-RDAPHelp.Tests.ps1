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

Describe 'Get-RDAPHelp' {

    Context 'Successful request' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    rdapConformance = @('rdap_level_0', 'icann_rdap_response_profile_0')
                    notices         = @(
                        [PSCustomObject]@{
                            title       = 'Terms of Service'
                            description = @('Subject to terms.')
                        }
                    )
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the /help path' {
            Get-RDAPHelp

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -eq '/help'
            }
        }

        It 'Should pass Server to InvokeRDAPRequest' {
            Get-RDAPHelp -Server 'https://rdap.arin.net/registry'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Server -eq 'https://rdap.arin.net/registry'
            }
        }

        It 'Should return an RdapHelp object' {
            $result = Get-RDAPHelp

            $result.GetType().Name | Should -Be 'RdapHelp'
        }

        It 'Should map RdapConformance from the response' {
            $result = Get-RDAPHelp

            $result.RdapConformance | Should -Contain 'rdap_level_0'
        }

        It 'Should map Notices from the response' {
            $result = Get-RDAPHelp

            $result.Notices | Should -HaveCount 1
        }

        It 'Should preserve the raw response' {
            $result = Get-RDAPHelp

            $result.RawResponse | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Connection refused' }

            { Get-RDAPHelp } | Should -Throw
        }
    }
}
