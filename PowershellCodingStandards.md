# PowerShell Coding Standards

## 1. General Formatting

-   Use consistent indentation (4 spaces recommended).
-   Use clear, descriptive variable and function names.
-   Keep line length readable (generally under \~120 characters).
-   Separate logical sections of code with blank lines.
-   Use PascalCase for functions and camelCase for variables.

Example:

``` powershell
function Get-UserData {
    param (
        [string]$userId
    )

    # Function logic here
}
```

------------------------------------------------------------------------

## 2. Use Regions to Organize Code

All related blocks of code must be grouped into **regions**.

**Region format:**

``` powershell
#region [purpose of region] *#
...
#endregion [purpose of region] *#
```

Example:

``` powershell
#region Load Required Modules *#

Import-Module PnP.PowerShell
Import-Module Microsoft.Graph

#endregion Load Required Modules *#
```

Guidelines:

-   Regions should represent **clear functional sections**.
-   Avoid extremely large regions.
-   Regions should be named so they collapse cleanly in editors.

Typical region structure:

``` powershell
#region Parameters *#
#endregion Parameters *#

#region Configuration *#
#endregion Configuration *#

#region Helper Functions *#
#endregion Helper Functions *#

#region Data Retrieval *#
#endregion Data Retrieval *#

#region Processing *#
#endregion Processing *#

#region Output *#
#endregion Output *#
```

------------------------------------------------------------------------

## 3. Try/Catch Usage for Retrieval Operations

All **Get operations** must be wrapped in a `try/catch` block.

Example:

``` powershell
#region Retrieve SharePoint List *#

try {
    $list = Get-PnPList -Identity "Projects"
}
catch {
    Write-Error "Failed to retrieve list 'Projects'. $_"
}

#endregion Retrieve SharePoint List *#
```

Rules:

-   Every retrieval operation should be error protected.
-   The catch block should produce **meaningful diagnostic output**.

------------------------------------------------------------------------

## 4. Never Nest Try/Catch Blocks

Nested error handling makes scripts difficult to read and maintain.

**Incorrect:**

``` powershell
try {
    $site = Get-PnPSite

    try {
        $list = Get-PnPList -Identity "Projects"
    }
    catch {
        Write-Error "List retrieval failed"
    }
}
catch {
    Write-Error "Site retrieval failed"
}
```

**Correct:**

``` powershell
try {
    $site = Get-PnPSite
}
catch {
    Write-Error "Site retrieval failed"
}

try {
    $list = Get-PnPList -Identity "Projects"
}
catch {
    Write-Error "List retrieval failed"
}
```

------------------------------------------------------------------------

## 5. Loop Preference

Prefer **For loops** instead of `ForEach` constructs when possible.

Reasons: - Predictable iteration behavior - Easier debugging - Better
performance with indexed collections

Preferred:

``` powershell
for ($i = 0; $i -lt $items.Count; $i++) {
    $item = $items[$i]
}
```

Avoid when possible:

``` powershell
foreach ($item in $items) {
}
```

------------------------------------------------------------------------

## 6. Commenting Standards

Use comments to explain **intent**, not obvious code.

Example:

``` powershell
# Calculate the number of days remaining before expiration
$daysRemaining = ($expirationDate - (Get-Date)).Days
```

Avoid redundant comments:

``` powershell
# Increment i
$i++
```

------------------------------------------------------------------------

## 7. Function Structure

Functions should follow a consistent structure.

Example:

``` powershell
#region Get Project List Items Function *#

function Get-ProjectListItems {

    param(
        [string]$listName
    )

    try {
        $items = Get-PnPListItem -List $listName
    }
    catch {
        Write-Error "Unable to retrieve items from list $listName. $_"
    }

    return $items
}

#endregion Get Project List Items Function *#
```

------------------------------------------------------------------------

## 8. Output Discipline

-   Avoid uncontrolled `Write-Host`.
-   Prefer structured output.
-   Use `Write-Verbose` for optional diagnostic information.

Example:

``` powershell
Write-Verbose "Retrieving project list items"
```

------------------------------------------------------------------------

## 9. Script Layout Template

Recommended starting structure:

``` powershell
#region Script Metadata *#
#endregion Script Metadata *#

#region Parameters *#
#endregion Parameters *#

#region Configuration *#
#endregion Configuration *#

#region Load Modules *#
#endregion Load Modules *#

#region Helper Functions *#
#endregion Helper Functions *#

#region Data Retrieval *#
#endregion Data Retrieval *#

#region Processing *#
#endregion Processing *#

#region Output *#
#endregion Output *#
```

------------------------------------------------------------------------

