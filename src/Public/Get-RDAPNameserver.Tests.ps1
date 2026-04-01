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

Describe 'Get-RDAPNameserver' {

    Context 'Parameter Validation' {

        It 'Should not accept null or empty Name' {
            { Get-RDAPNameserver -Name $null } | Should -Throw
            { Get-RDAPNameserver -Name '' }    | Should -Throw
        }
    }

    Context 'Successful lookup' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'NS1-EXAMPLE-COM'
                    objectClassName = 'nameserver'
                    ldhName         = 'ns1.example.com'
                    unicodeName     = $null
                    ipAddresses     = [PSCustomObject]@{ v4 = @('192.0.2.1') }
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @('active')
                    remarks         = @()
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the correct path' {
            Get-RDAPNameserver -Name 'ns1.example.com'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -eq '/nameserver/ns1.example.com'
            }
        }

        It 'Should pass Server to InvokeRDAPRequest' {
            Get-RDAPNameserver -Name 'ns1.example.com' -Server 'https://rdap.example.org'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Server -eq 'https://rdap.example.org'
            }
        }

        It 'Should return an RdapNameserver object' {
            $result = Get-RDAPNameserver -Name 'ns1.example.com'

            $result.GetType().Name | Should -Be 'RdapNameserver'
        }

        It 'Should map LdhName from the response' {
            $result = Get-RDAPNameserver -Name 'ns1.example.com'

            $result.LdhName | Should -Be 'ns1.example.com'
        }

        It 'Should preserve the raw response' {
            $result = Get-RDAPNameserver -Name 'ns1.example.com'

            $result.RawResponse | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Pipeline support' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    handle          = 'NS-TEST'
                    objectClassName = 'nameserver'
                    ldhName         = 'ns.test.com'
                    unicodeName     = $null
                    ipAddresses     = $null
                    entities        = @()
                    events          = @()
                    links           = @()
                    status          = @()
                    remarks         = @()
                }
            }
        }

        It 'Should accept multiple names via pipeline' {
            $results = 'ns1.example.com', 'ns2.example.com' | Get-RDAPNameserver

            Should -Invoke InvokeRDAPRequest -Times 2
            $results | Should -HaveCount 2
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Not found' }

            { Get-RDAPNameserver -Name 'ns.notfound.example' } | Should -Throw
        }
    }
}
