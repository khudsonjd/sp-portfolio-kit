# TAPC Portfolio Review Operations Guide
## Everything a Portfolio Manager Needs to Run Recurring SharePoint Portfolio Reviews

**Maintained by:** [Portfolio Manager Name]
**Review cadence:** Quarterly (recommended) or Semi-Annual
**Companion site:** https://sites.google.com/view/et4sp/home

---

## Part 1: Overview & Governance Model

### 1.1 Purpose of This Guide

This guide equips a SharePoint portfolio manager with everything needed to:

- Stand up a repeatable, structured portfolio review process
- Maintain the TAPC catalog as a living document
- Run periodic solution owner surveys via SharePoint
- Communicate clearly and consistently with solution owners and stakeholders
- Escalate findings and recommendations to leadership

### 1.2 The Review Cadence

| Review Type | Frequency | Scope | Audience |
|---|---|---|---|
| **Full Portfolio Review** | Annual | All solutions in catalog | Portfolio manager, EA, team leads |
| **Active Solution Check-In** | Quarterly | Solutions marked Active or Unclear | Portfolio manager, solution owners |
| **Disposition Follow-Up** | After each disposition decision | Solutions recently assigned a disposition | Portfolio manager, affected business owner |
| **New Solution Intake** | As needed | Net-new solutions entering the portfolio | Portfolio manager, requesting team |

### 1.3 Roles in the Review Process

| Role | Responsibility |
|---|---|
| **Portfolio Manager** | Owns the catalog; coordinates surveys; produces review summaries; escalates findings |
| **Solution Owner** | Business-side accountable person for each solution; responds to surveys; confirms business need status |
| **First-Line Support Owner** | Confirms triage readiness; flags documentation gaps |
| **Enterprise Architect (Consulted)** | Validates disposition decisions; advises on modernization patterns |
| **SharePoint Developer (per solution)** | Provides technical input; serves as escalation path |
| **Team Manager** | Receives review summaries; approves priorities; sponsors stakeholder conversations |

---

## Part 2: Standing Up the Review Infrastructure

### 2.1 Checklist: First-Time Setup

Complete these steps once before the first review cycle begins.

**Catalog**
- [ ] Create the TAPC Catalog using the template from the companion site
- [ ] Conduct initial inventory: compile a list of all solutions currently in scope
- [ ] Assign Solution IDs (SP-001, SP-002, etc.) to each solution
- [ ] Populate Section A (Identity) for all solutions
- [ ] Identify known solution owners and IT contacts

**SharePoint Survey List**
- [ ] Create the Solution Owner Survey list in SharePoint (see Part 4 for schema and setup)
- [ ] Configure views: All Responses, By Solution, Awaiting Response, Overdue
- [ ] Test the survey form with one solution before full rollout

**Communication Templates**
- [ ] Save all communication templates from Part 5 to your team's document library
- [ ] Customize all bracketed placeholders ([Organization], [Team Name], etc.)
- [ ] Confirm distribution lists for solution owner communications

**Calendar**
- [ ] Schedule recurring review cycles (quarterly or semi-annual)
- [ ] Set reminder triggers for survey launch dates (4 weeks before review)
- [ ] Set reminder triggers for survey close dates (1 week before review)

---

## Part 3: The Review Cycle — Step by Step

### Phase 1: Pre-Review Preparation (4 Weeks Before Review Date)

**Week -4: Automated Site Discovery (Optional)**
If your enterprise has hundreds of sites, use the `Automate-SiteReview.ps1` script to discover DFFS/mDFFS usage.
- Ensure you have `PnP.PowerShell` and `ImportExcel` modules installed.
- Ensure your `MasterSharePointInventory` list is up to date (see `MasterInventory_Setup.md`).
- Run the script. It will read your inventory list, connect to each site, document DFFS lists, and attach an Excel report to the respective TAPC Catalog entry.
- *Command:* `.\scripts\Automate-SiteReview.ps1 -MasterInventoryUrl [InventoryURL] -CatalogUrl [CatalogURL]`

**Week –4: Catalog Hygiene**
- Review all catalog entries; flag any with missing required fields
- Confirm solution owner contacts are current (check for org changes, departures)
- Add any net-new solutions that have come in via the intake process since the last review
- Update "Last Updated" fields for any solutions that received support tickets since last review

**Week –3: Survey Launch**
- Create a new batch of survey entries in the SharePoint Survey list — one entry per Active or Unclear solution
- Send Survey Launch communication (Template 1) to all solution owners
- Log the survey batch in the catalog (update "Next Review Date" fields)

**Week –2: First Follow-Up**
- Pull the "Awaiting Response" view from the survey list
- Send Survey Reminder communication (Template 2) to non-respondents