## 10. SharePoint / PnP Authentication Standard

All scripts connecting to SharePoint Online must use the following:

-   **Module:** `PnP.PowerShell` version `1.12.0`
-   **Shell:** PowerShell 5.1
-   **Connection method:** `-UseWebLogin` (not `-Interactive`, not `-DeviceLogin`)

`-UseWebLogin` opens an embedded browser control within the PowerShell session, which correctly handles modern auth (MFA, SSO) without requiring a separate browser window or device code flow. It only works with PnP.PowerShell 1.x on PowerShell 5.1.

```powershell
Connect-PnPOnline -Url $siteUrl -UseWebLogin -WarningAction SilentlyContinue
```

> Do NOT use `-Interactive` (fails in scripted/Claude Code sessions — browser window does not surface).
> Do NOT use `-DeviceLogin` unless explicitly building a headless/server scenario.

------------------------------------------------------------------------

## 11. ASCII-Only Characters in Script Files

All PowerShell script files must use **ASCII characters only**. Never use Unicode characters, including:

-   Smart/curly quotes (`"` `"` `'` `'`) — use straight quotes (`"` `'`) only
-   Em dash (`—`) or en dash (`–`) — use hyphen (`-`)
-   Any character outside the ASCII range (0–127)

**Why:** PowerShell 5.1 does not treat Unicode quotation marks as string delimiters. A script saved with curly quotes will fail with `ExpressionsMustBeFirstInPipeline` parse errors that are difficult to diagnose. AI tools that write files (e.g. Claude Code Write tool) may silently encode straight quotes as Unicode curly quotes — always verify encoding when a script fails unexpectedly.

**When writing scripts with AI tools:** If a script produces parse errors on string literals, suspect Unicode quote substitution. Fix by rewriting the affected strings in a plain-text editor or by having the AI rewrite using only single-quoted strings and `[char]` codes for special characters.

------------------------------------------------------------------------

## 12. Module Prerequisite Checks

PnP.PowerShell 1.12.0 is pre-installed in this environment. Do not include installation logic in provisioning scripts. The Module Check region must only import the module if it is not already loaded in the current session.

**Correct pattern — import only, with MaximumVersion guard:**

```powershell
if (-not (Get-Module -Name PnP.PowerShell)) {
    Import-Module PnP.PowerShell -MaximumVersion '1.99.99'
}
```

**Why `-MaximumVersion '1.99.99'`:** There is a PnP.PowerShell 3.1.0 installed in the user Documents path that requires PS 7.4.6. Without a version constraint, `Import-Module PnP.PowerShell` on PS 5.1 picks up 3.1.0 and errors. `-MaximumVersion '1.99.99'` ensures the 1.12.0 build is selected.

**Why not `-RequiredVersion 1.12.0`:** Causes `FileNotFoundException` in this environment even when 1.12.0 is installed. Do not use it.

**Wrong — no version guard, may pick up incompatible version:**

```powershell
if (-not (Get-Module -Name PnP.PowerShell)) {
    Import-Module PnP.PowerShell
}
```

This pattern applies to any module where multiple versions are installed across PS 5.1 and PS 7 paths.

------------------------------------------------------------------------

## 13. SharePoint Field Naming Conventions

Never use `Status` as a column internal name. SharePoint generic lists have a built-in hidden field also named `Status` — provisioning a custom field with the same internal name will fail or produce unexpected behavior.

Use a context-specific internal name instead, with the display name set to "Status" via `Set-PnPField`:

| List context | Use this internal name |
|---|---|
| Ticket / request | `RequestStatus` |
| Approval workflow | `ApprovalStatus` |
| Training / certification | `TrainingStatus` |
| Onboarding checklist | `ChecklistStatus` |
| Asset / inventory | `AssetStatus` |
| Task | `TaskStatus` |
| Checkout / loan | `CheckoutStatus` |

The same caution applies to any other name that may conflict with SharePoint built-in fields (e.g. `Author`, `Editor`, `Created`, `Modified`, `ContentType`). Do not use built-in internal names for custom columns.

------------------------------------------------------------------------

## 14. Key Principles

-   Organize scripts so sections collapse cleanly in editors.
-   Maintain consistent region naming.
-   Protect all retrieval operations with error handling.
-   Avoid nested exception logic.
-   Prefer simple, readable iteration patterns.
-   Structure scripts so future maintainers can quickly navigate them.
-   Use ASCII characters only — never Unicode quotes, dashes, or symbols.
-   Check for the specific required module version before installing — never install blindly.
-   Never use SharePoint built-in field names (Status, Author, Editor, Created, Modified) as custom column internal names.
