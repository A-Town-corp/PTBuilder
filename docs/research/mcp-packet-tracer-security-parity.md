# MCP-Packet-Tracer to PTBuilder security parity

**Research date:** 2026-09-02 (Europe/Vienna)  
**Source:** `A-Town-corp/MCP-Packet-Tracer` at `3e856a832a476704edd1686ed733deddf8741916`  
**Target baseline:** `A-Town-corp/PTBuilder` at `1f56a82380a21fde157b73fee6a81928c5784cdb`

## Executive Summary

MCP-Packet-Tracer's `main` history contained **21 commits on 2026-09-02** in
Europe/Vienna, including eight merge commits, ten substantive non-merge commits,
and three plan-only commits. The intermediate commits repeatedly added, removed,
and restored CodeQL files while resolving conflicts between advanced and default
setup. The reliable source for replication is therefore the net tree at the
latest merge, not a replay of every intermediate patch.[^1]

The effective source-tip change adds 10 security/configuration paths and changes
`pyproject.toml`. PTBuilder has no Python package, but it has nine first-party or
vendored JavaScript files plus `Builder.pts`. The port keeps the same security
file and workflow layout while replacing pip/Python jobs with JavaScript syntax,
configuration, and artifact validation. GitHub documents default CodeQL as the
recommended low-maintenance setup and prevents default and advanced setup from
running simultaneously.[^2]

Three GitHub-hosted controls differed and were enabled on PTBuilder: Dependabot
vulnerability alerts/dependency graph, secret scanning, and private vulnerability
reporting. All other audited controls were already equal and were left unchanged.

## 1. Complete source commit inventory for 2026-09-02

Times below are converted to Central European Summer Time (CEST, UTC+02:00).
The inventory comes from the source repository's commit endpoint using the exact
UTC window `2026-09-01T22:00:00Z` through `2026-09-02T21:59:59Z`.[^1]

| CEST | Commit | Kind | Subject |
|---|---|---|---|
| 16:49 | `3e856a832a47` | Merge | Merge pull request #14 from `codex/activate-autofix-with-copilot-feature` |
| 16:48 | `f7f1bb145ee8` | Change | Align package metadata with tested Python versions |
| 16:42 | `1406c7c9997c` | Merge | Merge pull request #13 from `codex/activate-autofix-with-copilot-feature` |
| 16:40 | `514fb8c00552` | Change | Disable duplicate advanced CodeQL runs |
| 16:35 | `a449f1dc17c8` | Merge | Merge pull request #12 from `codex/activate-autofix-with-copilot-feature` |
| 16:35 | `b89aca2b5806` | Change | Defer CodeQL workflow to target branch |
| 16:31 | `f97118b99e59` | Change | Remove duplicate advanced CodeQL workflow |
| 16:14 | `6d950c57f2f3` | Merge | Merge pull request #11 from `codex/activate-autofix-with-copilot-feature` |
| 16:12 | `27d65f9cdf6e` | Change | Avoid conflicts with upstream security configuration |
| 16:01 | `bcc41030fbd8` | Change | Resolve duplicate CodeQL setup conflict |
| 15:52 | `f573e68df62b` | Merge | Merge pull request #9 from `codex/activate-autofix-with-copilot-feature` |
| 15:44 | `a59f467aea73` | Change | Harden security and automate dependency maintenance |
| 14:57 | `6575d3ff0eff` | Merge | Merge pull request #8 from `copilot/setup-codeql-scanning` |
| 14:46 | `e3b11149e799` | Change | Add CodeQL code scanning workflow |
| 14:44 | `7c87dbc7a666` | Plan only | Initial plan |
| 14:37 | `07cf5624d9f4` | Merge | Merge pull request #7 from `copilot/fix-analyze-python-job` |
| 14:33 | `fbfb61b5832d` | Change | fix: remove conflicting CodeQL workflow |
| 14:32 | `d3b51550ad6c` | Plan only | Initial plan |
| 14:28 | `3a3e4ef73ff7` | Merge | Merge pull request #1 from `copilot/configure-security-features` |
| 14:18 | `74e9c8c85874` | Change | Add SECURITY.md, Dependabot config, CodeQL workflow, and .gitignore hardening |
| 14:15 | `80c7c064b676` | Plan only | Initial plan |

## 2. Effective file delta and target treatment

The source-tip files were read in full from the cloned default branch.[^3]

