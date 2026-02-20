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

Enable BIS 6 customers (iPaaS and on premises) to do OFTP2 partner onboardings on their BIS 6.7 with CMA with minimum preparation effort.

A facade is introduced to connect CMA to BIS 6.7. This architectural layer bridges the gap between CMA and the  BIS 6 API. It abstracts the complexity of the underlying BIS 6 Transport API, ensuring that CMA can interact with BIS 6 without requiring extensive development effort on behalf of the customer.

The mentioned facade is implemented using an Integrator Workspace flow, which eliminates the need for any installation on the customer's BIS system. Additionally, this approach demonstrates how IWS can be effectively utilized for integration tasks, in this case between CMA and BIS 6.

### 1.2 Project Scope

#### Phase 1 (Current Focus)
- Adding a **CMA Pro** add on service for **CMA** cloud service customers- Targeting customers with **BIS 6 iPaaS systems** or **on-premises systems**
- The **CMA Pro** add on shall include
  - CMA API (remote API of CMA, e.g. to add participants)
  - CMA API Integration (connecting CMA forms to back-end per API)
  - OFTP2 protocol support (IWS workflow acting as a API facade for BIS 6.7 OFTP2 master data,- OpenAPI definition file to auto create and connect CMA forns to the API facade)
- accept some remaining manual steps to setup the service on Seeburger and on customer side

#### Phase 2 (Future Extension)
- Extend service to **IWS customers** who want to customize in Integrator Workspace
- integrate AI for supporting in case of errors
- fully automate the service setup after bokking it
- Enable self-service customization capabilities

#### Phase 3 (Potential Future)
- Add other communication protocols, e.g.
  - AS2
  - Onboarding to **Cloud Communication Gateway**

### 1.3 Key Stakeholders

- **Product Owner**: Frank Stolle
- **Technical Lead**: TBD
- **Business Analyst**: TBD
- **Operations Lead**: TBD

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
- Manual partner onboarding for complex communication protocols such as OFTP2 is time-consuming and prone to errors.
- Seeburger provides CMA to support partner onboarding; however, preparing onboarding packages with CMA still requires significant effort.
- To increase customer adoption of CMA, an out-of-the-box solution is needed that minimizes configuration effort and enables a short time-to-value for productive use.

### 2.1.2 Solution Overview

* Use the **BIS 6.7 Transport API** to bundle the creation, update, and assignment of all components required for an OFTP2 partner setup into a single API call. The Transport API also provides **built-in rollback**, reverting all changes if an error occurs.
* Encapsulate the business logic around the BIS Transport API in an **Integrator Workspace (IWS) flow**, which acts as a **facade API** callable by any client (in our case, CMA).
* Use **CMA’s API integration** feature to **generate** a CMA form for OFTP2 and connect it to the IWS flow.
* The IWS flow reads the relevant OFTP2 parameters from the CMA form and builds the payload for the BIS Transport API.
* **For new partners**: the flow retrieves an OFTP2 transport template from the customer’s BIS (including all required references and assignments), maps the partner-specific OFTP2 parameters into it, and submits it to BIS via the Transport API.
* **For existing partner updates**: if a transport for the partner already exists, the flow retrieves it from BIS, applies the updated OFTP2 parameters from CMA, and sends the updated transport back to BIS via the Transport API.
* The **facade API** can also be reused to integrate with other platforms or tools.
* Implement the facade using an **Integrator Workspace (IWS) flow** to keep it lightweight and avoid any additional installation on the customer’s BIS 6 system.


#### 2.1.3 Value Proposition

**For Customers:**
- **Out-of-the-Box**: Ready to use with minimal configuration (setup time < 1 day)
- **Time Savings**: Reduced onboarding time from hours to minutes
- **Error Reduction**: Automated validation with 90%+ reduction in errors
- **Flexibility**: CMA front-end OR API integration
- **Scalability**: Handle 10x more partners with same resources

**For Seeburger:**
- **Capability Demonstration**: Show how quickly we can deliver valuable services
- **Competitive Advantage**: Demonstrate superiority over competitors
- **Platform Bridge**: Connect BIS 6 customers to IWS ecosystem
- **Team Showcase**: Highlight team capabilities and agility
- **Future Expansion**: Foundation for AS2, Communication Gateway, etc.

### 2.2 Monetization Strategy

#### 2.2.2 Pricing Model Options

Current price model: 
- BASE:             550 EUR / month including provisioning and up to 20 onboardings / month
- UNLIMITED:      2.500 EUR / month including provisioning and unlimited onboardings
- API ADD-ON:       100 EUR / month usage of CMA API to manage partner onboardings per API

#### 2.2.2 Pricing Model Options

