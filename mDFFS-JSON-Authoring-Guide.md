# mDFFS JSON Authoring Guide
> For use by AI and developers generating Modern DFFS form configurations programmatically.
> Last updated: March 8, 2026

---

## Purpose

This guide documents the exact JSON structure used by Modern DFFS (mDFFS) to configure SharePoint list forms. It is intended to allow AI tools to generate valid form configurations without requiring manual UI interaction.

Configurations are stored in the `DFFSConfigurationList` on each SharePoint site, and can be read and written using `Manage-DFFSConfiguration.ps1`.

---

## DFFSConfigurationList Structure

Each form configuration is a separate list item with these fields:

| Field | Description | Example |
|---|---|---|
| `Title` | Identifies the list using its internal (URL) name | `[TAPCatalog_100]` |
| `Form` | The form type this config applies to | `new` / `edit` / `disp` |
| `FormJSON` | The JSON string defining the form layout | *(see below)* |

> ⚠️ **Important:** Always use the list's **internal name** (URL name), not its display name. These are not always the same. The `_100` suffix is always required for lists (as opposed to libraries).

---

## Top-Level JSON Structure

Every form configuration is a JSON **array** containing one or more layout elements. The outermost element is always a `grid`.

```json
[ { grid } ]
```

---

## Element Types

### grid
The root container. Always the outermost element.

```json
{
  "id": "unique_id",
  "type": "grid",
  "width": "",
  "widthUnit": "px",
  "style": "",
  "children": [ ...rows or pivot... ],
  "childIndex": 0
}
```

---

### row
A horizontal row inside a grid or pivotItem. Contains one or more `col` elements.

```json
{
  "id": "unique_id",
  "type": "row",
  "style": "",
  "children": [ ...cols... ],
  "childIndex": 0
}
```

---

### col
A column inside a row. Contains fields or other elements. Uses a 12-unit grid system.

```json
{
  "id": "unique_id",
  "type": "col",
  "style": "",
  "size": { "sm": 12, "md": 12, "lg": 12, "xl": 12 },
  "children": [ ...fields... ],
  "childIndex": 0
}
```

**Size values:** The 12 units can be split across multiple columns. A single full-width column uses `12` for all breakpoints. Two equal columns would each use `6`.

---

### pivot (Tab Set)
A tab container. Contains two or more `pivotItem` elements (tabs).

```json
{
  "id": "unique_id",
  "type": "pivot",
  "style": "",
  "sticky": false,
  "children": [ ...pivotItems... ],
  "childIndex": 0
}
```

> ⚠️ **Note:** The tab container type is `pivot`, NOT `tabset`. Using `tabset` will cause the form to render blank.

---

### pivotItem (Individual Tab)
A single tab inside a `pivot`. Contains rows and columns.

```json
{
  "id": "unique_id",
  "type": "pivotItem",
  "text": "Tab Label",
  "style": "",
  "children": [ ...rows... ],
  "childIndex": 0
}
```

> ⚠️ **Note:** The tab label property is `text`, NOT `label`. Using `label` will cause tabs to render without names.

---

### field
A SharePoint list field rendered in the form.

```json
{
  "id": "unique_id",
  "type": "field",
  "fin": "InternalFieldName",
  "useCustomFieldLabel": false,
  "useCustomFieldLabelMUI": false,
  "fieldLabel": "Display Label",
  "labelPosition": "left",
  "labelStyle": "",
  "style": "",
  "fieldLabelMUI": {},
  "fieldDescription": "",
  "fieldDescriptionMUI": {},
  "useCustomFieldDescription": false,
  "useCustomDescriptionMUI": false,
  "childIndex": 0
}
```

**Key properties:**
| Property | Description |
|---|---|
| `fin` | The **internal name** of the SharePoint field — always use internal names |
| `fieldLabel` | The label shown to the user in the form |
| `labelPosition` | `left` or `top` |
| `useCustomFieldLabel` | Set to `true` only if overriding the default field label |
| `childIndex` | Zero-based position of this field within its parent `col` |

---

## ID Generation

Every element requires a unique `id`. mDFFS generates these as numeric timestamp strings. When authoring JSON:

- Generate IDs as long numeric strings (15–18 digits)
- Every ID in a single form configuration must be unique
- IDs do not need to match across New / Edit / Display forms — use different IDs for each

**Example pattern:** `"32190856234100001"`, `"32190856234100002"`, etc.

---

## childIndex Rules

`childIndex` is the zero-based position of an element within its parent's `children` array.

- First child: `"childIndex": 0`
- Second child: `"childIndex": 1`
- And so on

This must be accurate or the form may not render correctly.

---

## Common Patterns

### Single Column Form (no tabs)

```
grid
  └── row
        └── col (size 12)
              ├── field
              ├── field
              └── field
```

### Two-Tab Form

```
grid
  └── row
        └── col (size 12)
              └── pivot
                    ├── pivotItem (Tab 1)
                    │     └── row
                    │           └── col (size 12)
                    │                 ├── field
                    │                 └── field
                    └── pivotItem (Tab 2)
                          └── row
                                └── col (size 12)
                                      ├── field
                                      └── field
```

> ⚠️ **Important:** Fields placed **outside** the pivot container will appear above or below all tabs on every tab. Always ensure all fields intended only for a single tab are nested inside a `pivotItem`. This is a valid pattern when you need certain fields to appear on every tab (e.g. a title or identifier field pinned above the tab set).

---

## Deploying a Configuration

1. Generate the FormJSON for each form type (new / edit / disp)
2. Validate each JSON string at https://jsonlint.com before deploying
3. Use `Manage-DFFSConfiguration.ps1` to write each configuration to the `DFFSConfigurationList`
4. **Manually activate mDFFS** for each form type via the DFFS button in the list toolbar → Install DFFS tab → toggle ON → Save

---

## Known Gotchas

| Symptom | Likely Cause |
|---|---|
| Form spins and never loads | FormJSON is malformed / invalid JSON |
| Form loads but is blank | Wrong element type name (e.g. `tabset` instead of `pivot`) |
| Tabs render but have no labels | Used `label` property instead of `text` on `pivotItem` |
| Fields appear below all tabs | Fields placed outside the `pivot` container |
| Config not found by mDFFS | Used display name instead of internal name in Title field |
| Config not found by mDFFS | Missing `_100` suffix in Title field |