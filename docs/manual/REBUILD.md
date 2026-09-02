# Rebuild and verification runbook

## Prerequisites

| Tool | Verified baseline |
|---|---|
| Git | Required to clone and inspect the repository |
| Node.js | Required for `node --check` validation of `source/**/*.js` |
| PowerShell | PowerShell 7 (`pwsh`) is used locally and in GitHub Actions |
| GitHub CLI | `gh` 2.97.0 was used for repository-setting verification on 2026-09-02 |

## Clone

```powershell
git clone https://github.com/A-Town-corp/PTBuilder.git
Set-Location -LiteralPath .\PTBuilder
```

## Validate the repository

```powershell
pwsh -NoProfile -File .\tests\security-config.tests.ps1
```

Expected final output:

```text
Security configuration validation passed.
Validated 10 security files, 9 JavaScript files, and Builder.pts.
```

## Packet Tracer artifact

There is no repository-documented command to regenerate `Builder.pts`. Install
the committed artifact through Packet Tracer's **Extensions → Scripting →
Configure PT Script Modules** interface. Do not claim a source-to-artifact
rebuild until an exact export command or UI procedure is documented and tested.
