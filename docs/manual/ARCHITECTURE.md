# Architecture

## Repository structure

| Path | Responsibility |
|---|---|
| `source/*.js` | Packet Tracer Builder implementation scripts |
| `source/interface/index.html` | Builder editor user interface |
| `source/interface/interface.js` | Builder editor browser-side behavior |
| `source/interface/bootstrap.bundle.min.js` | Vendored Bootstrap JavaScript distribution |
| `source/interface/bootstrap.min.css` | Vendored Bootstrap stylesheet distribution |
| `Builder.pts` | Generated Packet Tracer script-module artifact installed by users |
| `.github/` | Repository security configuration and GitHub Actions workflows |
| `tests/security-config.tests.ps1` | Cross-platform PowerShell validation for security configuration, JavaScript syntax, and artifact presence |

## Build boundary

The repository contains no documented command that regenerates `Builder.pts`
from `source/`. GitHub Actions therefore validates source syntax and artifact
presence but does not claim to rebuild or byte-compare the Packet Tracer module.
