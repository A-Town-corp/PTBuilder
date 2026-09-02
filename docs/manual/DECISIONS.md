# Decisions

## ADR-001: Tailor security automation to PTBuilder's JavaScript-only source

- **Status:** Accepted on 2026-09-02.
- **Rule:** Mirror MCP-Packet-Tracer's security controls and workflow names, but
  replace Python-only dependency and CI behavior with checks that apply to
  PTBuilder's JavaScript source and `Builder.pts` artifact.
- **Why:** PTBuilder has no `pyproject.toml`, `requirements.txt`, `package.json`,
  or lockfile. Pip, npm, and Python audit jobs would fail or create a false
  impression of dependency coverage.
- **Rejected:** Byte-for-byte workflow copying, because it references nonexistent
  Python packaging and test commands.
- **Rejected:** Creating an npm manifest only to support auditing, because the
  repository does not consume npm dependencies and the Bootstrap files are vendored.

## ADR-002: Preserve CodeQL default setup

- **Status:** Accepted on 2026-09-02.
- **Rule:** Keep GitHub CodeQL default setup as the active scanner and retain a
  manual-only, job-disabled advanced workflow for parity with MCP-Packet-Tracer.
- **Why:** PTBuilder already has a successful JavaScript/TypeScript CodeQL default
  analysis. GitHub prevents simultaneous default and advanced CodeQL setups.
- **Rejected:** Activating `.github/workflows/codeql.yml`, because it would
  duplicate and conflict with the configured default setup.

## ADR-003: Match effective live settings, not aspirational settings

- **Status:** Accepted on 2026-09-02.
- **Rule:** Enable only live controls that are enabled on MCP-Packet-Tracer and
  keep matching disabled controls disabled.
- **Why:** The requested outcome is repository parity. MCP-Packet-Tracer currently
  has no branch protection or rulesets, has repository auto-merge disabled, has
  push protection disabled, and has Dependabot security updates disabled.
- **Rejected:** Applying every recommendation in the source hardening guide,
  because that would make PTBuilder stricter but different.
