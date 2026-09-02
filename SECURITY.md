# Security Policy

## Supported Versions

Packet Tracer Builder is maintained on the `main` branch. Security fixes apply
to the latest committed `Builder.pts` artifact and its corresponding source.
Older commits are not guaranteed to receive backported fixes.

| Version | Supported |
|---|---|
| Latest (`main`) | :white_check_mark: |
| Older commits | :x: |

## Reporting a Vulnerability

Do not open a public GitHub issue for a suspected security vulnerability.
Instead, use GitHub's private
[Report a vulnerability](https://github.com/A-Town-corp/PTBuilder/security/advisories/new)
form. This creates a private repository security advisory visible only to the
reporter and repository maintainers until coordinated disclosure.

Include enough evidence to reproduce and assess the report:

- A description of the vulnerability and its expected impact.
- Exact reproduction steps, including affected Builder functions or files.
- Proof-of-concept code, logs, or screenshots with credentials redacted.
- The tested commit SHA and Packet Tracer version.

## Response Targets

- **Acknowledgement:** Maintainers aim to acknowledge a new report within five
  business days.
- **Assessment:** Maintainers investigate the report and may request additional
  reproduction details.
- **Fix and disclosure:** Maintainers coordinate a fix and public disclosure,
  crediting the reporter unless anonymity is requested.

Do not disclose vulnerability details publicly before a fix is available or
the maintainers agree to disclosure.

## Scope

This policy covers:

- The JavaScript implementation under `source/`.
- The browser interface under `source/interface/`.
- The distributed `Builder.pts` Packet Tracer script-module artifact.
- Repository automation under `.github/`.

Cisco Packet Tracer itself is proprietary Cisco software and is outside this
repository's scope.

## Preventive Measures

- GitHub CodeQL default setup scans JavaScript/TypeScript changes.
- Dependabot groups weekly GitHub Actions version updates.
- Dependency review rejects new moderate-or-higher vulnerable dependencies and
  disallowed AGPL-only licenses.
- Patch-only Dependabot updates can be approved and queued without executing
  untrusted pull-request code.
- CI checks JavaScript syntax, the repository security configuration, and the
  presence of the distributed `Builder.pts` artifact.
- GitHub vulnerability alerts, secret scanning, and private vulnerability
  reporting are enabled.

The exact GitHub-hosted and committed controls are recorded in the
[repository hardening guide](.github/SECURITY_HARDENING.md).

Thank you for helping keep Packet Tracer Builder and its users safe.
