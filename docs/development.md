# 🛠️ Development Guide

This guide covers the complete development workflow including creating functions, building, testing, and generating documentation.

## Development Workflow

### Creating New Functions

#### 1. Choose Function Location

- **Public functions** (`src/Public/`) - Exported to users, become module commands
- **Private functions** (`src/Private/`) - Internal helpers, not exported

#### 2. Create Function File

Follow PowerShell naming conventions: `Verb-Noun.ps1`

```powershell
# src/Public/Get-Something.ps1
function Get-Something {
    <#
    .SYNOPSIS
        Brief one-line description of what the function does

    .DESCRIPTION
        Detailed explanation of the function's purpose and behavior.
        Can span multiple lines for complex functions.

    .PARAMETER Name
        Description of what this parameter does

    .PARAMETER Force
        Description of Force parameter (optional switches)

    .EXAMPLE
        Get-Something -Name 'Example'

        Description of what this example demonstrates and expected output.

    .EXAMPLE
        Get-Something -Name 'Test' -Force

        Another example showing different usage pattern.

    .INPUTS
        System.String
        You can pipe string values to this function

    .OUTPUTS
        System.Object
        Returns custom object with properties

    .NOTES
        Additional information about requirements, limitations, or notes

    .LINK
        https://github.com/YourUsername/YourModule
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter()]
        [switch]
        $Force
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $results = [System.Collections.Generic.List[object]]::new()
    }

    process {
        try {
            # Should Process for destructive operations
            if ($PSCmdlet.ShouldProcess($Name, 'Process item')) {
                Write-Verbose "Processing: $Name"

                # Your implementation here
                $result = [PSCustomObject]@{
                    Name      = $Name
                    Processed = $true
                    Timestamp = Get-Date
                }

                $results.Add($result)
            }
        }
        catch {
            $errorMessage = "Failed to process '$Name': $_"
            Write-Error $errorMessage
            throw
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand). Processed $($results.Count) items."
        return $results
    }
}
```

#### 3. Create Test File

Create `FunctionName.Tests.ps1` alongside the function:

```powershell
# src/Public/Get-Something.Tests.ps1
BeforeAll {
    # Import the function being tested
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Get-Something' {
    Context 'Parameter Validation' {
        It 'Should require Name parameter' {
            { Get-Something } | Should -Throw
        }

        It 'Should not accept null or empty Name' {
            { Get-Something -Name '' } | Should -Throw
        }

        It 'Should accept Name from pipeline' {
            { 'TestValue' | Get-Something } | Should -Not -Throw
        }
    }

    Context 'Basic Functionality' {
        It 'Should return object with expected properties' {
            $result = Get-Something -Name 'Test'
            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -Be 'Test'
            $result.Processed | Should -Be $true
            $result.Timestamp | Should -BeOfType [DateTime]
        }

        It 'Should process multiple items from pipeline' {
            $results = 'Item1', 'Item2', 'Item3' | Get-Something
            $results.Count | Should -Be 3
        }
    }

    Context 'Error Handling' {
        It 'Should throw on invalid operation' {
            # Mock any external dependencies
            Mock Write-Verbose {}

            { Get-Something -Name 'InvalidValue' } | Should -Throw
        }

        It 'Should write error on failure' {
            # Test error handling behavior
            { Get-Something -Name 'ErrorCase' -ErrorAction Stop } | Should -Throw
        }
    }

    Context 'WhatIf and Confirm' {
        It 'Should support WhatIf' {
            { Get-Something -Name 'Test' -WhatIf } | Should -Not -Throw
        }

        It 'Should not process when WhatIf is specified' {
            $result = Get-Something -Name 'Test' -WhatIf
            # Verify no changes were made
        }
    }

    Context 'Verbose Output' {
        It 'Should write verbose messages' {
            $verboseOutput = Get-Something -Name 'Test' -Verbose 4>&1
            $verboseOutput | Should -Not -BeNullOrEmpty
        }
    }
}
```

> **Note**: Public functions are automatically exported from the module. No need to manually update `FunctionsToExport` in the module manifest.

#### 4. Run Tests

```powershell
# Run all tests
Invoke-Build Test

# Run specific test file
Invoke-Pester -Path ./src/Public/Get-Something.Tests.ps1

# Run with detailed output
Invoke-Pester -Path ./src/Public/Get-Something.Tests.ps1 -Output Detailed
```

## Build System

### Available Build Tasks

```powershell
# View all available tasks
Invoke-Build ?

# Common tasks
Invoke-Build                          # Default: Clean + Build
Invoke-Build Clean                    # Remove build artifacts
Invoke-Build Build                    # Compile module
Invoke-Build Test                     # Run all tests

# Testing tasks
Invoke-Build UnitTests                # Run Pester tests with coverage
Invoke-Build PSScriptAnalyzer         # Run static code analysis
Invoke-Build InjectionHunter          # Run security scans

# Documentation tasks
Invoke-Build Export-CommandHelp       # Generate help files

# Publishing task
Invoke-Build Publish                  # Publish to PowerShell Gallery
```

