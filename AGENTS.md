# AI Coding Agent Guidelines

All generated code must be **production-ready, maintainable, tested, and auditable**.

---

## Bias

- **Prefer**: explicit, simple, pipeline-friendly, and testable functions
- **Avoid**: aliases, complex abstractions, environment-specific assumptions, and secrets in code

---

## Core Principles

- **Reliability over cleverness** — code must be predictable and behave correctly across all supported platforms
- **Explicit over implicit** — no hidden side effects; validate parameters at every function boundary
- **Tested and auditable** — every function must have tests and pass static analysis before merging

---

## Pre-Codegen Cleanup Rule

- Before any new code generation, remove template/sample scaffold artifacts first (for this repo: `Get-ModuleMetadata*`, `ConvertToHumanReadableSize*`, related generated help, and obsolete placeholder `.gitkeep` files when directories are no longer empty).
- Commit this cleanup as a **separate commit** before adding generated feature code.
- Use `+semver: none` for this cleanup-only commit.

---

## Build & Test Commands

```powershell
# Build module
Invoke-Build -Task Build

# Run all tests (unit + static analysis + security scan)
Invoke-Build -Task Test

# Run unit tests only
Invoke-Build -Task UnitTests

# Run static analysis
Invoke-Build -Task PSScriptAnalyzer

# Run security scan
Invoke-Build -Task InjectionHunter

# Generate help documentation
Invoke-Build -Task Export-CommandHelp

# Clean build output
Invoke-Build -Task Clean
```

---

## Design Principles

- **Fail Fast** — validate at the function boundary, throw immediately on invalid input; never let bad data propagate deeper into the call stack
- **Single Responsibility** — one function, one purpose; if a function needs an "and" to describe what it does, split it
- **Open-Closed** — extend behavior via parameter sets and new private helpers; do not modify working public APIs
- **Least Surprise** — functions must behave like built-in cmdlets: support pipeline where it makes sense, return objects not strings, respect `-WhatIf`, and write to the correct streams

---

## DO / DO NOT

### DO

- Use `[CmdletBinding()]` and `[OutputType()]` on every function
- Use approved PowerShell verbs — verify with `Get-Verb`
- Validate parameters with `[ValidateNotNullOrEmpty()]`, `[ValidateSet()]`, `[ValidateScript()]`, or `[ValidatePattern()]`
- Use `begin`/`process`/`end` blocks for pipeline-accepting functions; collect in `begin`, add in `process`, return in `end`
- Add `SupportsShouldProcess` and call `$PSCmdlet.ShouldProcess()` for destructive operations; omit for read-only functions
- Include comment-based help with `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.INPUTS`, `.OUTPUTS`, and `.EXAMPLE`
- In `catch`, log context with `Write-Verbose "$($MyInvocation.MyCommand) failed for '$Input': $_"` then `throw $_`
- Create a `.Tests.ps1` file alongside every new function

### DO NOT

- Never throw strings — always re-throw the original exception (`throw $_`)
- Never remove or bypass tests, PSScriptAnalyzer, or security scans
- Never use aliases (`Get-ChildItem`, not `gci`)
- Never write secrets, credentials, or environment-specific paths in code
- Never ignore or silently swallow errors
- Never use `Write-Host` — use `Write-Verbose`, `Write-Warning`, or `Write-Error` instead
- Never mix output types from the same function
- Never manually update `FunctionsToExport` in the module manifest — it is populated automatically by the build

---

## File Layout

| Type                    | Location                      | Naming                                                          |
|-------------------------|-------------------------------|-----------------------------------------------------------------|
| Public function + test  | `src/Public/Verb-Noun.ps1`    | `Verb-Noun` — approved verb, hyphen required                    |
| Private function + test | `src/Private/VerbNoun.ps1`    | `VerbNoun` — PascalCase, no hyphen, not exported                |
| Classes                 | `src/Classes/ClassName.ps1`   | `ClassName` — PascalCase; loaded before functions by the build  |

Public functions are automatically exported by the build. Private functions must **not** follow `Verb-Noun` naming to avoid accidental export. Classes are available to all module consumers but are not listed in `FunctionsToExport`.

---

## Testing

- Use Pester 5+
- Mock all external dependencies
- Cover parameter validation, success, and failure scenarios
- Target ≥ 70% code coverage

---

## Commit Messages

Use `+semver:` tags to control version bumps:

| Tag                                     | Effect             |
|-----------------------------------------|--------------------|
| `+semver: breaking` or `+semver: major` | Major version bump |
| `+semver: feature` or `+semver: minor`  | Minor version bump |
| `+semver: fix` or `+semver: patch`      | Patch version bump |
| `+semver: none` or `+semver: skip`      | No bump            |