- **Included**: Part of BIS 6 / iPaaS subscription (existing customers)
- **Per-Partner Fee**: Optional charge per partner (high-volume customers)
- **Premium Support**: Enhanced SLA and support (enterprise customers)
- **Customization**: IWS customization services (IWS customers)
New price model
- BASE:             550 EUR / month including provisioning + up to 20 onboardings / month
- ENTERPRISE:     3.000 EUR / month including provisioning + unlimited onboardings + CMA API + OpenAPI integration + Content Packages ("OFTP2 Onboarding for BIS 6", ...)

Expected Revenue: 5.000 EUR x 12 month x 5 customer = 300.000 EUR

#### 2.2.3 Cost Structure

- **Development**: Initial build (BIS mapping, API) — Minimal (internal)
- **Infrastructure**: Hosted as part of existing platform — Marginal
- **Maintenance**: Ongoing support — Low
- **Operations**: Monitoring, updates — Low

**Cost Optimization**: Leverage existing BIS 6/iPaaS infrastructure to minimize incremental costs.

### 2.3 Integration Options

#### 2.3.1 Primary: CMA Front-End
- **Out-of-the-box** partner onboarding experience
- Visual management interface for partner lifecycle
- Certificate upload and validation
- Status monitoring and audit trails
- Minimal configuration required

#### 2.3.2 Alternative: API Integration
- RESTful API for programmatic access
- Enable customers to connect to:
  - Their own portals and tools
  - Third-party platforms
  - Custom automation workflows
- Full feature parity with CMA
- OpenAPI specification available

#### 2.3.3 Future: IWS Customization
- Customers using Integrator Workspace can customize the service
- Extend with custom validation rules
- Add organization-specific workflows
- Integrate with internal systems

### 2.4 Market Analysis

#### 2.4.1 Target Market

**Phase 1 - Primary Targets:**
- **BIS 6 On-Premise**: Existing on-premise customers (BIS 6)
- **BIS 6 iPaaS**: Cloud-hosted BIS customers (iPaaS)

**Phase 2 - Extended Targets:**
- **IWS Customers**: Integrator Workspace users
- **New Customers**: Prospects evaluating Seeburger

**Industry Verticals:**
- Automotive industry (OEMs, Tier 1-2 suppliers)
- Manufacturing companies
- Logistics providers
- Retail supply chain partners

#### 2.4.2 Competitive Landscape

| Competitor | Strengths | Weaknesses | Our Differentiation |
|------------|-----------|------------|---------------------|
| Manual Setup | Flexible | Slow, error-prone | Automated, consistent |
| Custom Scripts | Tailored | Hard to maintain | Supported, upgradable |
| Other Vendors | Existing relationships | Less integrated | Native BIS integration |

#### 2.4.3 Competitive Advantages
- **Speed**: Demonstrate rapid service delivery capability
- **Integration**: Native integration with BIS ecosystem
- **Flexibility**: CMA UI + API + IWS customization options
- **Expertise**: Deep OFTP2 protocol knowledge
- **Foundation**: Expandable to AS2, Communication Gateway

### 2.5 Risk Assessment

#### 2.5.1 Business Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Low adoption | Low | Medium | Include in standard offering, minimize barrier |
| Scope creep | Medium | Medium | Phased approach, clear boundaries per phase |
| Resource constraints | Medium | Low | Leverage existing BIS capabilities |
| Competitor response | Low | Low | Speed to market, native integration |

#### 2.5.2 Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| BIS mapping limitations | Low | Medium | Proven technology, existing patterns |
| Integration complexity | Medium | Medium | API-first design, standard interfaces |
| Certificate handling | Low | High | Leverage existing KSM infrastructure |

#### 2.5.3 Strategic Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| IWS migration delays | Medium | Low | Service works standalone for BIS 6 |
| Protocol expansion complexity | Medium | Medium | Modular design for future protocols |

### 2.6 Strategic Roadmap

#### Phase 1: Foundation (Current)
**Target**: BIS 6 On-Premise & iPaaS Customers
- ✅ BIS Mapping (create/update modes)
- ✅ Type-based XPath predicates
- ✅ Project documentation
- 🔲 CMA integration
- 🔲 API endpoints

#### Phase 2: IWS Extension
**Target**: Integrator Workspace Customers
- 🔲 IWS-compatible service packaging
- 🔲 Customization hooks
- 🔲 IWS marketplace listing

#### Phase 3: Protocol Expansion
**Target**: Broader Communication Needs
- 🔲 AS2 protocol support
- 🔲 Communication Gateway onboarding
- 🔲 Additional protocols (TBD)

---

## 3. Technical Overview

### 3.1 Use Cases