**Week –1: Final Push**
- Send Final Reminder communication (Template 3) to any remaining non-respondents
- Flag non-responses to the team manager if the solution is rated Critical or High impact

---

### Phase 2: Review Execution (Review Week)

**Day 1–2: Compile Results**
- Export survey responses from the SharePoint list
- Cross-reference responses against catalog entries; update catalog fields from survey data
- Flag any solutions where survey response conflicts with catalog data (e.g., owner says "no longer used" but catalog says Active)

**Day 3: Disposition Review**
- For each solution with a changed or unclear status, apply the disposition decision guide:
  - Has the business need changed? → Consider Sunset or Migrate
  - Has a better platform become available? → Consider Modernize
  - Is the solution stable and well-documented? → Retain & Document
- Document rationale for all disposition decisions
- Flag any solutions requiring EA consultation (e.g., Modernize candidates)

**Day 4: EA Consultation (if applicable)**
- Share the list of Modernize and Migrate candidates with the Enterprise Architect
- Confirm target platforms and patterns (e.g., mDFFS as the target for form-centric solutions)
- Record EA input in catalog entries

**Day 5: Produce Review Summary**
- Complete the Review Summary Report (see template in Part 6)
- Update the Catalog Metrics table in the catalog
- Prepare the manager briefing (1-page summary of key findings and recommended actions)

---

### Phase 3: Post-Review Actions

**Week +1: Communicate Outcomes**
- Send Disposition Outcome communications (Template 4) to affected solution owners
- Send Post-Review Summary to team manager
- Update the catalog with all confirmed dispositions

**Week +2–4: Action Tracking**
- Create action items in your team's task tracker for each disposition decision requiring work
- Assign owners and due dates
- Set calendar reminders for the next review cycle

---

## Part 4: Solution Owner Survey

### 4.1 Survey Purpose

The Solution Owner Survey collects current, business-side input for each solution at every review cycle. It answers three core questions: Is this solution still needed? Who is using it? Has anything changed?

### 4.2 SharePoint List Column Definitions

Create a SharePoint list named **"TAPC Solution Owner Survey"** with the following columns.

| Column Name | Type | Required | Options / Notes |
|---|---|---|---|
| **Title** | Single line of text | Yes | Auto-populated or set to: "[Solution Name] — [Review Period]" |
| **Solution ID** | Single line of text | Yes | From TAPC catalog (e.g., SP-001) |
| **Solution Name** | Single line of text | Yes | As known to the business |
| **Review Period** | Single line of text | Yes | e.g., "Q1 2026" |
| **Respondent Name** | Single line of text | Yes | Person completing the survey |
| **Respondent Role** | Single line of text | Yes | e.g., Business Owner, Delegate |
| **Response Date** | Date and Time | Yes | |
| **Business Need Status** | Choice | Yes | Active and meeting the need \| Active but needs improvement \| Unclear — needs discussion \| No longer needed |
| **Approximate Active Users** | Number | No | |
| **Usage Frequency** | Choice | Yes | Daily \| Weekly \| Monthly \| Rarely \| Effectively unused |
| **Last Known Active Use** | Date and Time | No | Approximate date of last meaningful use |
| **Business Need Description** | Multiple lines of text | Yes | Ask: "Briefly describe what business problem this solution solves today." |
| **Pain Points or Issues** | Multiple lines of text | No | Ask: "Are there known problems, limitations, or workarounds users rely on?" |
| **Upcoming Business Changes** | Multiple lines of text | No | Ask: "Are there planned changes to your team, process, or requirements that may affect this solution?" |
| **Sensitive Data Handled?** | Choice | Yes | Yes \| No \| Unsure |
| **Sensitive Data Description** | Multiple lines of text | No | If Yes above: describe the type |
| **Owner Engagement Level** | Choice | Yes | Actively engaged \| Occasionally involved \| Minimal — support team manages independently |
| **Recommended Action (Owner View)** | Choice | No | Keep as-is \| Improve or update \| Replace with something else \| Decommission \| Not sure |
| **Owner Comments** | Multiple lines of text | No | Free text for anything not covered above |
| **Survey Status** | Choice | Yes (admin) | Sent \| Responded \| Overdue \| Closed — set by portfolio manager, not solution owner |
| **Portfolio Manager Notes** | Multiple lines of text | No | Admin-only field for internal notes |

---

### 4.3 Recommended SharePoint List Views

| View Name | Filter | Purpose |
|---|---|---|
| **All Responses** | None | Full dataset for the portfolio manager |
| **Awaiting Response** | Survey Status = Sent | Follow-up list |
| **Overdue** | Survey Status = Overdue | Escalation list |
| **Current Period** | Review Period = [current quarter] | Active review data only |
| **By Solution** | Group by: Solution ID | Cross-period history per solution |
| **No Longer Needed** | Business Need Status = No longer needed | Sunset candidates |
| **Active with Issues** | Business Need Status = Active but needs improvement | Modernize candidates |

