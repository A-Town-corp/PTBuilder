# Gotchas

| Constraint | Consequence |
|---|---|
| `Builder.pts` is an opaque 82,248-byte artifact at the 2026-09-02 baseline | CI can verify presence and nonzero size but cannot rebuild it without a documented Packet Tracer export process |
| Bootstrap JavaScript and CSS are vendored under `source/interface/` | Dependabot cannot update them because there is no npm manifest; CodeQL excludes the minified distribution |
| CodeQL default setup is already configured | An active advanced `.github/workflows/codeql.yml` would conflict; the committed legacy workflow must remain manual-only and its analysis job disabled |
| `pull_request_target` receives a privileged token | The Dependabot auto-merge workflow must never check out or execute pull-request code |
| GitHub-hosted settings are not stored in Git | Vulnerability alerts, secret scanning, and private vulnerability reporting require separate API verification after file changes merge |
| MCP-Packet-Tracer's hardening guide is partly aspirational | Branch protection, rulesets, auto-merge, push protection, and Dependabot security updates are currently disabled there and must not be described as active parity controls |
| Actions pull-request approval and repository auto-merge are disabled in both repositories | The copied Dependabot workflow's approval and queued-merge steps cannot be relied upon until those shared settings are enabled in both repositories |
