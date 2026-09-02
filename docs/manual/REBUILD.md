# Rebuild and verification runbook

## Prerequisites

| Tool | Verified baseline |
|---|---|
| Git | 2.55.0.windows.3 |
| Node.js | 26.7.0 locally; GitHub Actions pins Node.js 24 through `actions/setup-node@v7` |
| PowerShell | 7.6.5 locally; `pwsh` is used in GitHub Actions |
| Go | 1.26.5 locally; used to run `actionlint` 1.7.12 without installing it into the repository |
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

Validate GitHub Actions semantics and YAML formatting:

```powershell
go run github.com/rhysd/actionlint/cmd/actionlint@v1.7.12 -color
npx --yes prettier@3.9.6 --check --end-of-line auto ".github/**/*.yml"
```

Expected `actionlint` output: none, with exit code 0.

Expected Prettier output:

```text
Checking formatting...
All matched files use Prettier code style!
```

`--end-of-line auto` is required on this Windows checkout because
`core.autocrlf=true` produces CRLF worktree files from LF Git blobs.

## Packet Tracer artifact

There is no repository-documented command to regenerate `Builder.pts`. Install
the committed artifact through Packet Tracer's **Extensions → Scripting →
Configure PT Script Modules** interface. Do not claim a source-to-artifact
rebuild until an exact export command or UI procedure is documented and tested.
