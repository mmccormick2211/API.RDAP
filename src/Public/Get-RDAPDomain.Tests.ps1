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

Describe 'Get-RDAPDomain' {

    Context 'Parameter Validation' {

        It 'Should not accept null or empty Name' {
            { Get-RDAPDomain -Name $null } | Should -Throw
            { Get-RDAPDomain -Name '' } | Should -Throw
        }

        It 'Should not accept empty Server' {
            Mock InvokeRDAPRequest { [PSCustomObject]@{} }
            { Get-RDAPDomain -Name 'example.com' -Server '' } | Should -Throw
        }
    }

    Context 'Successful lookup' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'EXAMPLE-COM'
                    objectClassName = 'domain'
                    ldhName         = 'example.com'
                    unicodeName     = $null
                    nameservers     = @()
                    secureDNS       = $null
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @('active')
                    remarks         = @()
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the correct path' {
            Get-RDAPDomain -Name 'example.com'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -eq '/domain/example.com'
            }
        }

        It 'Should pass Server to InvokeRDAPRequest' {
            Get-RDAPDomain -Name 'example.com' -Server 'https://rdap.example.org'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Server -eq 'https://rdap.example.org'
            }
        }

        It 'Should return an RdapDomain object' {
            $result = Get-RDAPDomain -Name 'example.com'

            $result.GetType().Name | Should -Be 'RdapDomain'
        }

        It 'Should map LdhName from the response' {
            $result = Get-RDAPDomain -Name 'example.com'

            $result.LdhName | Should -Be 'example.com'
        }

        It 'Should map Handle from the response' {
            $result = Get-RDAPDomain -Name 'example.com'

            $result.Handle | Should -Be 'EXAMPLE-COM'
        }

        It 'Should preserve the raw response' {
            $result = Get-RDAPDomain -Name 'example.com'

            $result.RawResponse | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Pipeline support' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'TEST'
                    objectClassName = 'domain'
                    ldhName         = 'test.com'
                    unicodeName     = $null
                    nameservers     = @()
                    secureDNS       = $null
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @()
                    remarks         = @()
                }
            }
        }

        It 'Should accept multiple names via pipeline' {
            $results = 'example.com', 'example.net' | Get-RDAPDomain

            Should -Invoke InvokeRDAPRequest -Times 2
            $results | Should -HaveCount 2
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Not found' }

            { Get-RDAPDomain -Name 'notfound.example' } | Should -Throw
        }
    }
}
