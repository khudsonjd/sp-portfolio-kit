# Portfolio Rationalization Framework
## A Guide to Legacy SharePoint Architectural Review

**Intended Audience:** Technology Business Systems Consultants, Enterprise Architects, IT Leaders
**Document Purpose:** Provide a reusable framework for conducting structured disposition reviews of legacy SharePoint solutions

---

## 1. What Is a Portfolio Rationalization Review?

Organizations that have built departmental solutions on SharePoint over many years often accumulate a portfolio of aging, underdocumented tools. Over time, these solutions accrue technical debt, create support dependencies, and may no longer align with current business needs or enterprise technology standards.

A Portfolio Rationalization Review is a structured initiative to address this accumulation — systematically evaluating each solution and determining its appropriate future state. It is not merely a technical audit. It is a governance exercise designed to:

- Reduce organizational risk
- Eliminate redundant maintenance overhead
- Identify opportunities to replace one-off builds with modern, repeatable patterns
- Establish a supportable, documented baseline for ongoing operations

This framework is applicable to any organization conducting such a review, regardless of portfolio size.

---

## 2. The Two Objectives of a Rationalization Review

Every legacy solution review should serve two parallel objectives:

**Objective 1 – Strategic Disposition**
Determine, in consultation with enterprise architecture, the appropriate future state for each solution:

- **Sunset** – The underlying business need no longer exists
- **Migrate** – The business need is active and can be met by an existing enterprise-level platform or tool
- **Modernize** – The business need is active and an existing enterprise tool could be modified or rebuilt to meet it
- **Retain & Document** – The solution remains the best fit and should be stabilized and formally documented

**Objective 2 – Operational Documentation**
Document each solution sufficiently so that incoming support requests can be triaged and, where appropriate, resolved without escalation to a developer. Examples of first-line resolvable requests include:

- Adding or removing a user from a SharePoint group
- Directing users to the appropriate entitlements or access request platform
- Making simple configuration changes (e.g., in a DFFS form)
- Escalating to the appropriate developer with sufficient context to minimize turnaround time

---

## 3. CIO-Level Priorities Governing the Review

The following priorities reflect how a CIO or enterprise architect frames a rationalization initiative. Applying this lens ensures that findings and recommendations carry executive credibility and strategic weight — and that the review produces outcomes that are actionable at the leadership level.

### 3.1 Strategic Alignment
- Does each solution still serve an active, clearly defined business need?
- Has the business need evolved such that a different solution would better serve it?
- Does retaining the solution create shadow IT risk or governance debt for the organization?

### 3.2 Total Cost of Ownership (TCO)
- What is the ongoing maintenance burden in terms of licensing, developer time, and support volume?
- What is the risk cost of retaining aging, undocumented solutions?
- How does the cost of migration or sunsetting compare to the cost of continued maintenance?

### 3.3 Risk & Compliance
- Does the solution handle sensitive or regulated data? Is it compliant with current security and access control standards?
- Does it depend on deprecated technology or unsupported third-party components?
- What is the business impact if this solution fails with no documentation and no available developer?

### 3.4 Standardization & Scalability
- Can this solution be replaced by a repeatable, low-complexity enterprise pattern?
- Does it represent a unique one-off build, or a pattern replicated across the organization?
- Is there an opportunity to consolidate multiple similar solutions under a single modern approach?

### 3.5 Developer & Support Dependency
- Is institutional knowledge of this solution locked in a single person?
- Can the solution be triaged and supported without deep SharePoint expertise?
- What is the hand-off readiness of this solution today?

### 3.6 Stakeholder & Change Management
- Who is the current business owner, and are they actively engaged?
- Will sunsetting or migrating this solution create stakeholder friction, and with whom?
- Is there executive sponsorship available to support disposition decisions?

---

## 4. Disposition Decision Guide

| Disposition | Use When | Key Actions |
|---|---|---|
| **Sunset** | Business need no longer exists; no active users | Archive data per retention policy; notify stakeholders; decommission |
| **Migrate** | Active need; existing enterprise tool already meets it | Map functionality to target platform; plan migration; retire legacy solution |
| **Modernize** | Active need; no perfect fit, but a tool could be adapted or a low-complexity pattern applied | Scope rebuild effort; select target pattern; build business case |
| **Retain & Document** | Solution remains best fit; stable and actively used | Complete operational documentation; assign triage ownership; schedule periodic review |

---

## 5. The Case for Low-Complexity Patterns: mDFFS as an Example

A key strategic opportunity in any rationalization review is identifying where a Standardized Low-Complexity Pattern can replace multiple one-off builds. One such pattern worth evaluating for form-centric SharePoint solutions is Modern DFFS (mDFFS).

The case for mDFFS as a modernization target rests on several dimensions that map directly to CIO-level priorities:

| Dimension | mDFFS Advantage |
|---|---|
| Development Cost | Faster to build than Power Apps for form-centric solutions |
| Maintenance Cost | Lower complexity; easier for non-developers to support |
| Standardization | Repeatable pattern applicable across departments |
| TCO | Reduced reliance on licensed Power Platform capacity |
| Risk | Fewer dependencies; less vendor lock-in |

To build an evidence-based case for adopting a low-complexity pattern such as mDFFS, reviewers should capture the following data during the review:

- Developer hours required for each modernization effort
- Licensing costs avoided compared to alternative platforms
- Support ticket volume before and after modernization
- Business owner satisfaction with the rebuilt solution

This data can then be used to present a formal pattern proposal to enterprise architecture — grounded in real cost and effort outcomes rather than theoretical advantages.

---

## 6. Roles & Responsibilities

| Role | Responsibilities |
|---|---|
| Lead Reviewer | Conducts solution assessments; authors disposition recommendations and operational documentation |
| First-Line Support Owner(s) | Co-owns triage process; handles resolvable requests post-review |
| Enterprise Architect | Consulted on Objective 1 disposition decisions; validates alignment with enterprise standards |
| Business Solution Owners | Engaged to confirm whether business need remains active for each solution |
| Developers (per solution) | Serve as escalation targets for complex support requests |

---

## 7. Per-Solution Review Checklist

The following checklist should be completed for each solution in the portfolio:

### Strategic Assessment
- [ ] Identified current business owner and confirmed their engagement
- [ ] Confirmed whether the underlying business need is still active
- [ ] Evaluated whether an existing enterprise platform already meets the need
- [ ] Assessed total cost of ownership (maintenance, licensing, support burden)
- [ ] Assessed risk exposure: sensitive data, compliance, deprecated dependencies
- [ ] Assessed business impact if the solution fails today
- [ ] Determined whether this is a unique build or a repeated pattern across the org
- [ ] Assigned a disposition: Sunset / Migrate / Modernize / Retain & Document

### Operational Documentation
- [ ] Documented solution URL(s) and access points
- [ ] Documented SharePoint groups and permission structure
- [ ] Documented DFFS form configuration (if applicable)
- [ ] Documented workflows and automation (if applicable)
- [ ] Identified the appropriate developer for complex escalations
- [ ] Confirmed first-line support owner has sufficient context to triage independently

---

*This framework is a living reference. It should be adapted as new solutions are reviewed, patterns emerge, and strategic recommendations are validated with enterprise architecture and organizational leadership.*