#### UC-01: Create New Partner
- **Actor**: System Administrator
- **Precondition**: Partner data available (certificates, credentials)
- **Trigger**: New partner onboarding request
- **Main Flow**:
  1. Input partner ID (participantid)
  2. Upload partner certificates
  3. Execute mapping with mode="create"
  4. Generate 8 configuration records
  5. Deploy to target system
- **Postcondition**: Partner fully configured in OFTP2 system
- **Alternative Flows**: Certificate validation failure, duplicate partner detection

#### UC-02: Update Existing Partner
- **Actor**: System Administrator
- **Precondition**: Partner already exists in system
- **Trigger**: Partner update request (certificate renewal, config change)
- **Main Flow**:
  1. Input existing partner ID
  2. Upload updated certificates (if applicable)
  3. Execute mapping with mode="update"
  4. Preserve existing UUIDs
  5. Update configuration records
  6. Deploy changes
- **Postcondition**: Partner configuration updated, IDs preserved
- **Includes**: Certificate renewal (auth, eerp, encrypt certificates)

#### UC-03: Partner Decommissioning
- **Actor**: System Administrator
- **Precondition**: Partner to be removed
- **Trigger**: Partner termination request
- **Main Flow**:
  1. Identify partner by ID
  2. Generate decommission payload
  3. Remove/disable configuration records
  4. Archive partner data
- **Postcondition**: Partner removed from active configuration

#### UC-04: Bulk Partner Import
- **Actor**: System Administrator
- **Precondition**: Multiple partners to onboard
- **Trigger**: Bulk import file upload
- **Main Flow**:
  1. Upload CSV/Excel with partner data
  2. Validate all entries
  3. Execute mapping for each partner
  4. Generate consolidated report
- **Postcondition**: Multiple partners configured

### 3.2 Functional Requirements

#### FR-01: Partner Configuration Generation
- FR-01.1: Generate OFTP v2 partner record *(Must)*
- FR-01.2: Generate SFID partner record *(Must)*
- FR-01.3: Generate 3 partner certificate records (auth, eerp, encrypt) *(Must)*
- FR-01.4: Reference fixed demoim private key *(Must)*
- FR-01.5: Reference fixed OFTP listener *(Must)*
- FR-01.6: Reference fixed SFID personality *(Must)*

#### FR-02: Dynamic Parameter Handling
- FR-02.1: Accept participantid as input parameter *(Must)*
- FR-02.2: Support mode parameter (create/update) *(Must)*
- FR-02.3: Generate UUIDs in create mode *(Must)*
- FR-02.4: Preserve UUIDs in update mode *(Must)*
- FR-02.5: Build certificate aliases from participantid *(Must)*

#### FR-03: Certificate Management
- FR-03.1: Store certificates in TRUSTED\TRUSTED_INSTANCES path *(Must)*
- FR-03.2: Generate certificate URLs dynamically *(Must)*
- FR-03.3: Validate certificate format on input *(Should)*
- FR-03.4: Check certificate expiration *(Should)*

#### FR-04: Validation & Error Handling
- FR-04.1: Validate participantid format *(Must)*
- FR-04.2: Detect duplicate partner IDs *(Should)*
- FR-04.3: Validate XML output structure *(Must)*
- FR-04.4: Provide meaningful error messages *(Must)*

### 3.3 Non-Functional Requirements

#### NFR-01: Performance
- NFR-01.1: Single partner onboarding time < 5 seconds
- NFR-01.2: Bulk import (100 partners) < 5 minutes
- NFR-01.3: Mapping transformation time < 1 second

#### NFR-02: Reliability
- NFR-02.1: Service availability 99.5%
- NFR-02.2: Data consistency 100%
- NFR-02.3: Transaction atomicity required

#### NFR-03: Security
- NFR-03.1: Certificate encryption at rest (AES-256)
- NFR-03.2: API authentication (OAuth 2.0 / API Key)
- NFR-03.3: Audit logging for all operations
- NFR-03.4: Role-based access control required

#### NFR-04: Scalability
- NFR-04.1: Concurrent onboarding requests 10+
- NFR-04.2: Total partners supported 10,000+

#### NFR-05: Maintainability
- NFR-05.1: Code documentation complete
- NFR-05.2: Mapping template versioning (Git-based)
- NFR-05.3: Configuration externalization required

---

## 4. Requirements

### 4.1 Input Requirements

#### 4.1.1 Required Input Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| participantid | String | Unique partner identifier | "PARTNER-12345" |
| mode | Enum | Operation mode | "create" or "update" |

