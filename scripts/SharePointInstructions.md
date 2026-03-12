# SharePoint Instructions

## Naming Conventions

### Sites, Lists, and Fields (Columns)

- Internal names for sites, lists, and fields must never contain spaces or special characters.
- The underscore character (`_`) is not considered a special character but should be used sparingly.
- Display names may contain spaces or special characters where needed for readability.

**Examples:**

| Internal Name | Display Name |
|---|---|
| `TAPCatalog` | `TAPC Solution Catalog` |
| `SolutionID` | `Solution ID` |
| `BusinessOwnerName` | `Business Owner Name` |
| `LastActiveDate` | `Last Confirmed Active Date` |

### Why This Matters

SharePoint assigns the internal name at creation time and it cannot be changed afterwards. A display name can always be updated. Keeping internal names clean avoids URL encoding issues, scripting errors, and query complexity down the line.