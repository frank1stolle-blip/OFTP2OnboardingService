# CLAUDE.md - OFTP2 Onboarding Service

## Project Overview

This is an **OFTP2 partner onboarding automation service** built on Seeburger BIS 6. It transforms minimal partner input parameters (`participantid`, `mode`) into 8 fully-configured OFTP2 configuration records using BIS Mapping Language (XPath/XQuery-based). The project automates what was previously a manual, error-prone process.

**Product Owner:** Frank Stolle
**Platform:** Seeburger BIS 6 (iPaaS or on-premise)
**Protocol:** OFTP2 (Odette File Transfer Protocol v2)

## Repository Structure

```
OFTP2OnboardingService/
├── Template-OFTP2-Onboarding-Mapping.bis  # Main production mapping (813 lines)
├── Template-OFTP2-Identity-Mapping.bis    # Reference identity mapping (761 lines)
├── Template-OFTP2.xml                     # Source XML template (425 lines)
├── BIS_Mapping_Language_Tutorial.pdf      # BIS mapping syntax reference
├── PROJECT_DOCUMENTATION.md               # Comprehensive technical/business docs
├── OFTP2_Onboarding_Presentation.md       # Executive presentation
├── README.md                              # Project overview and quick start
├── mapping-example-by-chatgpt             # Proof-of-concept mapping example
└── CLAUDE.md                              # This file
```

## Technology Stack

- **Platform:** Seeburger BIS 6 (Business Integration Suite)
- **Language:** BIS Mapping Language (XPath/XQuery dialect)
- **Front-end:** CMA (Configuration Management Application)
- **Certificate Management:** KSM (Key Store Manager)
- **Version Control:** Git
- **No traditional build system** - no pom.xml, package.json, Dockerfile, or CI/CD pipelines

## Key Source Files

### Template-OFTP2-Onboarding-Mapping.bis (Production Mapping)
The core mapping file. Transforms `Template-OFTP2.xml` into partner-specific configurations. Key patterns:

- **Input parameters:** `participantid` (partner ID) and `mode` ("create" or "update")
- **Conditional UUID generation:** `create` mode calls `generateUUID()`, `update` mode preserves existing IDs from source XML
- **Type-based XPath predicates** for order-independent record access (not positional)
- **Dynamic certificate aliases:** `concat($participantid, "-partnerauth")` pattern

### Template-OFTP2-Identity-Mapping.bis (Reference Mapping)
One-to-one identity transformation used as a baseline for comparison and testing. Uses positional XPath predicates.

### Template-OFTP2.xml (Source Template)
XML template containing 8 record definitions with sample data, certificates (base64-encoded), and configuration values.

## Architecture & Design Patterns

### Generated Records (8 total)
| # | Type | Dynamic? | Notes |
|---|------|----------|-------|
| 1 | oftp.oftp-partner | Yes | Partner name from participantid |
| 2 | oftp.sfid-partner | Yes | Certificate references from participantid |
| 3 | ksm-entry (auth) | Yes | Alias: `{participantid}-partnerauth` |
| 4 | ksm-entry (eerp) | Yes | Alias: `{participantid}-partnereerp` |
| 5 | ksm-entry (encrypt) | Yes | Alias: `{participantid}-partnerencrypt` |
| 6 | ksm-entry (demoim) | No | Fixed ID: `a8e279ca-cfa9-11ec-8563-ea550a0b1393` |
| 7 | oftp.oftp-listener | No | Fixed ID: `26fcb4c0-37b1-11f0-8e28-c61e7f000101` |
| 8 | oftp.sfid-personality | No | Fixed ID: `273f6310-37b1-11f0-8e28-c61e7f000101` |

Records 1-5 are partner-specific (dynamic IDs and names). Records 6-8 are shared system resources (fixed IDs).

### XPath Strategy
Always use **type-based predicates** (robust, order-independent):
```xpath
record[@type="oftp.oftp-partner"]
record[@type="ksm-entry" and contains(@name, "-partnerauth")]
```
Never use **positional predicates** (fragile, order-dependent):
```xpath
record[1], record[2]  # DO NOT USE
```

### Certificate Path Convention
- **Partner certificates:** `TRUSTED\TRUSTED_INSTANCES\{participantid}-{type}`
- **System certificates:** `USERS\INSTANCES\demoim`
- **KSM API URL:** `https://dedcdbdmgr01:14000/api/ksm/TRUSTED/TRUSTED_INSTANCES/{alias}`

## Development Conventions

### BIS Mapping Style
- Use XQuery-style comments: `(: comment :)`
- Declare all variables at the top of the mapping with `let $varname := ...`
- Group related variable declarations (IDs together, aliases together)
- Include a header comment block listing purpose, source, input parameters, and records structure
- Use descriptive variable names: `$oftp_partner_id`, `$partner_auth_cert_alias`

### Mode Handling Pattern
```xquery
let $id := if ($mode = "update")
  then /transport/records/record[@type="..."]/@rest-identifier
  else generateUUID()
```

### Git Conventions
- Branch-based development with pull requests
- Commit messages describe the change clearly (imperative mood)
- Main branch: `main`

## Important Constraints

1. **No build/test tooling exists** - There are no automated tests, linters, or build scripts. Validation is manual against BIS 6.
2. **BIS Mapping Language is XQuery-based** but with BIS-specific extensions (e.g., `getInputParameter()`, `generateUUID()`). Refer to `BIS_Mapping_Language_Tutorial.pdf` for syntax.
3. **Fixed IDs must never change** - Records 6-8 use hardcoded UUIDs that reference shared system resources. Changing them will break the configuration.
4. **Certificate payloads are base64-encoded** in the XML template - these are real certificate data in the template.
5. **The mapping files (.bis) are not executable outside BIS 6** - they require the Seeburger BIS runtime environment.

## Planned API Endpoints (Not Yet Implemented)
```
POST   /api/v1/partners              # Create new partner
PUT    /api/v1/partners/{participantid}  # Update existing partner
GET    /api/v1/partners/{participantid}  # Retrieve partner config
DELETE /api/v1/partners/{participantid}  # Decommission partner
POST   /api/v1/partners/bulk         # Bulk import
```

## Strategic Roadmap

| Phase | Scope | Status |
|-------|-------|--------|
| Phase 1 | BIS 6 customers - CMA integration, API endpoints | Current (Discovery: 2026-03) |
| Phase 2 | IWS Extension - Integrator Workspace support | Planned |
| Phase 3 | Protocol Expansion - AS2, Communication Gateway | Planned |

## Key Documentation References

- **Full project documentation:** `PROJECT_DOCUMENTATION.md` (requirements, architecture, operations)
- **BIS mapping syntax:** `BIS_Mapping_Language_Tutorial.pdf`
- **Executive overview:** `OFTP2_Onboarding_Presentation.md`
- **Quick start:** `README.md`

## Glossary

| Term | Definition |
|------|------------|
| OFTP2 | Odette File Transfer Protocol version 2 |
| SFID | Secure File ID - signed/encrypted file identification |
| EERP | End-to-End Response - delivery confirmation |
| BIS | Business Integration Suite (Seeburger product) |
| KSM | Key Store Manager - certificate management component |
| CMA | Configuration Management Application - front-end UI |
| IWS | Integrator Workspace - customization platform |