#### 4.1.2 Required Certificate Data
- **Partner Auth**: Authentication signature verification (X.509 PEM/DER)
- **Partner EERP**: EERP signature verification (X.509 PEM/DER)
- **Partner Encrypt**: File encryption (X.509 PEM/DER)

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
- **Demoim Private Key**: `a8e279ca-cfa9-11ec-8563-ea550a0b1393`
- **OFTP Listener**: `26fcb4c0-37b1-11f0-8e28-c61e7f000101`
- **SFID Personality**: `273f6310-37b1-11f0-8e28-c61e7f000101`

### 4.3 Integration Requirements

#### 4.3.1 Upstream Systems
- **Partner Portal** (REST API): Partner data input
- **Certificate Authority** (File/API): Certificate import
- **CRM** (REST API): Partner metadata

#### 4.3.2 Downstream Systems
- **Seeburger BIS** (REST API): Configuration deployment
- **Key Store Manager** (REST API): Certificate storage
- **Monitoring** (Events): Status updates

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
- **Admin**: Full CRUD on all partners
- **Operator**: Create, Read, Update
- **Viewer**: Read only

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
├── mappings/                                # BIS mapping files
│   ├── Template-OFTP2-Onboarding-Mapping.bis   # Main onboarding mapping
│   └── Template-OFTP2-Identity-Mapping.bis     # Identity mapping reference
├── templates/                               # XML templates
│   └── Template-OFTP2.xml                      # Source OFTP2 template
├── docs/                                    # Documentation
│   ├── PROJECT_DOCUMENTATION.md                # Full project documentation
│   ├── OFTP2_Onboarding_Presentation.md        # Presentation slides
│   └── diagrams/                               # Architecture diagrams
│       ├── sequence diagram.drawio             # Sequence diagram
│       └── cma-rest-api-to-iws-config.drawio   # CMA to IWS config diagram
├── reference/                               # Reference materials
│   ├── BIS_Mapping_Language_Tutorial.pdf       # BIS mapping guide
│   └── mapping-example-by-chatgpt              # Example mapping
└── README.md                                # Project overview
```

### 6.4 Coding Standards

#### 6.4.1 BIS Mapping Standards
- Use descriptive variable names: `$partner_auth_cert_alias`
- Add comments for complex logic: `(: Comment text :)`
- Use type-based XPath predicates, not positional indexes
- Keep mappings modular and readable

#### 6.4.2 Naming Conventions
- **Variables**: snake_case with $ prefix — e.g. `$partner_auth_cert_id`
- **Certificate aliases**: participantid-suffix — e.g. `ABC123-partnerauth`
- **Record types**: dot notation — e.g. `oftp.oftp-partner`

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
- **New partner**: participantid="TEST-001", mode="create"
- **Update partner**: participantid="TEST-001", mode="update"
- **Special characters**: participantid="TEST_SPECIAL-001"

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
- **ERROR**: Failed operations, exceptions
- **WARN**: Certificate expiry warnings, retries
- **INFO**: Successful onboardings, API calls
- **DEBUG**: Detailed transformation steps

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
- **Mapping files**: Git (continuous) — Permanent retention
- **Partner configurations**: Daily — 30 days retention
- **Certificates**: On change — 1 year retention
- **Audit logs**: Real-time — 7 years retention

#### 7.4.2 Recovery Procedures
- **Mapping rollback:** Git revert to previous version
- **Partner restore:** Replay from backup with mode="update"
- **Full recovery:** Documented DR procedure

### 7.5 Maintenance

#### 7.5.1 Routine Maintenance
- **Certificate expiry check**: Weekly (Automated)
- **Log rotation**: Daily (Automated)
- **Dependency updates**: Monthly (Dev team)
- **Security patching**: As needed (Ops team)

#### 7.5.2 Change Management
- All changes via Git pull requests
- Peer review required
- Staging deployment before production
- Change window: [Define]

---

## 8. Appendix

### 8.1 Glossary

- **OFTP2**: Odette File Transfer Protocol version 2
- **SFID**: Secure File ID - signed/encrypted file identification
- **EERP**: End-to-End Response - delivery confirmation
- **BIS**: Business Integration Suite (Seeburger)
- **KSM**: Key Store Manager
- **CMA**: Configuration Management Application
- **IWS**: Integrator Workspace
- **participantid**: Unique identifier for an OFTP2 partner

### 8.2 Reference Documents

- **BIS Mapping Language Tutorial**: Mapping syntax reference — `reference/BIS_Mapping_Language_Tutorial.pdf`
- **OFTP2 RFC 5024**: Protocol specification — https://tools.ietf.org/html/rfc5024
- **Template-OFTP2.xml**: Source XML template — `templates/Template-OFTP2.xml`

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
*Last updated: 2026-02-18*
