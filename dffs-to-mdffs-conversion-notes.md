---
type: developer-notes
status: preliminary — incomplete; working notes only
origin: Google Drive (migrated 2026-04-18)
related: Book of Knowledge Chapter 6 (Tool 4 — Classic DFFS Converter)
last_updated: 2026-04-18
---

# Convert DFFS to mDFFS — Preliminary Process Notes

*(Incomplete working notes. Not a final procedure.)*

---

## Manual Conversion Steps (Draft)

1. Clone Dev list as Dev2
2. Install DFFS on Dev2
3. Copy Dev configs to Dev2
4. Copy items from Dev or Prd to Dev2 (to have items to look at during conversion)
5. Check: Any vlookups or cascading dropdowns?
   - If **no** → proceed to step 6
   - If **yes** → *(process not yet documented)*
6. Open mDFFS config, choose New form
7. Go to hamburger menu and select Import/Export

---

## Tool to Build

- [ ] Tool to copy DFFS config to mDFFS config list for the same SP form / different SP form

---

## Known Technical Task

- Modify JS to work in modern DFFS

---

## Open Questions

- What is the process when vlookups or cascading dropdowns ARE present? (Step 5 yes-branch is missing)
- What does the Import/Export step produce, and what manual editing is needed after?
- What JS modifications are required, and are they formulaic enough to automate?
