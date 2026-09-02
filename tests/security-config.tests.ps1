$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([Parameter(Mandatory)][string]$Message)
    $failures.Add($Message)
}

function Read-RequiredFile {
    param([Parameter(Mandatory)][string]$RelativePath)

    $path = Join-Path $repoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Add-Failure "Missing required file: $RelativePath"
        return ""
    }

    return Get-Content -Raw -LiteralPath $path
}

function Assert-Contains {
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Content,
        [Parameter(Mandatory)][string]$Expected,
        [Parameter(Mandatory)][string]$Context
    )

    if (-not $Content.Contains($Expected, [System.StringComparison]::Ordinal)) {
        Add-Failure "$Context must contain: $Expected"
    }
}

function Assert-NotContains {
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Content,
        [Parameter(Mandatory)][string]$Unexpected,
        [Parameter(Mandatory)][string]$Context
    )

    if ($Content.Contains($Unexpected, [System.StringComparison]::Ordinal)) {
        Add-Failure "$Context must not contain: $Unexpected"
    }
}

$requiredFiles = @(
    ".github/dependabot.yml",
    ".github/SECURITY_HARDENING.md",
    ".github/codeql/codeql-config.yml",
    ".github/workflows/ci.yml",
    ".github/workflows/codeql.yml",
    ".github/workflows/dependabot-automerge.yml",
    ".github/workflows/dependency-review.yml",
    ".github/workflows/security.yml",
    ".gitignore",
    "SECURITY.md"
)

$contents = @{}
foreach ($relativePath in $requiredFiles) {
    $contents[$relativePath] = Read-RequiredFile $relativePath
}

$dependabot = $contents[".github/dependabot.yml"]
Assert-Contains $dependabot 'package-ecosystem: "github-actions"' "Dependabot configuration"
Assert-NotContains $dependabot 'package-ecosystem: "pip"' "Dependabot configuration"
Assert-NotContains $dependabot 'package-ecosystem: "npm"' "Dependabot configuration"

$codeqlConfig = $contents[".github/codeql/codeql-config.yml"]
Assert-Contains $codeqlConfig "security-extended" "CodeQL configuration"
Assert-Contains $codeqlConfig 'source/interface/bootstrap.bundle.min.js' "CodeQL configuration"
Assert-Contains $codeqlConfig 'Builder.pts' "CodeQL configuration"

$ciWorkflow = $contents[".github/workflows/ci.yml"]
Assert-Contains $ciWorkflow "permissions:" "CI workflow"
Assert-Contains $ciWorkflow "contents: read" "CI workflow"
Assert-Contains $ciWorkflow "pwsh -NoProfile -File ./tests/security-config.tests.ps1" "CI workflow"

$codeqlWorkflow = $contents[".github/workflows/codeql.yml"]
Assert-Contains $codeqlWorkflow 'name: "CodeQL advanced setup (disabled)"' "CodeQL workflow"
Assert-Contains $codeqlWorkflow 'if: ${{ false }}' "CodeQL workflow"
Assert-Contains $codeqlWorkflow "javascript-typescript" "CodeQL workflow"
Assert-NotContains $codeqlWorkflow "language: python" "CodeQL workflow"

$autoMergeWorkflow = $contents[".github/workflows/dependabot-automerge.yml"]
Assert-Contains $autoMergeWorkflow "pull_request_target:" "Dependabot auto-merge workflow"
Assert-Contains $autoMergeWorkflow "github.actor == 'dependabot[bot]'" "Dependabot auto-merge workflow"
Assert-Contains $autoMergeWorkflow "version-update:semver-patch" "Dependabot auto-merge workflow"
Assert-NotContains $autoMergeWorkflow "actions/checkout" "Dependabot auto-merge workflow"

foreach ($workflowPath in @(
    ".github/workflows/dependency-review.yml",
    ".github/workflows/security.yml"
)) {
    $workflow = $contents[$workflowPath]
    Assert-Contains $workflow "contents: read" $workflowPath
    Assert-Contains $workflow "fail-on-severity: moderate" $workflowPath
    Assert-Contains $workflow "AGPL-1.0-only, AGPL-3.0-only" $workflowPath
}

$securityPolicy = $contents["SECURITY.md"]
Assert-Contains $securityPolicy "A-Town-corp/PTBuilder/security/advisories/new" "Security policy"
Assert-NotContains $securityPolicy "MCP-Packet-Tracer" "Security policy"

$hardeningGuide = $contents[".github/SECURITY_HARDENING.md"]
foreach ($expectedSetting in @(
    "Dependabot vulnerability alerts | Enabled",
    "Dependabot security updates | Disabled",
    "Secret scanning | Enabled",
    "Push protection | Disabled",
    "Private vulnerability reporting | Enabled",
    "CodeQL default setup | Configured"
)) {
    Assert-Contains $hardeningGuide $expectedSetting "Hardening guide"
}

$gitignore = $contents[".gitignore"]
foreach ($secretPattern in @(".env", "*.pem", "*.key", "*credentials*.json")) {
    Assert-Contains $gitignore $secretPattern ".gitignore"
}

$builderPath = Join-Path $repoRoot "Builder.pts"
if (-not (Test-Path -LiteralPath $builderPath -PathType Leaf)) {
    Add-Failure "Missing Packet Tracer module artifact: Builder.pts"
} elseif ((Get-Item -LiteralPath $builderPath).Length -eq 0) {
    Add-Failure "Packet Tracer module artifact is empty: Builder.pts"
}

$sourceScripts = @(Get-ChildItem -LiteralPath (Join-Path $repoRoot "source") -Recurse -File -Filter "*.js")
if ($sourceScripts.Count -eq 0) {
    Add-Failure "No JavaScript source files were found under source/."
} else {
    foreach ($script in $sourceScripts) {
        & node --check $script.FullName
        if ($LASTEXITCODE -ne 0) {
            Add-Failure "JavaScript syntax check failed: $($script.FullName.Substring($repoRoot.Length + 1))"
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Error ("Security configuration validation failed:`n- " + ($failures -join "`n- "))
    exit 1
}

Write-Output "Security configuration validation passed."
Write-Output "Validated $($requiredFiles.Count) security files, $($sourceScripts.Count) JavaScript files, and Builder.pts."
