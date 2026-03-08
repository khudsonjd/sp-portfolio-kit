# Introducing TAPC to Your SharePoint Support Team
## A Proposal for Structured Portfolio Management

**Prepared for:** SharePoint Support Team Manager
**Reference frameworks:** TOGAF 10 Architecture Content Framework · Portfolio Rationalization Framework
**Companion site:** https://sites.google.com/view/et4sp/home

---

## The Problem This Solves

If you manage a SharePoint support team, you already know the pattern: tickets arrive with no context, solutions were built by people who have since left, business owners aren't sure whether their tool is still needed, and every escalation requires a developer because nobody documented how anything works.

This is not a staffing problem. It is a portfolio management problem — and it has a structured solution.

---

## What Is TAPC?

The **TOGAF Application Portfolio Catalog (TAPC)** is a living inventory of SharePoint solutions under your team's support umbrella. Adapted from the TOGAF Architecture Content Framework's concept of an *Application Portfolio Catalog*, TAPC is purpose-built for SharePoint environments where solutions are built using one or more of the following approaches:

| Platform | Description |
|---|---|
| **Power Apps** | Microsoft's low-code application platform, often used to replace or extend SharePoint forms |
| **Classic DFFS** | Dynamic Forms For SharePoint by Alexander Bautz — a mature, configuration-driven form customization tool |
| **mDFFS** | Modern Dynamic Forms For SharePoint by Alexander Bautz — the current-generation successor to classic DFFS, compatible with modern SharePoint |

TAPC gives each of these solutions a structured record — capturing its business purpose, technical profile, ownership, usage status, and recommended disposition.

---

## Why This Matters: The TOGAF Lens

TOGAF's Application Architecture domain asks a straightforward question about every system in your portfolio:

> *"What software do we have, what does it do, and how should it evolve to support our business?"*

Most SharePoint support teams cannot answer that question for more than a handful of their solutions. TAPC is the mechanism for changing that — systematically, and with direct payoff for your team's day-to-day workload.

---

## The Four Dispositions TAPC Drives

Every solution in the catalog is evaluated against four possible future states, drawn from the Portfolio Rationalization Framework:

| Disposition | When It Applies |
|---|---|
| **Sunset** | The business need no longer exists; the solution can be decommissioned |
| **Migrate** | An existing enterprise platform already meets the need; migrate and retire |
| **Modernize** | The need is active; the solution should be rebuilt using a standard pattern (e.g., mDFFS) |
| **Retain & Document** | The solution is the right fit; stabilize it and complete operational documentation |

This framework gives your team — and your stakeholders — a common vocabulary for disposition conversations, and gives leadership a clear picture of where investment is warranted.

---

## What Your Team Gets

Instituting TAPC delivers four concrete outcomes for a SharePoint support team:

### 1. Reduced Escalation Volume
When solutions are documented — with SharePoint group structures, form configurations, workflow logic, and escalation paths recorded — first-line support staff can resolve a larger share of tickets without developer involvement.

### 2. Risk Reduction
Undocumented solutions represent organizational risk. If the developer who built a critical form leaves, and there is no documentation and no catalog entry, the business is exposed. TAPC surfaces that risk before it becomes an incident.

### 3. A Strategic Case for Modernization
When the catalog reveals that multiple solutions are performing similar functions — for example, ten departments each running a custom Power App for a similar approval workflow — it creates an evidence-based case for standardization. mDFFS, as a repeatable, low-complexity pattern, is a strong candidate for consolidation targets. This is a conversation you can take to enterprise architecture with data behind it.

### 4. Defensible Prioritization
With a catalog in place, decisions about which solutions to fix, rebuild, or retire are no longer based on whoever complained most recently. They are based on structured criteria: business criticality, usage, TCO, and risk exposure.

---

## What TAPC Is Not

It is worth being explicit about scope to set realistic expectations:

- TAPC is **not** a full enterprise architecture program. It is a targeted, practical tool for a SharePoint support team.
- It does **not** require TOGAF certification to implement. The TOGAF framing provides credibility and a proven vocabulary, but the day-to-day work is straightforward catalog management.
- It is **not** a one-time project. TAPC is a living catalog, maintained through periodic reviews (recommended quarterly or semi-annually).

---

## How It Works in Practice

**Phase 1 — Inventory (Weeks 1–4)**
Compile an initial list of all SharePoint solutions currently in your support portfolio. For each, capture the minimum viable record: solution name, URL, business owner, platform type (Power Apps / DFFS / mDFFS), and current status (active / dormant / unknown).

**Phase 2 — Assessment (Weeks 5–12)**
Using the per-solution review checklist from the Portfolio Rationalization Framework, conduct structured assessments of each solution. Engage business owners via a standardized survey (available as a SharePoint list template at the companion site). Assign a preliminary disposition to each solution.

**Phase 3 — Documentation (Ongoing)**
Complete operational documentation for all solutions designated Retain & Document. Ensure first-line support staff have what they need to triage independently.

**Phase 4 — Periodic Review (Quarterly or Semi-Annual)**
Recirculate the solution owner survey for active solutions. Update dispositions as business needs evolve. Use catalog data to build the case for modernization investments.

---

## Resources Available at the Companion Site

All supporting assets for TAPC implementation are available at:
**https://sites.google.com/view/et4sp/home**

| Asset | Purpose |
|---|---|
| Portfolio Rationalization Framework | Governance methodology underpinning TAPC |
| TAPC Catalog Template | Excel/SharePoint-ready catalog with all required fields |
| Solution Owner Survey Template | SharePoint list schema + setup instructions |
| Portfolio Review Operations Guide | Everything needed to run recurring reviews |
| Google Site: TCO Comparison | Why mDFFS typically has lower TCO than Power Apps — and how to use that fact |

---

## Recommended First Step

Schedule a 30-minute working session with your team to:

1. Agree on the scope of the initial inventory (which solutions are in scope)
2. Identify who will own the catalog going forward
3. Set a target date for completing Phase 1

The Portfolio Rationalization Framework and TAPC Catalog Template are ready to use today. The survey and review cadence can be stood up in parallel.

---

*TAPC is designed to start small and grow. Even a catalog of ten solutions — assessed, documented, and dispositioned — delivers immediate value to your team and your stakeholders.*
