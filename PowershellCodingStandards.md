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

## 11. Key Principles

-   Organize scripts so sections collapse cleanly in editors.
-   Maintain consistent region naming.
-   Protect all retrieval operations with error handling.
-   Avoid nested exception logic.
-   Prefer simple, readable iteration patterns.
-   Structure scripts so future maintainers can quickly navigate them.
