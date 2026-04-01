[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables used in Pester test contexts')]
param()

BeforeAll {
    if (-not ([System.Management.Automation.PSTypeName]'RdapDomain').Type) {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../Enum/RdapObjectType.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../Classes/RdapTypes.ps1')
    }
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Test-RDAPObject' {

    Context 'Parameter Validation' {

        It 'Should not accept empty Handle' {
            { Test-RDAPObject -Type ([RdapObjectType]::Domain) -Handle '' } | Should -Throw
        }
    }

    Context 'Object exists (HTTP 200)' {

        BeforeEach {
            Mock Invoke-WebRequest {
                [PSCustomObject]@{ StatusCode = 200 }
            }
        }

        It 'Should return true when the server responds with 200' {
            $result = Test-RDAPObject -Type ([RdapObjectType]::Domain) -Handle 'example.com'

            $result | Should -BeTrue
        }

        It 'Should use HEAD method' {
            Test-RDAPObject -Type ([RdapObjectType]::Domain) -Handle 'example.com'

            Should -Invoke Invoke-WebRequest -Times 1 -ParameterFilter {
                $Method -eq 'Head'
            }
        }

        It 'Should set the Accept header' {
            Test-RDAPObject -Type ([RdapObjectType]::Domain) -Handle 'example.com'

            Should -Invoke Invoke-WebRequest -Times 1 -ParameterFilter {
                $Headers['Accept'] -eq 'application/rdap+json'
            }
        }
    }

    Context 'Object does not exist (HTTP 404)' {

        BeforeEach {
            Mock Invoke-WebRequest {
                [PSCustomObject]@{ StatusCode = 404 }
            }
        }

        It 'Should return false when the server responds with 404' {
            $result = Test-RDAPObject -Type ([RdapObjectType]::Domain) -Handle 'notfound.example'

            $result | Should -BeFalse
        }
    }

    Context 'Type to URL segment mapping' {

        BeforeEach {
            Mock Invoke-WebRequest { [PSCustomObject]@{ StatusCode = 200 } }
        }

        It 'Should use domain segment for Domain type' {
            Test-RDAPObject -Type ([RdapObjectType]::Domain) -Handle 'example.com'

            Should -Invoke Invoke-WebRequest -Times 1 -ParameterFilter {
                $Uri -like '*/domain/example.com'
            }
        }

        It 'Should use nameserver segment for Nameserver type' {
            Test-RDAPObject -Type ([RdapObjectType]::Nameserver) -Handle 'ns1.example.com'

            Should -Invoke Invoke-WebRequest -Times 1 -ParameterFilter {
                $Uri -like '*/nameserver/ns1.example.com'
            }
        }

        It 'Should use entity segment for Entity type' {
            Test-RDAPObject -Type ([RdapObjectType]::Entity) -Handle 'IANA-1'

            Should -Invoke Invoke-WebRequest -Times 1 -ParameterFilter {
                $Uri -like '*/entity/IANA-1'
            }
        }

        It 'Should use ip segment for IpNetwork type' {
            Test-RDAPObject -Type ([RdapObjectType]::IpNetwork) -Handle '192.0.2.0/24'

            Should -Invoke Invoke-WebRequest -Times 1 -ParameterFilter {
                $Uri -like '*/ip/*'
            }
        }

        It 'Should use autnum segment for Autnum type' {
            Test-RDAPObject -Type ([RdapObjectType]::Autnum) -Handle '64496'

            Should -Invoke Invoke-WebRequest -Times 1 -ParameterFilter {
                $Uri -like '*/autnum/64496'
            }
        }
    }

    Context 'Error handling' {

        It 'Should re-throw network exceptions' {
            Mock Invoke-WebRequest { throw 'Connection refused' }

            { Test-RDAPObject -Type ([RdapObjectType]::Domain) -Handle 'example.com' } | Should -Throw
        }
    }
}
