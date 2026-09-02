# Repository security hardening

This repository mirrors the effective security posture of
`A-Town-corp/MCP-Packet-Tracer` as observed on 2026-09-02. GitHub-hosted
settings are separate from committed workflow files and must be audited through
**Settings → Advanced Security** or the GitHub REST API.

## Live parity baseline

| Setting | PTBuilder state after parity work | MCP-Packet-Tracer reference state |
|---|---|---|
| Dependabot vulnerability alerts | Enabled | Enabled |
| Dependabot security updates | Disabled | Disabled |
| Secret scanning | Enabled | Enabled |
| Push protection | Disabled | Disabled |
| Private vulnerability reporting | Enabled | Enabled |
| CodeQL default setup | Configured | Configured |
| Repository auto-merge | Disabled | Disabled |
| Branch protection | None | None |
| Repository rulesets | None | None |
| Default workflow token permission | Read | Read |
| Actions allowed | All actions; SHA pinning not required | All actions; SHA pinning not required |

The disabled states above are recorded for parity, not presented as security
recommendations. If MCP-Packet-Tracer enables another control, update both
repositories together and revise this table in the same pull request.

## Committed controls

| File | Control |
|---|---|
| `.github/dependabot.yml` | Groups weekly GitHub Actions version updates |
| `.github/workflows/ci.yml` | Validates repository security files, JavaScript syntax, and the presence of `Builder.pts` |
| `.github/workflows/dependabot-automerge.yml` | Approves and queues patch-only Dependabot updates without checking out pull-request code |
| `.github/workflows/dependency-review.yml` | Rejects moderate-or-higher vulnerable dependency changes and AGPL-only licenses |
| `.github/workflows/security.yml` | Repeats dependency review on pull requests and runs scheduled source-integrity validation |
| `.github/workflows/codeql.yml` | Preserves the legacy advanced layout but cannot run while default setup owns CodeQL analysis |
| `.github/codeql/codeql-config.yml` | Defines extended queries and excludes generated or vendored artifacts if advanced setup is adopted later |
| `SECURITY.md` | Directs vulnerability reporters to a private GitHub Security Advisory |

## Maintenance rules

- GitHub CodeQL default setup is the active scanner for JavaScript/TypeScript.
- Do not enable the advanced CodeQL workflow while default setup is configured.
- The privileged `pull_request_target` workflow must never check out or execute
  pull-request code.
- The Dependabot workflow attempts approval and squash merge only for patch
  updates. Repository auto-merge and Actions pull-request approval are disabled
  in both parity repositories, so maintainer action may still be required.
  Minor and major updates always require maintainer review.
- `Builder.pts` cannot be rebuilt in CI until an exact Packet Tracer export
  process is documented and verified.

## Future branch-protection parity

Neither reference repository currently protects `main`. If that source setting
changes, mirror its exact ruleset here. PTBuilder's applicable required checks
would be `JavaScript validation`, both `Dependency review` jobs, default CodeQL
for JavaScript/TypeScript, and `Validate source integrity` where GitHub permits
scheduled/push checks to be selected.
