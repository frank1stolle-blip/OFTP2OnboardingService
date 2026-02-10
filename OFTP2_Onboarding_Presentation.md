# OFTP2 Onboarding Service
## Project Presentation

---

# Agenda

1. Executive Summary
2. Business Case & Value Proposition
3. Monetization Strategy
4. Technical Overview
5. Use Cases
6. Architecture & Design
7. Implementation Roadmap
8. Next Steps

---

# 1. Executive Summary

## Project Vision

**Automate OFTP2 partner onboarding** to reduce manual effort, eliminate errors, and accelerate time-to-value for new trading partners.

## Key Benefits

| Benefit | Impact |
|---------|--------|
| Time Savings | Hours → Minutes |
| Error Reduction | 90%+ reduction |
| Scalability | 10x more partners |
| Compliance | 100% standardized |

---

# Problem Statement

## Current Challenges

- **Manual Configuration**: Each partner requires 8+ configuration records
- **Error-Prone**: Certificate references, IDs, and paths frequently misconfigured
- **Time-Consuming**: Hours per partner onboarding
- **Inconsistent**: No standardized process across teams
- **Audit Risk**: Manual changes hard to track

---

# Solution Overview

## Automated Partner Onboarding

```
Input: participantid + certificates
           ↓
    BIS Mapping Engine
           ↓
Output: 8 configured records
           ↓
    Deploy to OFTP2 System
```

**Key Features:**
- Template-based configuration generation
- Dynamic parameter substitution
- Create & Update modes
- Certificate lifecycle management

---

# 2. Business Case

## Value Proposition

| Stakeholder | Value Delivered |
|-------------|-----------------|
| Operations | 80% reduction in onboarding effort |
| IT | Standardized, auditable configurations |
| Business | Faster partner go-live (days → hours) |
| Finance | Reduced operational costs |
| Compliance | Full audit trail |

---

# ROI Analysis

## Cost Savings Calculation

| Metric | Before | After | Savings |
|--------|--------|-------|---------|
| Time per partner | 4 hours | 15 min | 3.75 hours |
| Error rate | 15% | <1% | 14% |
| Rework time | 2 hours | 0 | 2 hours |
| **Total per partner** | **6 hours** | **15 min** | **5.75 hours** |

**Annual Impact (100 partners/year):**
- 575 hours saved = ~14 weeks of work
- Reduced error-related incidents
- Faster revenue realization

---

# 3. Monetization Strategy

## Pricing Models

| Model | Description | Target |
|-------|-------------|--------|
| **Per-Partner** | Fee per onboarded partner | SMB |
| **Subscription** | Monthly/annual flat fee | Enterprise |
| **Volume Tiers** | Discounted rates at scale | High-volume |
| **Bundled** | Part of EDI package | Existing customers |

---

# Revenue Projections

## 3-Year Outlook

| Year | Partners | Revenue |
|------|----------|---------|
| Year 1 | 50 | TBD |
| Year 2 | 150 | TBD |
| Year 3 | 300 | TBD |

## Target Markets
- Automotive (OEMs, Tier 1-2 suppliers)
- Manufacturing
- Logistics & Transportation
- Retail Supply Chain

---

# 4. Technical Overview

## What Gets Generated

| # | Record Type | Description |
|---|-------------|-------------|
| 1 | oftp.oftp-partner | OFTP v2 partner config |
| 2 | oftp.sfid-partner | SFID partner settings |
| 3 | ksm-entry | Auth certificate |
| 4 | ksm-entry | EERP certificate |
| 5 | ksm-entry | Encryption certificate |
| 6 | ksm-entry | Demoim key (FIXED) |
| 7 | oftp.oftp-listener | Listener (FIXED) |
| 8 | oftp.sfid-personality | Personality (FIXED) |

---

# Input Parameters

## Required Inputs

| Parameter | Description | Example |
|-----------|-------------|---------|
| **participantid** | Unique partner ID | "PARTNER-12345" |
| **mode** | Operation type | "create" or "update" |

## Certificate Inputs

| Certificate | Purpose |
|-------------|---------|
| Partner Auth | Authentication verification |
| Partner EERP | EERP signature verification |
| Partner Encrypt | File encryption |

---

# Create vs Update Mode

## Mode Behavior

```
mode = "create"
├── Generates NEW UUIDs for all partner records
├── Creates new certificate aliases
└── Use for: Initial partner onboarding

mode = "update"
├── PRESERVES existing UUIDs from source
├── Maintains certificate references
└── Use for: Partner updates, cert renewals
```

**Same mapping, different behavior based on mode!**

---

# 5. Use Cases

## UC-01: Create New Partner

**Actor:** System Administrator

**Flow:**
1. Input partner ID (participantid)
2. Upload partner certificates
3. Execute mapping with mode="create"
4. Generate 8 configuration records
5. Deploy to OFTP2 system

**Result:** Partner fully configured and ready

---

# Use Cases (continued)

## UC-02: Update Existing Partner

**Trigger:** Certificate renewal, config change

**Flow:**
1. Input existing partner ID
2. Upload updated certificates (if applicable)
3. Execute mapping with mode="update"
4. Preserve existing UUIDs
5. Update configuration records
6. Deploy changes

