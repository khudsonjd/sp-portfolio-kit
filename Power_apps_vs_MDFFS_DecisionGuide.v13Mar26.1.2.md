# Power Apps vs. mDFFS: Form Platform Decision Guide
**Version:** v13Mar26.1.2
**Project:** sp-portfolio-kit — Think Like an Enterprise Architect
**Companion site:** https://sites.google.com/view/et4sp/home

---

## The Core Distinction

**mDFFS** customizes the *native SharePoint list form* — the form you already get when you open a SharePoint list. It adds conditional logic, tabs, field rules, and JavaScript automation on top of what's already there.

**Power Apps** *replaces* the SharePoint list form entirely with a custom-built application that happens to write back to a SharePoint list.

Think of it this way: mDFFS is like renovating the kitchen you already have. Power Apps is like tearing it out and building a completely new one.

---

## Decision Points That Favor Power Apps

**1. The form needs to look and feel like an app, not a list.**
If users expect a multi-screen experience — where clicking a button navigates to a different "page," shows a map, or launches a camera — Power Apps is the right tool. mDFFS forms are still recognizably SharePoint forms.

**2. The form must connect to data outside SharePoint.**
If the form needs to read from or write to systems like Dataverse, SQL Server, Salesforce, or an external API at the time the user fills it out, Power Apps handles this natively. mDFFS works only with the SharePoint list it's installed on.

**3. No one in the business knows how to use mDFFS.**
Power Apps uses a formula language similar to Excel, which is advertised as allowing non-developers to develop power apps. If no one in the enterprise has or is willing to gain experience with mDFFS, Power Apps may be a reasonable (albeit more expensive) alternative to mDFFS. This is a team and enterprise capability question, not a platform capability question.

**4. The form will be embedded in Teams, a Power Apps portal, or a non-SharePoint surface.**
Power Apps can be embedded almost anywhere in the Microsoft 365 ecosystem. mDFFS only works on the SharePoint list form page.

**5. The organization has already standardized on Power Apps and there is no significant mDFFS footprint and no vision to change that.**
If Power Apps is the only form customization tool in use and no one on the team has mDFFS experience, the switching cost may be seen as not worth it for a single new solution. This is a pragmatic consideration, not an endorsement of Power Apps as the better platform. In most enterprises, what starts out as "we just need one new solution" quickly cascades to dozens.

---

## Decision Points That Favor mDFFS

**1. The data model is already a SharePoint list and you want to keep it that way.**
mDFFS adds zero infrastructure — no Dataverse environment, no additional per-use or per-user licensing, no need to pay for custom connectors, no new app to deploy. The data stays exactly where it is.

**2. The team needs to modify the form configuration in a repeatable, version-controlled way.**
mDFFS stores its configuration as JSON, which can be exported, committed to a repository, and deployed via script. Power Apps form configuration is managed through a graphical editor and exported as a solution package — harder to diff, review, and automate. Some teams use PowerShell scripts to automate deployment across Dev/UAT/Prod environments, reducing human error and mimicking a pipeline experience.

**3. The form requires sophisticated automation and the team includes JavaScript developers.**
mDFFS supports JavaScript directly, giving developers full programmatic control over form behavior. JavaScript is widely understood, transferable across projects, and can be maintained in a single unified codebase alongside other team assets. By contrast, Power Apps uses a proprietary formula language that does not transfer outside the Power Platform — skills and code built in Power Apps stay in Power Apps.

**4. Long-term platform stability matters.**
mDFFS runs on SPFx (SharePoint Framework), which is a Microsoft-supported extensibility layer for SharePoint Online with no credible signal of deprecation. Power Apps, by contrast, has already seen significant pivots in its roadmap. Organizations with long institutional memory will note a pattern: Microsoft periodically rebrands or restructures its low-code tools in ways that create migration work and licensing pressure for existing customers. Betting a large form portfolio on a platform with that track record carries real risk.

**5. Total cost of ownership matters.**
mDFFS is a one-time solution deployment. Power Apps canvas apps require Premium licensing per user if connecting to non-SharePoint data sources, and the licensing model is subject to change — and has changed before.

**6. The organization has an active mDFFS or DFFS footprint, or a citizen developer community willing to learn it.**
An existing mDFFS practice — even a small one — is a meaningful asset. The skills, configurations, and patterns built for one solution transfer directly to the next. If the enterprise has citizen developers willing to learn mDFFS, the long-term sustainability case is strong and does not depend on any single vendor's licensing decisions.

**7. The form complexity is primarily about layout and conditional visibility.**
Tabbed layouts, show/hide rules based on field values, and field-level validation — this is exactly what mDFFS was designed for, and it does it well without requiring any code at all.

**8. The target users are SharePoint-native and the form should feel familiar.**
Users who already live in SharePoint lists won't experience friction with an mDFFS-enhanced form. A Power Apps replacement introduces a new UX pattern that some users may resist.

**9. The team or enterprise wants an easier way to manage its custom solutions.**
Maintaining a portfolio of SharePoint custom solutions is easier with mDFFS than with Power Apps. SharePoint sprawl is real! Because mDFFS configurations are all maintained in a hidden configuration list, a PowerShell script can check all your SharePoint sites and return a report showing every list using mDFFS.

---

## Quick Reference Card

| Question | If YES → favors… |
|---|---|
| Does the form need to look like a standalone multi-screen app? | Power Apps |
| Does the form connect to non-SharePoint data sources in real time? | Power Apps |
| Does the form need to run outside SharePoint (Teams tab, portal)? | Power Apps |
| Must non-developers maintain the form logic with no JavaScript support available? | Power Apps |
| Is there no mDFFS footprint and no organizational will to build one? | Power Apps |
| Is all data in a SharePoint list and staying there? | mDFFS |
| Is the primary need tabs + conditional show/hide? | mDFFS |
| Does the team include JavaScript developers? | mDFFS |
| Does the team need repeatable, scriptable, version-controlled deployment? | mDFFS |
| Is minimizing licensing cost and vendor dependency a priority? | mDFFS |
| Does the organization already have an mDFFS or DFFS footprint? | mDFFS |
| Is long-term platform stability a concern? | mDFFS |
| Does the team need visibility across all sites using custom forms? | mDFFS |

---

*This guide is part of the sp-portfolio-kit project. For the full toolkit, visit https://sites.google.com/view/et4sp/home*
