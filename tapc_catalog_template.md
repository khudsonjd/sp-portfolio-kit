# TAPC — TOGAF Application Portfolio Catalog
## SharePoint Solutions Registry

*Maintained by:* [Portfolio Manager Name]
*Last reviewed:* [Date]
*Companion site:* https://sites.google.com/view/et4sp/home

---

## How to Use This Catalog

Each row in the catalog represents one SharePoint solution. Complete all fields to the extent information is available. Fields marked **[Required]** must be populated before a disposition can be assigned. Fields marked **[Target]** should be completed during the formal assessment phase.

Use the **Solution Owner Survey** (available as a SharePoint list at the companion site) to collect fields that require input from business stakeholders.

---

## Section A: Solution Identity

| Field | Description | Required? |
|---|---|---|
| **Solution ID** | Unique identifier (e.g., SP-001, SP-002) | Required |
| **Solution Name** | Descriptive name as known by the business | Required |
| **Solution URL(s)** | Full URL(s) to the SharePoint site/list/library | Required |
| **Site Collection** | Parent site collection this solution lives in | Required |
| **Department / Business Unit** | Owning department | Required |
| **Business Owner Name** | Full name of the person accountable for the solution | Required |
| **Business Owner Email** | Contact email | Required |
| **IT Contact / Developer** | Name of developer or admin with deepest knowledge | Required |
| **Date Added to Catalog** | When this entry was created | Required |
| **Last Updated** | Date of most recent catalog update | Required |

---

## Section B: Technical Profile

| Field | Description | Options / Format |
|---|---|---|
| **Platform Type** | Primary technology used to build the solution | Power Apps / Classic DFFS / mDFFS / Native SharePoint / Other |
| **SharePoint Version** | SharePoint environment | SharePoint Online / SharePoint 2019 / SharePoint 2016 / Other |
| **Third-Party Components** | Any non-Microsoft, non-Bautz dependencies | List all; note version if known |
| **SharePoint Groups** | Named permission groups used by this solution | List all group names |
| **Permission Structure** | Summary of access model | e.g., "Owners / Members / Visitors; Members can submit forms" |
| **Workflows / Automation** | Any Power Automate flows, classic workflows, or other automation | List by name/type |
| **External Integrations** | Connections to non-SharePoint systems | List systems; note integration method (API, lookup, etc.) |
| **Handles Sensitive Data?** | Does the solution store PII, financial, regulated, or confidential data? | Yes / No / Unknown |
| **Compliance Notes** | Any known compliance requirements (HIPAA, GDPR, FERPA, etc.) | Free text |
| **Deprecated Dependencies?** | Does the solution rely on deprecated technology? | Yes / No / Unknown — describe if Yes |

---

## Section C: Business Profile

| Field | Description | Options / Format |
|---|---|---|
| **Business Purpose** | One-paragraph description of what this solution does and why it exists | Free text |
| **Active Users (Approx.)** | Estimated number of regular users | Number or range |
| **Usage Frequency** | How often is the solution used? | Daily / Weekly / Monthly / Rarely / Unknown |
| **Last Confirmed Active Date** | When was last confirmed user activity observed? | Date |
| **Business Need Status** | Is the underlying business need still active? | Active / Unclear / No longer active |
| **Business Need Notes** | Context on the status above | Free text |
| **Business Impact if Failed** | What happens if this solution goes down with no documentation? | Critical / High / Medium / Low |
| **Alternative Available?** | Is there an existing enterprise tool that already meets this need? | Yes / No / Partial — describe |

---

## Section D: Cost & Dependency Profile

| Field | Description | Options / Format |
|---|---|---|
| **Licensing Cost (Annual)** | Known licensing cost associated with this solution | Dollar amount or "Unknown" |
| **Licensing Type** | What license applies? | Power Apps per-user / Power Apps per-app / M365 included / No additional license / Other |
| **Developer Hours (Annual Est.)** | Estimated annual developer time for maintenance and support | Hours or "Unknown" |
| **Support Ticket Volume (Annual Est.)** | Estimated tickets per year related to this solution | Number or "Unknown" |
| **Institutional Knowledge Risk** | Is knowledge of this solution locked in one person? | High (one person) / Medium (small team) / Low (documented) |
| **Key Knowledge Holder** | Name of person(s) with deepest solution knowledge | Name(s) |
| **Hand-off Readiness** | Could this solution be supported by a new team member today? | Ready / Partially ready / Not ready |

---

## Section E: Disposition & Modernization

| Field | Description | Options / Format |
|---|---|---|
| **Recommended Disposition** | Outcome of the formal assessment | Sunset / Migrate / Modernize / Retain & Document |
| **Disposition Rationale** | Brief justification for the disposition | Free text |
| **Disposition Confirmed By** | Name of Enterprise Architect or lead reviewer who validated | Name |
| **Disposition Date** | Date disposition was assigned | Date |
| **Target Platform (if Modernize/Migrate)** | What should this solution become? | mDFFS / Native SharePoint / Power Apps / Other enterprise platform |
| **Estimated Modernization Effort** | If modernizing, estimated build effort | Hours / T-shirt size (S/M/L/XL) |
| **Modernization Priority** | Relative priority for modernization work | High / Medium / Low / Deferred |
| **mDFFS Pattern Candidate?** | Could this solution be rebuilt as a standard mDFFS pattern? | Yes / No / Possibly |
| **Next Review Date** | When should this catalog entry be reviewed again? | Date |

---

## Section F: Operational Documentation Status

| Field | Description | Status Options |
|---|---|---|
| **URL(s) Documented** | Solution URL(s) recorded in catalog | Complete / Partial / Not started |
| **Permission Structure Documented** | SharePoint groups and access model documented | Complete / Partial / Not started |
| **Form Configuration Documented** | DFFS / mDFFS / Power Apps config documented | Complete / Partial / Not started / N/A |
| **Workflows Documented** | Automation and workflow logic documented | Complete / Partial / Not started / N/A |
| **Escalation Path Defined** | First-line triage owner and developer escalation path identified | Complete / Not started |
| **First-Line Resolvable?** | Can incoming tickets be triaged without developer involvement? | Yes / Partially / No |
| **Documentation Location** | Where is the operational documentation stored? | URL or file path |

---

## Disposition Summary View

*Use this summary table as the executive-facing view of the full catalog.*

| Solution ID | Solution Name | Department | Platform | Disposition | Priority | Next Review |
|---|---|---|---|---|---|---|
| SP-001 | | | | | | |
| SP-002 | | | | | | |
| SP-003 | | | | | | |

---

## Catalog Metrics (Update Each Review Cycle)

| Metric | Value |
|---|---|
| Total solutions in catalog | |
| Solutions assessed | |
| Sunset | |
| Migrate | |
| Modernize | |
| Retain & Document | |
| mDFFS pattern candidates identified | |
| Solutions with complete operational documentation | |
| Solutions with High institutional knowledge risk | |

---

*This catalog template is aligned with the TOGAF Architecture Content Framework (Application Portfolio Catalog artifact) and the Portfolio Rationalization Framework. It should be reviewed and updated at each portfolio review cycle.*
