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

Describe 'Search-RDAPDomain' {

    Context 'Parameter Validation' {

        It 'Should not accept empty Name in ByName parameter set' {
            { Search-RDAPDomain -Name '' } | Should -Throw
        }

        It 'Should not accept empty NsName in ByNsName parameter set' {
            { Search-RDAPDomain -NsName '' } | Should -Throw
        }

        It 'Should not accept empty NsIp in ByNsIp parameter set' {
            { Search-RDAPDomain -NsIp '' } | Should -Throw
        }
    }

    Context 'Search by Name' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{
                    domainSearchResults = @(
                        [PSCustomObject]@{
                            handle = 'EXAMPLE-COM'; objectClassName = 'domain'
                            ldhName = 'example.com'; unicodeName = $null
                            nameservers = @(); secureDNS = $null; entities = @()
                            events = @(); links = @(); status = @('active'); remarks = @()
                        }
                    )
                }
            }
        }

        It 'Should call InvokeRDAPRequest with the name query parameter' {
            Search-RDAPDomain -Name 'exam*.com'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -like '/domains?name=*'
            }
        }

        It 'Should return RdapDomain objects' {
            $results = Search-RDAPDomain -Name 'exam*.com'

            $results | Should -HaveCount 1
            $results[0].GetType().Name | Should -Be 'RdapDomain'
        }
    }

    Context 'Search by NsName' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{ domainSearchResults = @() }
            }
        }

        It 'Should call InvokeRDAPRequest with the nsLdhName query parameter' {
            Search-RDAPDomain -NsName 'ns1.example.com'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -like '/domains?nsLdhName=*'
            }
        }
    }

    Context 'Search by NsIp' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{ domainSearchResults = @() }
            }
        }

        It 'Should call InvokeRDAPRequest with the nsIp query parameter' {
            Search-RDAPDomain -NsIp '192.0.2.1'

            Should -Invoke InvokeRDAPRequest -Times 1 -ParameterFilter {
                $Path -like '/domains?nsIp=*'
            }
        }
    }

    Context 'Empty results' {

        BeforeEach {
            Mock InvokeRDAPRequest {
                [PSCustomObject]@{ domainSearchResults = @() }
            }
        }

        It 'Should return nothing when search returns empty results' {
            $results = Search-RDAPDomain -Name 'nomatch*.example'

            $results | Should -BeNullOrEmpty
        }
    }

    Context 'Error handling' {

        It 'Should re-throw when InvokeRDAPRequest fails' {
            Mock InvokeRDAPRequest { throw 'Server error' }

            { Search-RDAPDomain -Name 'example.com' } | Should -Throw
        }
    }
}
