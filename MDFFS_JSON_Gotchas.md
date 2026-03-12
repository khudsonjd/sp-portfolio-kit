# mDFFS JSON Form Rendering Gotchas

> **Audience**: Future AI Assistants, Automation Scripts, and SharePoint Administrators configuring Modern DFFS (mDFFS) payloads programmatically.

## The "All Fields On Every Tab" Bug
When generating mDFFS JSON payloads programmatically, you may encounter a silent render failure where the form tabs (PivotItems) appear at the top, but **all fields are dumped into a single, massive column below the tabs, making them visible on every tab simultaneously.**

This occurs because the mDFFS JavaScript rendering engine encounters an unexpected data type while parsing the field properties within the `pivotItem` arrays. Instead of throwing a loud console error, the engine aborts the grouped rendering and dumps all fields to the root canvas.

### The Root Cause: Object vs. String Types
mDFFS relies heavily on empty string representations (`""`) for Multi-Lingual Interface (MUI) properties natively. When an AI or automated script generates a field schema, it often defaults to assigning empty dictionary objects (`{}`) to empty properties. 

**CRITICAL RULE:** mDFFS will completely crash the tabbed layout if the following field properties are instantiated as objects instead of strings or booleans:

❌ **BAD (Causes Tab Crash):**
```json
{
  "useCustomFieldLabelMUI": false,
  "fieldLabelMUI": {},
  "fieldDescriptionMUI": {}
}
```
*(Note: Omitting `useCustomFieldLabelMUI` entirely can also trigger similar parse drops).*

✅ **GOOD (Native mDFFS Standard):**
```json
{
  "useCustomFieldLabelMUI": false,
  "fieldLabelMUI": "",
  "fieldDescriptionMUI": ""
}
```

## The PowerShell Dictionary Corruption Bug
Never use PowerShell's built-in `ConvertTo-Json` to minify or compress an mDFFS JSON text string before uploading it to the `DFFSConfigurationList`. 

In PowerShell 5.1 and 7+, `ConvertFrom-Json` followed by `ConvertTo-Json` has a known behavioral flaw where deeply nested empty JSON arrays `[ ]` are incorrectly serialized back into empty Dictionary/HashTables `@{ }` (or `{}`).

If you take a perfectly valid mDFFS JSON payload and pipe it through `ConvertTo-Json -Depth 10 -Compress`, PowerShell will convert critical empty placeholder arrays into HashTables. When mDFFS reads the configuration, it expects an array and crashes, breaking the form.

**CRITICAL RULE:** To minify mDFFS JSON in PowerShell, always use pure Regex text replacement to strip whitespace from the raw string without parsing it as an object:

❌ **BAD (Corrupts Schema):**
```powershell
$formJson = Get-Content 'form.json' | ConvertFrom-Json | ConvertTo-Json -Compress
```

✅ **GOOD (Safe Minification):**
```powershell
$rawJson = Get-Content 'form.json' -Raw -Encoding UTF8
$formJson = $rawJson -replace '[\r\n\t]+', ''
```

## Summary for AI Assistants
When asked to inject a new field into a `TAPCatalog` mDFFS JSON file:
1. Ensure you place the field strictly inside the `children` array of the target `pivotItem` -> `row` -> `col`.
2. Do not let your JSON generator output `{}` for MUI fields. Hardcode them to `""`.
3. Check that the `childIndex` integers are in perfect sequential monotonic order (0, 1, 2, 3...) within the target `col`. mDFFS will break layout rendering if indices skip numbers.
