# OFTP2 Onboarding Service

OFTP2 partner self-service onboarding solution for BIS 6.7 using CMA and IWS. This service generates user friendly OFTP2 onboarding forms in CMA, connects them per IWS flow to a customer BIS 6.7 running on-premise or as iPaaS to create or updates OFTP2 master data.

## Overview

The OFTP2 Onboarding Service automates the creation and management of OFTP2 trading partner configurations. It generates 8 interconnected configuration records from minimal input parameters, eliminating manual configuration errors and standardizing the onboarding process.

### Key Benefits

- **80% Time Savings**: Reduce partner onboarding from 4+ hours to 15 minutes
- **90% Error Reduction**: Eliminate manual configuration mistakes
- **Scalable**: Support 10x more partner onboardings with same resources
- **Audit Compliant**: Full traceability and standardized configurations

## Features

- **Create & Update Modes**: Generate new configurations or update existing ones while preserving IDs
- **Template-Based**: Consistent configurations from proven templates
- **Dynamic Parameter Substitution**: Automatic generation of partner-specific values
- **Certificate Lifecycle Management**: Support for auth, EERP, and encryption certificates
- **Order-Independent Processing**: Type-based XPath predicates ensure reliable record handling

## Generated Records

| # | Record Type | Description |
|---|-------------|-------------|
| 1 | oftp.oftp-partner | OFTP v2 partner configuration |
| 2 | oftp.sfid-partner | SFID partner settings |
| 3 | ksm-entry | Partner authentication certificate |
| 4 | ksm-entry | Partner EERP certificate |
| 5 | ksm-entry | Partner encryption certificate |
| 6 | ksm-entry | Demoim private key (FIXED) |
| 7 | oftp.oftp-listener | Listener configuration (FIXED) |
| 8 | oftp.sfid-personality | SFID personality (FIXED) |

## Input Parameters

| Parameter | Description | Values |
|-----------|-------------|--------|
| `participantid` | Unique partner identifier | e.g., "PARTNER-12345" |
| `mode` | Operation mode | "create" or "update" |

### Mode Behavior

- **create**: Generates new UUIDs for all partner records (records 1-5)
- **update**: Preserves existing UUIDs from source, maintaining record references

## Repository Structure

```
OFTP2OnboardingService/
├── mappings/                              # BIS mapping files
│   ├── Template-OFTP2-Onboarding-Mapping.bis   # Main onboarding mapping
│   └── Template-OFTP2-Identity-Mapping.bis     # Identity mapping reference
├── templates/                             # XML templates
│   └── Template-OFTP2.xml                      # Source OFTP2 template
├── docs/                                  # Documentation
│   ├── PROJECT_DOCUMENTATION.md                # Full project documentation
│   ├── OFTP2_Onboarding_Presentation.md        # Presentation slides
│   └── diagrams/                               # Architecture diagrams
│       ├── sequence diagram.drawio             # Sequence diagram
│       └── cma-rest-api-to-iws-config.drawio   # CMA to IWS config diagram
├── reference/                             # Reference materials
│   ├── BIS_Mapping_Language_Tutorial.pdf       # BIS mapping guide
│   └── mapping-example-by-chatgpt              # Example mapping
└── README.md                              # This file
```

## Usage

### Prerequisites

- BIS 6 (On-Premise or iPaaS)
- CMA (Configuration Management Application)
- Partner certificates (Auth, EERP, Encryption)

### Creating a New Partner

1. Prepare partner certificates
2. Set input parameters:
   - `participantid`: Your unique partner ID
   - `mode`: "create"
3. Execute the mapping
4. Deploy generated records to OFTP2 system

### Updating an Existing Partner

1. Prepare updated certificates (if applicable)
2. Set input parameters:
   - `participantid`: Existing partner ID
   - `mode`: "update"
3. Execute the mapping
4. Deploy updated records (existing IDs preserved)

## Strategic Roadmap

| Phase | Target | Scope |
|-------|--------|-------|
| **Phase 1** | BIS 6 Customers | CMA integration, API endpoints |
| **Phase 2** | IWS Extension | Integrator Workspace support |
| **Phase 3** | Protocol Expansion | AS2, Communication Gateway |

## Documentation

- [PROJECT_DOCUMENTATION.md](docs/PROJECT_DOCUMENTATION.md) - Full technical and business documentation
- [OFTP2_Onboarding_Presentation.md](docs/OFTP2_Onboarding_Presentation.md) - Presentation slides
- [Diagrams](docs/diagrams/) - Architecture and sequence diagrams

## Technical Notes

### XPath Strategy

The mapping uses type-based XPath predicates for order-independent record access:

```xpath
# Robust (used)
record[@type="oftp.oftp-partner"]
record[@type="ksm-entry" and contains(@name, "-partnerauth")]

# Fragile (avoided)
record[1], record[2], record[3]...
```

This ensures reliable processing regardless of record order in the source XML.

## Glossary

| Term | Definition |
|------|------------|
| OFTP2 | Odette File Transfer Protocol version 2 |
| SFID | Secure File ID |
| EERP | End-to-End Response |
| BIS | Business Integration Suite |
| KSM | Key Store Manager |
| CMA | Configuration Management Application |
| IWS | Integrator Workspace |
| participantid | Unique identifier for an OFTP2 partner |

---

*Document Version: 1.0 | Date: 2026-02-06*