| Source path | Effective source change | PTBuilder treatment |
|---|---|---|
| `.github/dependabot.yml` | Added pip and GitHub Actions updates | Added GitHub Actions updates only; no false npm/pip ecosystem without a manifest |
| `.github/SECURITY_HARDENING.md` | Added administrative runbook | Added an exact parity baseline that distinguishes enabled, disabled, and aspirational controls |
| `.github/codeql/codeql-config.yml` | Added extended query and ignore paths | Added JavaScript-specific generated/vendored ignore paths |
| `.github/workflows/ci.yml` | Added Python 3.11–3.13 test/build matrix | Added Windows JavaScript/configuration/artifact validation |
| `.github/workflows/codeql.yml` | Retained advanced setup as disabled | Retained dispatch-only, unreachable advanced setup for JavaScript while default setup remains active |
| `.github/workflows/dependabot-automerge.yml` | Added patch-only approval/auto-merge | Copied with the privileged no-checkout boundary intact |
| `.github/workflows/dependency-review.yml` | Added moderate-severity and license gate | Copied without project-specific changes |
| `.github/workflows/security.yml` | Added dependency review and scheduled Python audit | Kept dependency review; replaced Python audit with scheduled source-integrity validation |
| `.gitignore` | Added generated/tool/secret patterns | Added applicable JavaScript/tool/secret patterns |
| `SECURITY.md` | Added private reporting policy | Added PTBuilder scope, response targets, and private advisory URL |
| `pyproject.toml` | Aligned Python support and `mcp` constraint | Not applicable; PTBuilder has no Python project metadata |

GitHub's Dependabot documentation explicitly requires `package-ecosystem`,
`directory`, and `schedule.interval`; for Actions, the ecosystem is
`github-actions` and the directory is `/`.[^4]

## 3. GitHub-hosted settings comparison

| Control | MCP-Packet-Tracer | PTBuilder before | PTBuilder after | Action |
|---|---|---|---|---|
| Vulnerability alerts and dependency graph | Enabled | Disabled | Enabled | `PUT /vulnerability-alerts` returned `204` |
| Dependabot security updates | Disabled | Disabled | Disabled | None |
| Secret scanning | Enabled | Disabled | Enabled | Repository PATCH returned `secret_scanning.status=enabled` |
| Secret scanning push protection | Disabled | Disabled | Disabled | None |
| Private vulnerability reporting | Enabled | Disabled | Enabled | `PUT /private-vulnerability-reporting` returned `204` |
| CodeQL default setup | Configured | Configured | Configured | None |
| Default CodeQL query suite | Default | Default | Default | None |
| Actions policy | All; SHA pinning not required | Same | Same | None |
| Default workflow token | Read; PR approval disabled | Same | Same | None |
| Branch protection | None | None | None | None |
| Repository rulesets | None | None | None | None |
| Repository auto-merge | Disabled | Disabled | Disabled | None |

GitHub's repository endpoint documents the nested `security_and_analysis`
update object and the `204` enable contract for vulnerability alerts.[^5]
GitHub documents private vulnerability reporting as a separate admin-only PUT
endpoint with a `204` response.[^5] Secret scanning is available for public
repositories and generates repository-visible alerts for detected credentials.[^6]

## 4. Verification and security review

| Check | Evidence | Result |
|---|---|---|
| Test-first RED | Validator reported all 10 security files missing before implementation | Expected failure |
| Configuration/source GREEN | `pwsh -NoProfile -File .\tests\security-config.tests.ps1` | 10 security files, 9 JavaScript files, and `Builder.pts` validated |
| Workflow semantics | `actionlint` 1.7.12 | No findings |
| YAML parse/style | Prettier 3.9.6 check of `.github/**/*.yml` | All matched files passed |
| JavaScript syntax | `node --check` invoked for every `source/**/*.js` by the validator | 9 of 9 passed |
| Existing CodeQL | Latest PTBuilder default analysis at baseline commit | JavaScript/TypeScript analysis completed with zero results |
| Live settings | Immediate REST read-back after each mutation | All three target settings match the source |
| Open security alerts after enablement | Dependabot, secret-scanning, and CodeQL alert endpoints | 0 open alerts in each category |
| Pull request CI | PTBuilder PR #1 at `2364781b4ac5b25c1ec52ff316124e1d470d7dea` | JavaScript validation passed in 31s; dependency-review jobs passed in 6s and 7s; CodeQL analysis passed in 54s; CodeQL gate passed in 3s |

The privileged Dependabot workflow does not check out or execute pull-request
code. Its permissions are limited to repository content and pull requests, and
its approve/merge steps are guarded by both the Dependabot actor identity and
patch-only metadata. One inherited limitation is explicit: Actions approval and
repository auto-merge are disabled in both repositories, so those steps cannot
be relied upon until the shared settings change.

GitHub states that Copilot Autofix is enabled by default for repositories using
CodeQL and needs no separate enable step.[^7] A repository-level settings endpoint
attempt returned `404` for both repositories, so this finding relies on product
documentation rather than an independent per-repository response.