### Build Configurations

```powershell
# Development build (default)
Invoke-Build -ReleaseType Debug

# Production release build
Invoke-Build -ReleaseType Release

# Pre-release build
Invoke-Build -ReleaseType Prerelease
```

### Build Output

After building, find your module in:

```plaintext
build/
├── src/                    # Copied source files
├── out/                    # Compiled module (ready to use)
│   └── YourModuleName/
│       ├── YourModuleName.psd1    # Module manifest
│       ├── YourModuleName.psm1    # Compiled module file
│       └── en-US/                 # Help files
└── help/                   # Generated help documentation
```

### Testing the Built Module

```powershell
# Import the built module
Import-Module ./build/out/YourModuleName/YourModuleName.psd1 -Force

# Test your functions
Get-Command -Module YourModuleName
Get-Help Get-Something -Full

# Remove when done
Remove-Module YourModuleName
```

## Testing

### Running Tests

```powershell
# Run all tests (unit, analysis, security)
Invoke-Build Test

# Run specific test types
Invoke-Build UnitTests                # Unit tests only
Invoke-Build PSScriptAnalyzer         # Code analysis only
Invoke-Build InjectionHunter          # Security scans only
Invoke-Build IntegrationTests         # Integration tests (live smoke tests are opt-in)

# Run specific test file
Invoke-Pester -Path ./src/Public/Get-Something.Tests.ps1

# Run with code coverage
Invoke-Pester -Configuration @{
    Run = @{
        Path = './src'
    }
    CodeCoverage = @{
        Enabled = $true
        Path = './src/**/*.ps1'
        OutputPath = './test-results/code-coverage.xml'
    }
    TestResult = @{
        Enabled = $true
        OutputPath = './test-results/unit-tests.xml'
    }
}
```

### Live RDAP Smoke Test Toggle

The integration suite includes a Live RDAP Smoke Tests context. These tests call real RDAP endpoints and are disabled by default to avoid network-dependent failures.

When Invoke-Build IntegrationTests runs:

- If RUN_LIVE_RDAP_TESTS is missing, it is set to false automatically.
- If RUN_LIVE_RDAP_TESTS is false, live smoke tests are skipped.
- If RUN_LIVE_RDAP_TESTS is true, live smoke tests execute.

Enable live smoke tests for the current session:

```powershell
$env:RUN_LIVE_RDAP_TESTS = 'true'
Invoke-Build IntegrationTests
```

Disable live smoke tests explicitly:

```powershell
$env:RUN_LIVE_RDAP_TESTS = 'false'
Invoke-Build IntegrationTests
```

### Test Output Locations

All test results are saved to `test-results/`:

```plaintext
test-results/
├── unit-tests.xml             # Pester test results (NUnit XML)
├── code-coverage.xml          # Code coverage report (Cobertura)
├── static-code-analysis.xml   # PSScriptAnalyzer results
└── code-injection.xml         # InjectionHunter security scan
```

### Writing Quality Tests

#### Test Structure

Use Pester's `Describe`, `Context`, `It` blocks:

```powershell
Describe 'Module-Level Tests' {
    Context 'Specific Feature or Scenario' {
        It 'Should behave in expected way' {
            # Arrange
            $input = 'test'

            # Act
            $result = Get-Something -Name $input

            # Assert
            $result | Should -Not -BeNullOrEmpty
        }
    }
}
```

#### Common Assertions

```powershell
# Equality
$result | Should -Be 'expected'
$result | Should -Not -Be 'unexpected'

# Type checking
$result | Should -BeOfType [string]
$result | Should -BeOfType [System.Collections.Hashtable]

# Null/Empty checks
$result | Should -Not -BeNullOrEmpty
$result | Should -BeNullOrEmpty

# Exceptions
{ Get-Something } | Should -Throw
{ Get-Something } | Should -Throw '*required*'
{ Get-Something } | Should -Not -Throw

# Collection checks
$array | Should -HaveCount 3
$array | Should -Contain 'item'

# Boolean checks
$result | Should -BeTrue
$result | Should -BeFalse
```

#### Mocking External Dependencies

```powershell
BeforeAll {
    # Mock external commands
    Mock Invoke-RestMethod {
        return @{
            Status = 'Success'
            Data = 'Mocked'
        }
    }
}

It 'Should use mocked API call' {
    $result = Get-Something -Name 'Test'
    Should -Invoke Invoke-RestMethod -Exactly 1
}
```

### Code Coverage Goals