**Includes:** Certificate renewal (auth, eerp, encrypt)

**Result:** Partner updated, IDs preserved

---

# Use Cases (continued)

## UC-03: Partner Decommissioning

- Identify partner by ID
- Generate decommission payload
- Remove/disable configuration records
- Archive partner data

## UC-04: Bulk Partner Import

- CSV/Excel upload
- Validate all entries
- Process multiple partners (create or update)
- Generate consolidated report

---

# 6. Architecture

## High-Level Architecture

```
┌─────────────────────────────────────┐
│         Client Layer                │
│  Portal │ Console │ API │ Bulk     │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│         API Gateway                 │
│  Auth │ Rate Limit │ Routing       │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│         Service Layer               │
│  Onboarding │ Certificate │ Config │
│              ↓                      │
│      BIS Mapping Engine             │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│      Integration Layer              │
│  BIS API │ KSM API │ Monitoring    │
└─────────────────────────────────────┘
```

---

# BIS Mapping Design

## XPath Strategy

**Order-independent record access using type predicates:**

```
Before (fragile):
record[1], record[2], record[3]...

After (robust):
record[@type="oftp.oftp-partner"]
record[@type="oftp.sfid-partner"]
record[@type="ksm-entry" and contains(@name, "-partnerauth")]
```

**Why?** Record order in XML is not guaranteed!

---

# Security Design

## Security Measures

| Layer | Mechanism |
|-------|-----------|
| Authentication | OAuth 2.0 / API Keys |
| Authorization | Role-based (Admin, Operator, Viewer) |
| Data at Rest | AES-256 encryption |
| Data in Transit | TLS 1.3 |
| Audit | Full operation logging |
| Secrets | Vault storage |

---

# 7. Implementation Roadmap

## Phase 1: Foundation (Current)
**Target:** BIS 6 On-Premise & iPaaS Customers

- [x] BIS mapping development
- [x] Create/Update mode support
- [x] Type-based XPath predicates
- [x] Project documentation
- [ ] CMA integration
- [ ] API endpoints

---

# Implementation Roadmap (continued)

## Phase 2: IWS Extension
**Target:** Integrator Workspace Customers

- [ ] IWS-compatible service packaging
- [ ] Customization hooks
- [ ] IWS marketplace listing

## Phase 3: Protocol Expansion
**Target:** Broader Communication Needs

- [ ] AS2 protocol support
- [ ] Communication Gateway onboarding
- [ ] Additional protocols (TBD)

---

# 8. Next Steps

## Immediate Actions

1. **Review & Approve** project documentation
2. **Complete** CMA integration for Phase 1
3. **Define** API endpoints specification
4. **Test** with pilot BIS 6 customers
5. **Plan** IWS extension (Phase 2)

## Key Decisions Needed

- CMA integration approach
- API authentication model
- Pilot customer selection
- IWS timeline alignment

---

# Key Metrics & KPIs

## Success Metrics

| Metric | Target |
|--------|--------|
| Onboarding Time | < 15 minutes |
| Error Rate | < 1% |
| System Availability | 99.5% |
| Partner Satisfaction | > 90% |

## Monitoring

- Onboarding success rate
- Processing latency
- Certificate expiry warnings
- API response times

---

# Risk Assessment

## Key Risks & Mitigations

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Low adoption | Medium | Training, easy UI |
| Integration issues | Medium | Phased rollout |
| Certificate errors | Low | Validation layer |
| Performance | Low | Load testing |

---

# Summary

## OFTP2 Onboarding Service

**Problem:** Manual partner onboarding is slow and error-prone

**Solution:** Automated, template-based configuration generation

**Value:**
- 80% time savings
- 90% error reduction
- Scalable to 1000s of partners
- Full audit compliance

**Status:** BIS mapping complete, ready for service layer development

---

# Questions?

## Contact Information

| Role | Name | Email |
|------|------|-------|
| Product Owner | TBD | |
| Technical Lead | TBD | |
| Project Manager | TBD | |

---

# Appendix

## Glossary

| Term | Definition |
|------|------------|
| OFTP2 | Odette File Transfer Protocol v2 |
| SFID | Secure File ID |
| EERP | End-to-End Response |
| BIS | Business Integration Suite |
| KSM | Key Store Manager |
| CMA | Configuration Management Application |
| IWS | Integrator Workspace |
| participantid | Unique identifier for an OFTP2 partner |

---

# Appendix: File Structure

## Repository Contents

```
OFTP2OnboardingService/
├── Template-OFTP2-Onboarding-Mapping.bis
├── Template-OFTP2-Identity-Mapping.bis
├── Template-OFTP2.xml
├── BIS_Mapping_Language_Tutorial.pdf
├── sequence diagram.drawio
├── cma-rest-api-to-iws-config.drawio
├── PROJECT_DOCUMENTATION.md
├── OFTP2_Onboarding_Presentation.md
└── README.md
```

---

# Thank You

## OFTP2 Onboarding Service
### Automating Partner Onboarding

*Document Version: 1.0*
*Date: 2026-02-06*