## 5. Confidence

| Finding | Confidence | Basis |
|---|---|---|
| Today's source commit inventory | High | Complete paginated commit query for the exact local-day UTC window plus local Git history |
| Effective source file delta | High | Full clone, pre-day base calculation, source-tip diff, and full file reads |
| Three live-setting gaps | High | Source/target API comparison, official response contracts, and post-mutation read-back |
| Workflow adaptation | High | Source precedent, PTBuilder tracked-file inventory, RED/GREEN validator, YAML parser, and workflow linter |
| Copilot Autofix repository state | Thin | GitHub documents the default behavior, but the attempted repository endpoint returned `404` for both repos |

The first PR run is available in [PTBuilder pull request #1](https://github.com/A-Town-corp/PTBuilder/pull/1).[^8]

## Research Log

| # | Query | Tool | New sources | What it added |
|---|---|---|---|---|
| 1 | Source metadata and commits in the 2026-09-02 Vienna window | GitHub CLI/API | Source repository and commit endpoint | Established default branch, latest SHA, and all 21 commits |
| 2 | Clone both repos; inspect non-merge history and net source diff | Git + local search | Full source and target Git histories | Separated substantive commits from merges/plans and exposed intermediate reversals |
| 3 | Read source security files and target project shape | Local file reads | 11 source-tip files and PTBuilder tree | Identified Python-only behavior and JavaScript/artifact equivalents |
| 4 | Compare repository, ruleset, branch, Actions, CodeQL, and private-reporting settings | GitHub REST API | 14 source/target endpoint responses | Found initial secret-scanning and private-reporting gaps; established settings already equal |
| 5 | Inspect recent Actions runs and PTBuilder tracked files | GitHub CLI + local Git | Source/target Actions histories | Confirmed successful final source workflows and successful target JavaScript CodeQL |
| 6 | Search current CodeQL, Dependabot, and Autofix documentation | Web search/open | GitHub Docs | Confirmed default setup behavior, Actions ecosystem configuration, and Autofix default |
| 7 | Check alert, security-update, Autofix, property, and analysis endpoints | GitHub REST API | 10 source/target endpoint responses | Found vulnerability-alert mismatch; confirmed security updates disabled and latest analyses |
| 8 | Locate exact vulnerability-alert, secret-scanning, and private-reporting mutation contracts | Web search/find | GitHub REST and secret-scanning docs | Confirmed methods, fields, permissions, and expected responses |

**Totals:** 8 research rounds; 8 web search queries; 29 GitHub API/CLI
endpoint requests during research; 2 repository clones; 25 unique web-result
URLs returned; 11 source-tip files read in full; 7 sources cited.

**Dead ends:** The attempted CodeQL Autofix settings endpoint returned `404` for
both repositories. The first direct open of the private-vulnerability-reporting
documentation returned an internal fetch error; the exact section was recovered
from the consolidated repository REST endpoint page. An initial target `.github`
file search failed because that directory did not yet exist, which established
the absence of target workflow precedent.

## Sources

[^1]: [MCP-Packet-Tracer commits](https://github.com/A-Town-corp/MCP-Packet-Tracer/commits/main/) — Primary commit history used for the 2026-09-02 inventory.
[^2]: [Configuring default setup for code scanning](https://docs.github.com/en/code-security/how-tos/find-and-fix-code-vulnerabilities/configure-code-scanning/configure-code-scanning) — Default-setup eligibility, language detection, and advanced/default interaction.
[^3]: [MCP-Packet-Tracer source tree at the audited SHA](https://github.com/A-Town-corp/MCP-Packet-Tracer/tree/3e856a832a476704edd1686ed733deddf8741916) — Primary source for the effective committed security configuration.
[^4]: [Keeping GitHub Actions up to date with Dependabot](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/auto-update-actions) — Required ecosystem, directory, and schedule settings.
[^5]: [REST API endpoints for repositories](https://docs.github.com/en/rest/repos/repos?apiVersion=latest) — Repository security fields plus vulnerability-alert and private-reporting endpoints.
[^6]: [Enabling secret scanning for a repository](https://docs.github.com/en/code-security/how-tos/secure-your-secrets/detect-secret-leaks/enable-secret-scanning) — Availability and enablement behavior for secret scanning.
[^7]: [About Autofix for code scanning](https://docs.github.com/en/enterprise-cloud@latest/code-security/concepts/code-scanning/autofix-for-code-scanning) — Current CodeQL Autofix availability and default-enable behavior.
[^8]: [PTBuilder pull request #1](https://github.com/A-Town-corp/PTBuilder/pull/1) — Target implementation, review diff, and GitHub-hosted check results.