---

### 4.4 List Schema (JSON — for Import via SharePoint List Formatting)

The following JSON can be used as a starting reference for column configuration in SharePoint. Apply via **List Settings > Columns** or use as a reference when building via PnP PowerShell or the SharePoint admin tools.

```json
{
  "listName": "TAPC Solution Owner Survey",
  "columns": [
    { "name": "Title", "type": "Text", "required": true, "description": "Solution Name — Review Period" },
    { "name": "SolutionID", "type": "Text", "required": true, "description": "From TAPC catalog, e.g. SP-001" },
    { "name": "SolutionName", "type": "Text", "required": true },
    { "name": "ReviewPeriod", "type": "Text", "required": true, "description": "e.g. Q1 2026" },
    { "name": "RespondentName", "type": "Text", "required": true },
    { "name": "RespondentRole", "type": "Text", "required": true },
    { "name": "ResponseDate", "type": "DateTime", "required": true },
    {
      "name": "BusinessNeedStatus",
      "type": "Choice",
      "required": true,
      "choices": [
        "Active and meeting the need",
        "Active but needs improvement",
        "Unclear — needs discussion",
        "No longer needed"
      ]
    },
    { "name": "ApproximateActiveUsers", "type": "Number", "required": false },
    {
      "name": "UsageFrequency",
      "type": "Choice",
      "required": true,
      "choices": ["Daily", "Weekly", "Monthly", "Rarely", "Effectively unused"]
    },
    { "name": "LastKnownActiveUse", "type": "DateTime", "required": false },
    { "name": "BusinessNeedDescription", "type": "Note", "required": true },
    { "name": "PainPointsOrIssues", "type": "Note", "required": false },
    { "name": "UpcomingBusinessChanges", "type": "Note", "required": false },
    {
      "name": "SensitiveDataHandled",
      "type": "Choice",
      "required": true,
      "choices": ["Yes", "No", "Unsure"]
    },
    { "name": "SensitiveDataDescription", "type": "Note", "required": false },
    {
      "name": "OwnerEngagementLevel",
      "type": "Choice",
      "required": true,
      "choices": [
        "Actively engaged",
        "Occasionally involved",
        "Minimal — support team manages independently"
      ]
    },
    {
      "name": "RecommendedAction",
      "type": "Choice",
      "required": false,
      "choices": [
        "Keep as-is",
        "Improve or update",
        "Replace with something else",
        "Decommission",
        "Not sure"
      ]
    },
    { "name": "OwnerComments", "type": "Note", "required": false },
    {
      "name": "SurveyStatus",
      "type": "Choice",
      "required": true,
      "choices": ["Sent", "Responded", "Overdue", "Closed"],
      "description": "Managed by portfolio manager only"
    },
    { "name": "PortfolioManagerNotes", "type": "Note", "required": false }
  ]
}
```

---

## Part 5: Communication Templates

### Template 1 — Survey Launch

> **Subject:** Action Required: SharePoint Solution Review — [Review Period]
>
> Hi [Solution Owner Name],
>
> As part of our ongoing SharePoint portfolio review program, we conduct a brief check-in with solution owners each [quarter/half-year] to confirm the current status of solutions your team uses.
>
> **Your solution:** [Solution Name] (SP-[ID])
> **Survey link:** [SharePoint list form URL]
> **Response deadline:** [Date — 2 weeks from launch]
>
> The survey takes approximately 5 minutes. Your input directly informs how we prioritize support, improvements, and modernization work across the SharePoint portfolio.
>
> If you are no longer the right person to complete this survey, please reply with the name of your delegate and I will update our records.
>
> Thank you,
> [Portfolio Manager Name]
> SharePoint Portfolio Management

---

### Template 2 — Reminder (1 Week Before Deadline)

> **Subject:** Reminder: SharePoint Solution Survey Due [Date]
>
> Hi [Solution Owner Name],
>
> A quick reminder that the SharePoint solution survey for **[Solution Name]** is due by **[Date]**.
>
> **Survey link:** [SharePoint list form URL]
>
> If your solution is no longer in active use, that is important information too — the survey takes just a few minutes either way.
>
> Please reach out if you have any questions.
>
> [Portfolio Manager Name]

---

### Template 3 — Final Reminder (2–3 Days Before Deadline)

> **Subject:** Final Reminder: SharePoint Survey Closes [Date]
>
> Hi [Solution Owner Name],
>
> This is a final reminder — the survey for **[Solution Name]** closes on **[Date]**.
>
> If I do not receive a response by then, I will mark this solution as **status unclear** in the portfolio catalog and flag it for a follow-up conversation.
>
> **Survey link:** [SharePoint list form URL]
>
> [Portfolio Manager Name]

