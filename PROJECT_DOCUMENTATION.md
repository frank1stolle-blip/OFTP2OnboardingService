# OFTP2 Onboarding Service - Project Documentation

## Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Business Overview](#2-business-overview)
3. [Technical Overview](#3-technical-overview)
4. [Requirements](#4-requirements)
5. [Architecture & Design](#5-architecture--design)
6. [Development](#6-development)
7. [Operations](#7-operations)
8. [Appendix](#8-appendix)

---

## 1. Executive Summary

### 1.1 Project Vision
<!-- Describe the overall vision and purpose of the OFTP2 Onboarding Service -->

### 1.2 Project Scope
<!-- Define what is in scope and out of scope -->

### 1.3 Key Stakeholders
| Role | Name | Responsibility |
|------|------|----------------|
| Product Owner | | |
| Technical Lead | | |
| Business Analyst | | |
| Operations Lead | | |

### 1.4 Project Timeline
| Phase | Start Date | End Date | Status |
|-------|------------|----------|--------|
| Discovery | | | |
| Design | | | |
| Development | | | |
| Testing | | | |
| Deployment | | | |
| Go-Live | | | |

---

## 2. Business Overview

### 2.1 Business Case

#### 2.1.1 Problem Statement
<!-- What problem does this service solve? -->
- Manual partner onboarding is time-consuming and error-prone
- Complex certificate management across multiple systems
- Lack of standardized onboarding process for OFTP2 partners

#### 2.1.2 Solution Overview
<!-- How does this service address the problem? -->
- Automated partner configuration generation
- Template-based onboarding with dynamic parameter substitution
- Centralized certificate and identity management

#### 2.1.3 Value Proposition
| Benefit | Description | Metric |
|---------|-------------|--------|
| Time Savings | Reduced onboarding time | Hours → Minutes |
| Error Reduction | Automated validation | % reduction in errors |
| Scalability | Handle more partners | Partners per day |
| Compliance | Standardized configurations | Audit compliance % |

### 2.2 Monetization Strategy

#### 2.2.1 Pricing Model Options
| Model | Description | Target Segment |
|-------|-------------|----------------|
| Per-Partner Fee | Charge per partner onboarded | SMB customers |
| Subscription | Monthly/annual flat fee | Enterprise customers |
| Volume Tiers | Discounted rates at scale | High-volume customers |
| Bundled | Part of larger EDI package | Existing customers |

#### 2.2.2 Revenue Projections
| Year | Partners Onboarded | Revenue Target |
|------|-------------------|----------------|
| Year 1 | | |
| Year 2 | | |
| Year 3 | | |

#### 2.2.3 Cost Structure
| Cost Category | Description | Estimated Amount |
|---------------|-------------|------------------|
| Development | Initial build | |
| Infrastructure | Hosting, certificates | |
| Maintenance | Ongoing support | |
| Operations | Staff, monitoring | |

### 2.3 Market Analysis

#### 2.3.1 Target Market
<!-- Who are the target customers? -->
- Automotive industry (OEMs, suppliers)
- Manufacturing companies
- Logistics providers
- Retail supply chain partners

#### 2.3.2 Competitive Landscape
| Competitor | Strengths | Weaknesses | Our Differentiation |
|------------|-----------|------------|---------------------|
| | | | |

#### 2.3.3 Market Size
<!-- TAM, SAM, SOM analysis -->

### 2.4 Risk Assessment

#### 2.4.1 Business Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Low adoption | | | |
| Pricing pressure | | | |
| Regulatory changes | | | |

---

## 3. Technical Overview

### 3.1 Use Cases

#### UC-01: Create New Partner
| Attribute | Description |
|-----------|-------------|
| **Actor** | System Administrator |
| **Precondition** | Partner data available (certificates, credentials) |
| **Trigger** | New partner onboarding request |
| **Main Flow** | 1. Input partner ID (participantid)<br>2. Upload partner certificates<br>3. Execute mapping with mode="create"<br>4. Generate 8 configuration records<br>5. Deploy to target system |
| **Postcondition** | Partner fully configured in OFTP2 system |
| **Alternative Flows** | - Certificate validation failure<br>- Duplicate partner detection |

#### UC-02: Update Existing Partner
| Attribute | Description |
|-----------|-------------|
| **Actor** | System Administrator |
| **Precondition** | Partner already exists in system |
| **Trigger** | Partner update request (certificate renewal, config change) |
| **Main Flow** | 1. Input existing partner ID<br>2. Execute mapping with mode="update"<br>3. Preserve existing UUIDs<br>4. Update configuration records<br>5. Deploy changes |
| **Postcondition** | Partner configuration updated, IDs preserved |

#### UC-03: Certificate Renewal
| Attribute | Description |
|-----------|-------------|
| **Actor** | System Administrator / Automated Process |
| **Precondition** | Certificate expiring or new certificate provided |
| **Trigger** | Certificate renewal request |
| **Main Flow** | 1. Upload new certificate<br>2. Execute update mapping<br>3. Update certificate records (auth, eerp, encrypt)<br>4. Maintain partner relationships |
| **Postcondition** | New certificates active, old references updated |

#### UC-04: Partner Decommissioning
| Attribute | Description |
|-----------|-------------|
| **Actor** | System Administrator |
| **Precondition** | Partner to be removed |
| **Trigger** | Partner termination request |
| **Main Flow** | 1. Identify partner by ID<br>2. Generate decommission payload<br>3. Remove/disable configuration records<br>4. Archive partner data |
| **Postcondition** | Partner removed from active configuration |

#### UC-05: Bulk Partner Import
| Attribute | Description |
|-----------|-------------|
| **Actor** | System Administrator |
| **Precondition** | Multiple partners to onboard |
| **Trigger** | Bulk import file upload |
| **Main Flow** | 1. Upload CSV/Excel with partner data<br>2. Validate all entries<br>3. Execute mapping for each partner<br>4. Generate consolidated report |
| **Postcondition** | Multiple partners configured |

### 3.2 Functional Requirements

#### FR-01: Partner Configuration Generation
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-01.1 | Generate OFTP v2 partner record | Must |
| FR-01.2 | Generate SFID partner record | Must |
| FR-01.3 | Generate 3 partner certificate records (auth, eerp, encrypt) | Must |
| FR-01.4 | Reference fixed demoim private key | Must |
| FR-01.5 | Reference fixed OFTP listener | Must |
| FR-01.6 | Reference fixed SFID personality | Must |

#### FR-02: Dynamic Parameter Handling
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-02.1 | Accept participantid as input parameter | Must |
| FR-02.2 | Support mode parameter (create/update) | Must |
| FR-02.3 | Generate UUIDs in create mode | Must |
| FR-02.4 | Preserve UUIDs in update mode | Must |
| FR-02.5 | Build certificate aliases from participantid | Must |

#### FR-03: Certificate Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-03.1 | Store certificates in TRUSTED\TRUSTED_INSTANCES path | Must |
| FR-03.2 | Generate certificate URLs dynamically | Must |
| FR-03.3 | Validate certificate format on input | Should |
| FR-03.4 | Check certificate expiration | Should |

#### FR-04: Validation & Error Handling
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-04.1 | Validate participantid format | Must |
| FR-04.2 | Detect duplicate partner IDs | Should |
| FR-04.3 | Validate XML output structure | Must |
| FR-04.4 | Provide meaningful error messages | Must |

### 3.3 Non-Functional Requirements

#### NFR-01: Performance
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-01.1 | Single partner onboarding time | < 5 seconds |
| NFR-01.2 | Bulk import (100 partners) | < 5 minutes |
| NFR-01.3 | Mapping transformation time | < 1 second |

#### NFR-02: Reliability
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-02.1 | Service availability | 99.5% |
| NFR-02.2 | Data consistency | 100% |
| NFR-02.3 | Transaction atomicity | Required |

#### NFR-03: Security
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-03.1 | Certificate encryption at rest | AES-256 |
| NFR-03.2 | API authentication | OAuth 2.0 / API Key |
| NFR-03.3 | Audit logging | All operations |
| NFR-03.4 | Role-based access control | Required |

#### NFR-04: Scalability
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-04.1 | Concurrent onboarding requests | 10+ |
| NFR-04.2 | Total partners supported | 10,000+ |

#### NFR-05: Maintainability
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-05.1 | Code documentation | Complete |
| NFR-05.2 | Mapping template versioning | Git-based |
| NFR-05.3 | Configuration externalization | Required |

---

## 4. Requirements

### 4.1 Input Requirements

#### 4.1.1 Required Input Parameters
| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| participantid | String | Unique partner identifier | "PARTNER-12345" |
| mode | Enum | Operation mode | "create" or "update" |

#### 4.1.2 Required Certificate Data
| Certificate | Purpose | Format |
|-------------|---------|--------|
| Partner Auth | Authentication signature verification | X.509 PEM/DER |
| Partner EERP | EERP signature verification | X.509 PEM/DER |
| Partner Encrypt | File encryption | X.509 PEM/DER |

#### 4.1.3 Optional Parameters
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| hostname | String | Partner OFTP server | From template |
| port | Integer | OFTP port | 6619 |
| use-tls | Boolean | TLS enabled | true |

### 4.2 Output Requirements

#### 4.2.1 Generated Records
| Record # | Type | Description |
|----------|------|-------------|
| 1 | oftp.oftp-partner | OFTP v2 partner configuration |
| 2 | oftp.sfid-partner | SFID partner with encryption settings |
| 3 | ksm-entry | Partner authentication certificate |
| 4 | ksm-entry | Partner EERP certificate |
| 5 | ksm-entry | Partner encryption certificate |
| 6 | ksm-entry | Demoim private key (FIXED) |
| 7 | oftp.oftp-listener | OFTP listener (FIXED) |
| 8 | oftp.sfid-personality | SFID personality (FIXED) |

#### 4.2.2 Fixed References
| Component | Fixed ID |
|-----------|----------|
| Demoim Private Key | a8e279ca-cfa9-11ec-8563-ea550a0b1393 |
| OFTP Listener | 26fcb4c0-37b1-11f0-8e28-c61e7f000101 |
| SFID Personality | 273f6310-37b1-11f0-8e28-c61e7f000101 |

### 4.3 Integration Requirements

#### 4.3.1 Upstream Systems
| System | Integration Type | Data Flow |
|--------|------------------|-----------|
| Partner Portal | REST API | Partner data input |
| Certificate Authority | File/API | Certificate import |
| CRM | REST API | Partner metadata |

#### 4.3.2 Downstream Systems
| System | Integration Type | Data Flow |
|--------|------------------|-----------|
| Seeburger BIS | REST API | Configuration deployment |
| Key Store Manager | REST API | Certificate storage |
| Monitoring | Events | Status updates |

---

## 5. Architecture & Design

### 5.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Client Layer                              │
├─────────────────────────────────────────────────────────────────┤
│  Partner Portal  │  Admin Console  │  API Clients  │  Bulk Import│
└────────┬─────────┴────────┬────────┴───────┬───────┴──────┬─────┘
         │                  │                │              │
         ▼                  ▼                ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        API Gateway                               │
│  (Authentication, Rate Limiting, Routing)                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Service Layer                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  Onboarding  │  │  Certificate │  │  Configuration       │  │
│  │  Service     │  │  Service     │  │  Service             │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘  │
│         │                 │                      │              │
│         ▼                 ▼                      ▼              │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              BIS Mapping Engine                          │   │
│  │  (Template-OFTP2-Onboarding-Mapping.bis)                │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Integration Layer                             │
├──────────────────┬──────────────────┬───────────────────────────┤
│  Seeburger BIS   │  Key Store Mgr   │  Audit/Monitoring         │
│  REST API        │  REST API        │  Event Bus                │
└──────────────────┴──────────────────┴───────────────────────────┘
```

### 5.2 Component Design

#### 5.2.1 Onboarding Service
**Responsibilities:**
- Orchestrate partner onboarding workflow
- Validate input parameters
- Invoke BIS mapping engine
- Coordinate with downstream systems

**Interfaces:**
```
POST /api/v1/partners
PUT  /api/v1/partners/{participantid}
GET  /api/v1/partners/{participantid}
DELETE /api/v1/partners/{participantid}
POST /api/v1/partners/bulk
```

#### 5.2.2 Certificate Service
**Responsibilities:**
- Parse and validate certificates
- Extract certificate metadata
- Generate certificate aliases
- Manage certificate lifecycle

#### 5.2.3 Configuration Service
**Responsibilities:**
- Generate transport XML
- Deploy to target systems
- Version configurations
- Rollback support

### 5.3 Data Model

#### 5.3.1 Partner Entity
```
Partner
├── participantid (PK)
├── name
├── status (active/inactive/pending)
├── created_at
├── updated_at
├── certificates[]
│   ├── type (auth/eerp/encrypt)
│   ├── alias
│   ├── valid_from
│   ├── valid_to
│   └── fingerprint
└── configuration
    ├── oftp_partner_id (UUID)
    ├── sfid_partner_id (UUID)
    └── deployed_at
```

#### 5.3.2 Audit Log Entity
```
AuditLog
├── id (PK)
├── timestamp
├── action (create/update/delete)
├── participantid
├── user
├── status (success/failure)
└── details (JSON)
```

### 5.4 BIS Mapping Design

#### 5.4.1 Mapping Structure
```
Template-OFTP2-Onboarding-Mapping.bis
├── Input Parameters
│   ├── participantid
│   └── mode (create/update)
├── Variable Declarations
│   ├── UUID generation (conditional on mode)
│   └── Certificate alias concatenation
├── Transport Root
│   └── Records Collection
│       ├── Record 1: OFTP Partner (dynamic)
│       ├── Record 2: SFID Partner (dynamic)
│       ├── Record 3: Auth Certificate (dynamic)
│       ├── Record 4: EERP Certificate (dynamic)
│       ├── Record 5: Encrypt Certificate (dynamic)
│       ├── Record 6: Demoim Key (fixed)
│       ├── Record 7: OFTP Listener (fixed)
│       └── Record 8: SFID Personality (fixed)
```

#### 5.4.2 XPath Strategy
- Use type-based predicates for order-independent record access
- Example: `record[@type="oftp.oftp-partner"]` instead of `record[1]`

### 5.5 Security Design

#### 5.5.1 Authentication
- API Key authentication for service-to-service
- OAuth 2.0 for user-facing applications
- Certificate-based authentication for OFTP connections

#### 5.5.2 Authorization
| Role | Permissions |
|------|-------------|
| Admin | Full CRUD on all partners |
| Operator | Create, Read, Update |
| Viewer | Read only |

#### 5.5.3 Data Protection
- Certificates encrypted at rest
- TLS 1.3 for all API communications
- Secrets stored in vault

---

## 6. Development

### 6.1 Technology Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Mapping Engine | Seeburger BIS | |
| API Layer | | |
| Database | | |
| Message Queue | | |
| Container | Docker | |
| Orchestration | Kubernetes | |

### 6.2 Development Environment Setup

#### 6.2.1 Prerequisites
- [ ] Seeburger BIS development instance
- [ ] Git repository access
- [ ] IDE with BIS mapping support
- [ ] Docker Desktop

#### 6.2.2 Local Setup Steps
```bash
# Clone repository
git clone <repository-url>
cd OFTP2OnboardingService

# Setup local environment
# (Add specific setup commands)
```

### 6.3 Code Structure

```
OFTP2OnboardingService/
├── mappings/
│   ├── Template-OFTP2-Onboarding-Mapping.bis    # Main onboarding mapping
│   └── Template-OFTP2-Identity-Mapping.bis      # Reference identity mapping
├── templates/
│   └── Template-OFTP2.xml                       # Source XML template
├── tests/
│   ├── unit/
│   └── integration/
├── docs/
│   └── PROJECT_DOCUMENTATION.md
├── config/
│   └── (environment configurations)
└── README.md
```

### 6.4 Coding Standards

#### 6.4.1 BIS Mapping Standards
- Use descriptive variable names: `$partner_auth_cert_alias`
- Add comments for complex logic: `(: Comment text :)`
- Use type-based XPath predicates, not positional indexes
- Keep mappings modular and readable

#### 6.4.2 Naming Conventions
| Element | Convention | Example |
|---------|------------|---------|
| Variables | snake_case with $ prefix | $partner_auth_cert_id |
| Certificate aliases | participantid-suffix | ABC123-partnerauth |
| Record types | dot notation | oftp.oftp-partner |

### 6.5 Testing Strategy

#### 6.5.1 Unit Tests
- Test individual mapping transformations
- Validate XPath expressions
- Test conditional logic (create vs update mode)

#### 6.5.2 Integration Tests
- End-to-end partner onboarding
- Certificate deployment validation
- API contract testing

#### 6.5.3 Test Data
| Scenario | Test Data |
|----------|-----------|
| New partner | participantid="TEST-001", mode="create" |
| Update partner | participantid="TEST-001", mode="update" |
| Special characters | participantid="TEST_SPECIAL-001" |

### 6.6 CI/CD Pipeline

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│  Build  │───▶│  Test   │───▶│  Scan   │───▶│  Stage  │───▶│  Prod   │
└─────────┘    └─────────┘    └─────────┘    └─────────┘    └─────────┘
     │              │              │              │              │
     ▼              ▼              ▼              ▼              ▼
  Compile       Unit Tests    Security      Deploy to      Deploy to
  Mappings      Int Tests     Analysis      Staging        Production
```

---

## 7. Operations

### 7.1 Deployment

#### 7.1.1 Deployment Environments
| Environment | Purpose | URL |
|-------------|---------|-----|
| Development | Developer testing | |
| Staging | Pre-production validation | |
| Production | Live system | |

#### 7.1.2 Deployment Checklist
- [ ] Mapping files validated
- [ ] Template XML verified
- [ ] Fixed IDs confirmed correct for environment
- [ ] API endpoints tested
- [ ] Monitoring alerts configured
- [ ] Rollback plan documented

### 7.2 Monitoring

#### 7.2.1 Key Metrics
| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Onboarding Success Rate | % successful onboardings | < 95% |
| Onboarding Latency | Time to complete | > 10 seconds |
| Error Rate | Failed transformations | > 5% |
| Certificate Expiry | Days until expiry | < 30 days |

#### 7.2.2 Logging
| Log Level | Use Case |
|-----------|----------|
| ERROR | Failed operations, exceptions |
| WARN | Certificate expiry warnings, retries |
| INFO | Successful onboardings, API calls |
| DEBUG | Detailed transformation steps |

### 7.3 Incident Response

#### 7.3.1 Severity Levels
| Severity | Description | Response Time |
|----------|-------------|---------------|
| P1 | Service down, no onboarding possible | 15 minutes |
| P2 | Degraded performance, partial failures | 1 hour |
| P3 | Minor issues, workaround available | 4 hours |
| P4 | Enhancement request | Next sprint |

#### 7.3.2 Escalation Path
1. On-call engineer
2. Team lead
3. Service owner
4. Management

### 7.4 Backup & Recovery

#### 7.4.1 Backup Strategy
| Data | Frequency | Retention |
|------|-----------|-----------|
| Mapping files | Git (continuous) | Permanent |
| Partner configurations | Daily | 30 days |
| Certificates | On change | 1 year |
| Audit logs | Real-time | 7 years |

#### 7.4.2 Recovery Procedures
- **Mapping rollback:** Git revert to previous version
- **Partner restore:** Replay from backup with mode="update"
- **Full recovery:** Documented DR procedure

### 7.5 Maintenance

#### 7.5.1 Routine Maintenance
| Task | Frequency | Owner |
|------|-----------|-------|
| Certificate expiry check | Weekly | Automated |
| Log rotation | Daily | Automated |
| Dependency updates | Monthly | Dev team |
| Security patching | As needed | Ops team |

#### 7.5.2 Change Management
- All changes via Git pull requests
- Peer review required
- Staging deployment before production
- Change window: [Define]

---

## 8. Appendix

### 8.1 Glossary

| Term | Definition |
|------|------------|
| OFTP2 | Odette File Transfer Protocol version 2 |
| SFID | Secure File ID - signed/encrypted file identification |
| EERP | End-to-End Response - delivery confirmation |
| BIS | Business Integration Suite (Seeburger) |
| KSM | Key Store Manager |
| participantid | Unique identifier for an OFTP2 partner |

### 8.2 Reference Documents

| Document | Description | Location |
|----------|-------------|----------|
| BIS Mapping Language Tutorial | Mapping syntax reference | BIS_Mapping_Language_Tutorial.pdf |
| OFTP2 RFC 5024 | Protocol specification | https://tools.ietf.org/html/rfc5024 |
| Template-OFTP2.xml | Source XML template | Repository |

### 8.3 Contact Information

| Role | Name | Email | Phone |
|------|------|-------|-------|
| Product Owner | | | |
| Technical Lead | | | |
| Operations | | | |
| Support | | | |

### 8.4 Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1 | 2026-02-06 | | Initial draft |
| | | | |

---

*Document generated: 2026-02-06*
*Last updated: 2026-02-06*