- **Target**: 80% or higher code coverage
- **Critical paths**: 100% coverage for error handling
- **Exported functions**: Should have comprehensive test coverage

```powershell
# Check coverage
Invoke-Build UnitTests

# Review coverage report
# Open test-results/code-coverage.xml in coverage viewer
```

## Generating Documentation

### Help Documentation

This project uses PlatyPS to generate documentation in two formats:

1. **Markdown** (`.md`) - For GitHub/web viewing in `docs/help/`
2. **MAML** (`.xml`) - For PowerShell's `Get-Help` command

### Generate Help Files

```powershell
# Generate all help documentation
Invoke-Build Export-CommandHelp
```

This creates:

```plaintext
docs/help/
├── Get-PSScriptModuleInfo.md     # Markdown help
└── Get-Something.md               # One file per function

build/out/YourModuleName/en-US/
└── YourModuleName.dll-Help.xml   # MAML help for Get-Help
```

### Using Generated Help

```powershell
# Import your module
Import-Module ./build/out/YourModuleName/YourModuleName.psd1

# View help
Get-Help Get-Something
Get-Help Get-Something -Full
Get-Help Get-Something -Examples
Get-Help Get-Something -Parameter Name
```

### Updating Help Documentation

1. **Update comment-based help** in your function
2. **Regenerate help files**:

   ```powershell
   Invoke-Build Export-CommandHelp
   ```

3. **Review generated markdown** in `docs/help/`
4. **Commit updated documentation**

### Manual Help Editing

You can manually edit markdown files in `docs/help/` to add:

- Additional examples
- More detailed descriptions
- Related links
- Notes and warnings

After editing, regenerate MAML:

```powershell
Invoke-Build Export-CommandHelp
```

## Code Quality Standards

### PSScriptAnalyzer

All code must pass PSScriptAnalyzer rules:

```powershell
# Run analysis
Invoke-Build PSScriptAnalyzer

# Or directly
Invoke-ScriptAnalyzer -Path ./src -Recurse -Settings ./tests/PSScriptAnalyzer/PSScriptAnalyzerSettings.psd1
```

### Suppressing Rules

Sometimes you need to suppress specific rules:

```powershell
[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingWriteHost',
    '',
    Justification = 'Interactive prompt requires Write-Host'
)]
param()

Write-Host "User prompt message" -ForegroundColor Cyan
```

## Git Workflow

### Branch Strategy

```powershell
# Always work on feature branches
git checkout -b feature/my-feature

# Keep main branch clean
# Only merge through Pull Requests
```

### Commit Messages

Use semantic versioning keywords:

```bash
# New feature (minor version bump)
git commit -m "Add Get-Something function +semver: minor"

# Bug fix (patch version bump)
git commit -m "Fix parameter validation in Get-Something +semver: patch"

# Breaking change (major version bump)
git commit -m "Remove deprecated Get-OldFunction +semver: major"

# Documentation only (no version bump)
git commit -m "Update README examples +semver: none"
```

### Pull Request Process

1. **Create feature branch**
2. **Make changes and commit**
3. **Push to GitHub**:

   ```bash
   git push origin feature/my-feature
   ```

4. **Create Pull Request** on GitHub
5. **Wait for CI checks** to pass:
   - Unit tests
   - Code analysis
   - Security scans
6. **Merge** after approval
7. **Automatic release** triggered on merge to main

## Best Practices

### Function Design

✅ **Do:**

- Use approved PowerShell verbs (`Get-Verb`)
- Include comprehensive help documentation
- Add parameter validation
- Support pipeline input where appropriate
- Implement proper error handling
- Add verbose output for troubleshooting
- Support `-WhatIf` for destructive operations

❌ **Don't:**

- Use aliases in production code
- Hard-code paths or credentials
- Suppress errors without good reason
- Mix output types from same function
- Use positional parameters (always name them)

### Testing Best Practices

✅ **Do:**

- Test both success and failure scenarios
- Test parameter validation
- Test pipeline input
- Mock external dependencies
- Test edge cases (null, empty, invalid input)
- Use descriptive test names

❌ **Don't:**

- Depend on external services in tests
- Share state between tests
- Skip tests (fix or remove them)
- Test implementation details (test behavior)

### Documentation Best Practices

✅ **Do:**

- Include meaningful examples
- Describe all parameters
- Document outputs
- Add notes for special requirements
- Link to related functions

❌ **Don't:**

- Copy-paste example output (show commands only)
- Leave default example text
- Skip parameter descriptions

## Resources

- 📖 [Pester Documentation](https://pester.dev/)
- 📖 [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- 📖 [PlatyPS Documentation](https://github.com/PowerShell/platyPS)
- 📖 [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- 📖 [About Comment-Based Help](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help)

---

**Happy coding! Build great PowerShell modules! 🚀**