---

### Template 4 — Disposition Outcome Notification

> **Subject:** SharePoint Portfolio Review — Outcome for [Solution Name]
>
> Hi [Solution Owner Name],
>
> Thank you for participating in the [Review Period] SharePoint portfolio review. Based on the survey responses and our team's assessment, the following disposition has been assigned to **[Solution Name]**:
>
> **Disposition:** [Sunset / Migrate / Modernize / Retain & Document]
>
> **What this means:**
> - *Sunset:* We will work with you to archive any data per your retention policy and decommission the solution by [Target Date].
> - *Migrate:* We will connect with you to plan a migration to [Target Platform]. No immediate action is needed on your part.
> - *Modernize:* This solution is a candidate for rebuilding using [mDFFS / other pattern]. We will be in touch to scope the effort.
> - *Retain & Document:* No changes are planned. We will complete operational documentation and confirm the triage process with your team.
>
> If you have questions or concerns about this decision, please reply to this email or contact [Portfolio Manager Name] directly.
>
> Next review for this solution: **[Next Review Date]**
>
> Thank you,
> [Portfolio Manager Name]

---

### Template 5 — New Solution Intake Acknowledgment

> **Subject:** TAPC Intake Received — [Solution Name]
>
> Hi [Requestor Name],
>
> We have received your intake request for **[Solution Name]** and added it to the TAPC catalog as **SP-[ID]**.
>
> To complete the intake, please provide the following information by [Date]:
> - Solution URL(s)
> - Primary business purpose
> - Approximate number of users
> - Platform type (Power Apps / DFFS / mDFFS / Other)
> - Name of the developer or admin who built or maintains it
>
> You can provide this information by completing the intake section of the Solution Owner Survey: [Link]
>
> This solution will be included in the next formal portfolio review on [Review Date].
>
> [Portfolio Manager Name]

---

## Part 6: Review Summary Report Template

*Complete after each review cycle. Share with team manager and file in the portfolio document library.*

---

**TAPC Portfolio Review Summary**
**Review Period:** [Q1/Q2/Q3/Q4 YYYY]
**Review Date:** [Date]
**Prepared by:** [Portfolio Manager Name]

---

### Portfolio Snapshot

| Metric | This Period | Prior Period | Change |
|---|---|---|---|
| Total solutions in catalog | | | |
| Solutions surveyed this cycle | | | |
| Survey response rate | | | |
| Sunset | | | |
| Migrate | | | |
| Modernize | | | |
| Retain & Document | | | |
| Unresolved / Unclear | | | |
| mDFFS pattern candidates | | | |
| Solutions with complete documentation | | | |
| High institutional knowledge risk | | | |

---

### Key Findings This Cycle

*Summarize the 3–5 most significant findings from this review. Examples:*

- [Solution Name] confirmed no longer in active use — Sunset recommended; data archive plan needed.
- [Solution Name] identified as mDFFS pattern candidate — estimated rebuild effort: M (approx. 20 hours).
- [Solution Name] handles PII; compliance review required before next cycle.
- 3 solutions have no identified business owner — follow-up conversations needed.

---

### Recommended Actions

| Action | Solution (if applicable) | Owner | Due Date | Priority |
|---|---|---|---|---|
| | | | | |
| | | | | |

---

### EA Consultation Items

*Solutions requiring Enterprise Architect input before disposition is confirmed:*

| Solution ID | Solution Name | Issue | Status |
|---|---|---|---|
| | | | |

---

### Notes for Next Review Cycle

*Anything the portfolio manager should carry forward into the next cycle:*

---

*End of Review Summary*

---

## Part 7: New Solution Intake Process

When a new SharePoint solution is identified — whether through a support ticket, a team request, or discovery during a review — follow this intake process.

**Step 1:** Assign the next available Solution ID.
**Step 2:** Populate Section A (Identity) of the catalog entry with whatever information is immediately available.
**Step 3:** Send Template 5 (Intake Acknowledgment) to the requestor or solution owner.
**Step 4:** Set Survey Status to "Sent" and target a response within 2 weeks.
**Step 5:** Once intake information is received, complete Sections B and C of the catalog entry.
**Step 6:** Flag the solution for inclusion in the next scheduled review cycle.

New solutions should not be assigned a disposition until they have been through at least one full review cycle, unless there is an urgent business case (e.g., the solution is immediately flagged as sunset-eligible).

---

*This guide is a living document. Update it as your review process matures, as new solution types enter the portfolio, or as organizational governance structures evolve.*
*Published at: https://sites.google.com/view/et4sp/home*
