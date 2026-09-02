# Project Notebook

## Current task: security parity with MCP-Packet-Tracer

### Problem

PTBuilder has JavaScript source and a generated `Builder.pts` artifact but no
repository-owned security policy, dependency maintenance configuration, or
GitHub Actions workflows. The task is to mirror the security posture added to
`A-Town-corp/MCP-Packet-Tracer` on 2026-09-02 without copying Python-only jobs.

### Evidence gathered

| Evidence | Result |
|---|---|
| Source net change on 2026-09-02 | 11 paths: security policy, hardening guide, CodeQL config, Dependabot config, five workflows, `.gitignore`, and `pyproject.toml` |
| PTBuilder dependency manifests | None; no `package.json`, lockfile, or Python manifest exists |
| PTBuilder implementation | 10 JavaScript files under `source/`; vendored Bootstrap assets are under `source/interface/` |
| CodeQL default setup | Configured for JavaScript/TypeScript; latest analysis completed with zero results |
| Live setting gaps | Vulnerability alerts, secret scanning, and private vulnerability reporting are disabled on PTBuilder but enabled on MCP-Packet-Tracer |

### Options

| Option | Decision | Reason |
|---|---|---|
| Copy source files byte-for-byte | Rejected | Python CI, pip Dependabot, Python audit, and source paths do not exist in PTBuilder |
| Mirror controls and tailor project-specific fields | Selected | Preserves security intent while ensuring every job can run against this repository |
| Enable the source guide's aspirational branch rules and auto-merge settings | Rejected | Those live settings are not enabled on MCP-Packet-Tracer, so enabling them only here would break parity |

### Test-first plan

1. Add `tests/security-config.tests.ps1` and run it before configuration exists.
2. Confirm the test fails only because the expected security files are absent.
3. Commit the RED checkpoint.
4. Add the minimal PTBuilder-specific security configuration.
5. Run the same validator and YAML checks to GREEN.
6. Enable the three live GitHub settings and re-query all compared endpoints.
7. Push a branch, open a pull request, verify Actions, merge, and verify `main`.

## Log

### 2026-09-02

- Cloned both repositories and reviewed all 21 commits on the source repository's
  `main` history dated 2026-09-02 in Europe/Vienna.
- Reduced intermediate add/delete/re-add commits to the effective source-tip state.
- Confirmed PTBuilder has no local test or workflow precedent; MCP-Packet-Tracer is
  the direct precedent for file naming and workflow structure.
- Started the RED stage by adding a configuration validator before production files.
- First validator run failed at parameter binding with `Cannot bind argument to
  parameter 'Content' because it is an empty string.`
- **Debug root cause:** `Read-RequiredFile` returns `""` for an absent expected
  file, but `Assert-Contains` and `Assert-NotContains` declared `Content` as a
  mandatory PowerShell string without `AllowEmptyString`, so PowerShell rejected
  the value before the intended missing-file assertions could be reported.
- **Pattern difference:** No test-harness precedent exists in this repository;
  a minimal standalone PowerShell reproduction confirmed mandatory string
  parameters reject `""` unless `AllowEmptyString` is present.
- **Hypothesis and experiment:** Adding `AllowEmptyString` only to both assertion
  helpers will let the same run reach the accumulated missing-configuration
  failures; rerun the unchanged test scenario and require those failures.
- The corrected RED run reached the intended assertion boundary and reported
  `Security configuration validation failed` with all 10 required security
  files absent. Existing JavaScript syntax and `Builder.pts` validation ran
  without an unrelated failure. This is the RED checkpoint evidence.
- Added the 10 required security files using MCP-Packet-Tracer as the naming and
  workflow precedent, replacing only Python-specific behavior with PTBuilder's
  JavaScript validation and artifact-presence checks.
- The unchanged validator reached GREEN with `Security configuration validation
  passed.` and reported 10 security files, 9 JavaScript files, and `Builder.pts`.
