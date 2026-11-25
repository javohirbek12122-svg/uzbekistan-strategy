# Security Policy

## Scope
This repository contains the Bilet 023 tournament standings pilot.

## Reporting
Do not disclose vulnerabilities publicly before maintainers can assess them. For a production deployment, the operating organization must publish a monitored security contact and incident-response procedure.

## Security controls in the codebase
- Supabase browser integration uses only a publishable key; service-role keys are prohibited in the browser.
- Row Level Security is mandatory for every tenant-owned table.
- Audit rows are created by database triggers and are not writable by normal authenticated clients.
- The application uses input validation and contextual escaping.
- Vercel response headers include a restrictive Content Security Policy, anti-framing and MIME-sniffing protections.
- No biometric, genetic, passport, phone or other sensitive personal data is required by the tournament workflow.

## Production gate
This project is not security-certified. Before a public-sector production launch, require an independent penetration test, ASVS 5.0 verification plan, dependency/SBOM review, backup-restore exercise, incident-response owner, and a formally approved data-processing and hosting assessment.
