# v11Mar26.1.1
# Generated: 2026-03-10 20:45

#region Script Metadata *#
# Script  : Automate-SiteReview.ps1
# Version : v11Mar26.1.09
# Purpose : Automates the initial DFFS/mDFFS discovery phase of a TAPC portfolio review.
#           Reads a master inventory of SharePoint sites, discovers DFFS-configured lists,
#           captures last-modified dates, creates analysis views, and writes an Excel
#           report back to the TAPC Catalog as a document in TAPAssets.
# Requires: PnP.PowerShell (1.x for PS 5.1) or SharePointPnPPowerShellOnline
#endregion Script Metadata *#

#region Parameters *#
param(
    [string]$MasterInventoryUrl     = "https://groovepoint.sharepoint.com/sites/Portfolio/Lists/MasterSharePointInventory",
    [string]$InventoryUrlField      = "SiteURL",
    [string]$CatalogUrl             = "https://groovepoint.sharepoint.com/sites/Portfolio/Lists/TAPCatalog",
    [string]$ClientId               = "3dac4cee-ad25-4e62-a904-60d2cbc36c9b",
    [string]$LogFileName            = "SiteReview_Log_$(Get-Date -Format 'ddMMMyyyy').txt"
)
#endregion Parameters *#

#region Configuration *#
$CLASSIC_DFFS_LIST_NAME     = "SPJS-DynamicFormsForSharePoint"
$MDFFS_LIST_NAME            = "DFFSConfigurationList"
$PORTFOLIO_VIEW_NAME        = "zPortfolioAnalysis"
$PORTFOLIO_VIEW_FIELDS      = @("Title", "Modified")
$CATALOG_SITE_URL_FIELD     = "SiteCollection"
$CATALOG_LAST_UPDATED_FIELD = "LastUpdated"
$CATALOG_DATE_ADDED_FIELD   = "DateAdded"
$CATALOG_LAST_REPORT_DATE   = "LastReportDate"
$CATALOG_LAST_REPORT_LINK   = "LastReportLink"
$ASSETS_LIBRARY_NAME        = "TAPAssets"
$portfolioSiteUrl           = "https://groovepoint.sharepoint.com/sites/Portfolio"
$psVersionMajor             = $PSVersionTable.PSVersion.Major

# Suppress PnP module update nag
$env:PNPPOWERSHELL_UPDATECHECK = "Off"
#endregion Configuration *#

#region Load Modules *#

# --- PnP module selection ---
# PnP.PowerShell 2.x+ requires PS 7.4+. Version 1.x works on PS 5.1.
# A machine may have both installed; we must import 1.x by explicit path.
$pnpModuleName = $null

if ($psVersionMajor -ge 7) {
    $pnpModuleName = "PnP.PowerShell"
} else {
    $pnpV1 = Get-Module -ListAvailable -Name "PnP.PowerShell" |
              Where-Object { $_.Version.Major -lt 2 } |
              Sort-Object Version -Descending |
              Select-Object -First 1

    if ($null -ne $pnpV1) {
        Write-Host "Using PnP.PowerShell $($pnpV1.Version) (PS 5.1-compatible)"
        try {
            Import-Module $pnpV1.Path -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to import PnP.PowerShell $($pnpV1.Version). $_"
            exit 1
        }
    } elseif (Get-Module -ListAvailable -Name "SharePointPnPPowerShellOnline") {
        $pnpModuleName = "SharePointPnPPowerShellOnline"
    } else {
        Write-Host "No compatible PnP module found. Installing PnP.PowerShell 1.12.0..."
        Write-Host "Press Ctrl+C within 5 seconds to abort, or wait to proceed..."
        Start-Sleep -Seconds 5
        try {
            Install-Module PnP.PowerShell -RequiredVersion 1.12.0 -Force -AllowClobber -Scope CurrentUser
            $pnpV1 = Get-Module -ListAvailable -Name "PnP.PowerShell" |
                      Where-Object { $_.Version.Major -lt 2 } |
                      Sort-Object Version -Descending |
                      Select-Object -First 1
            Import-Module $pnpV1.Path -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to install or import PnP.PowerShell 1.x. $_"
            exit 1
        }
    }
}

# --- Load named modules ---
$modulesToLoad = @()
if ($null -ne $pnpModuleName) { $modulesToLoad = @($pnpModuleName) }

for ($i = 0; $i -lt $modulesToLoad.Count; $i++) {
    $m = $modulesToLoad[$i]
    try {
        Import-Module $m -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to import module '$m'. $_"
        exit 1
    }
}

Write-Host "All required modules loaded."
#endregion Load Modules *#

#region Helper Functions *#

function Write-Log {
    param(
        [string]$message,
        [ValidateSet("INFO","WARN","ERROR")]
        [string]$level = "INFO"
    )
    $ts    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$ts] [$level] $message"
    if ($level -eq "INFO")  { Write-Host $entry }
    if ($level -eq "WARN")  { Write-Warning $message }
    if ($level -eq "ERROR") { Write-Error   $message }
    Add-Content -Path $LogFileName -Value $entry
}

function Get-ListNameFromUrl {
    param([string]$listUrl)
    # Extracts the string segment immediately following '/Lists/' and stops 
    # before any subsequent trailing slash, question mark, or standard view page.
    if ($listUrl -match "/Lists/([^/\?]+)(?:/|$)") {
        $name = $matches[1]
        # Remove common view pages if they inadvertently got greedy matched
        $name = $name -replace "/AllItems\.aspx.*", ""
        return $name
    }
    Write-Log "Could not parse list name from URL: $listUrl" -level "ERROR"
    return $null
}

function Get-SiteNameFromUrl {
    param([string]$siteUrl)
    # Extracts the site name segment immediately following '/sites/' 
    # and stops before the next slash or end of string.
    if ($siteUrl -match "/sites/([^/]+)") {
        return $matches[1]
    }
    # Fallback to sanitizing URL characters if regex misses
    return ($siteUrl -replace 'https?://', '') -replace '[\\/*?"<>|:]', '_'
}

function Connect-ToSite {
    param([string]$siteUrl)
    Write-Log "Connecting to site: $siteUrl"
    $prev = $WarningPreference
    $WarningPreference = "SilentlyContinue"
    Connect-PnPOnline -Url $siteUrl -Interactive -ClientId $ClientId
    $WarningPreference = $prev
}

function Get-DffsTargetLists {
    param(
        [string]$configListName,
        [string]$siteUrl
    )
    $configList = $null
    try {
        $configList = Get-PnPList -Identity $configListName -Includes Hidden
    }
    catch {
        Write-Log "Could not retrieve list '$configListName' on $siteUrl." -level "INFO"
        return $null
    }

    if ($null -eq $configList) {
        Write-Log "List '$configListName' not found on $siteUrl." -level "INFO"
        return $null
    }

    $items = $null
    try {
        $items = Get-PnPListItem -List $configListName -Fields "Title"
    }
    catch {
        Write-Log "Failed to read items from '$configListName' on $siteUrl. $_" -level "ERROR"
        return $null
    }

    $targetNames = $items | ForEach-Object { 
        $rawTitle = $_["Title"]
        # Classic DFFS often stores full form paths like /lists/mylist/dispform.aspx
        # mDFFS usually just stores the list name, but often wrapped in brackets and appended with a content type ID (e.g., [TAPCatalog_100])
        if ($rawTitle -match "/Lists/") {
            $parsed = Get-ListNameFromUrl -listUrl $rawTitle
            if ($null -ne $parsed) { $parsed } else { $rawTitle }
        } else {
            # Strip mDFFS brackets [ ] and trailing content type IDs (e.g., _100)
            $parsed = $rawTitle -replace '^\[|\]$', '' -replace '_\d+$', ''
            $parsed
        }
    } | Sort-Object -Unique
    return $targetNames
}

function Ensure-TAPAssetsLibrary {
    $existingLib = $null
    try {
        $existingLib = Get-PnPList -Identity $ASSETS_LIBRARY_NAME
    } catch {}

    if ($null -eq $existingLib) {
        Write-Log "Library '$ASSETS_LIBRARY_NAME' not found. Creating..." -level "INFO"
        try {
            $existingLib = New-PnPList -Title $ASSETS_LIBRARY_NAME -Template DocumentLibrary
            
            # Create CatalogID column for metadata tagging
            Add-PnPField -List $ASSETS_LIBRARY_NAME -DisplayName "Catalog ID" -InternalName "CatalogID" -Type Number -AddToDefaultView | Out-Null
            Write-Log "Created '$ASSETS_LIBRARY_NAME' library with CatalogID column."
        } catch {
            Write-Log "Failed to create '$ASSETS_LIBRARY_NAME' library. $_" -level "ERROR"
            exit 1
        }
    }
}

function Get-InventoryUrlWithHistory {
    param([string]$DefaultUrl)
    
    Ensure-TAPAssetsLibrary
    
    $historyFileName = "MasterInventory_History.csv"
    $tempPath = Join-Path $env:TEMP $historyFileName
    $historicalUrls = @()
    
    $webUrl = (Get-PnPWeb).ServerRelativeUrl
    if ($webUrl -eq '/') { $webUrl = "" }
    $historyFileServerRelUrl = "$webUrl/$ASSETS_LIBRARY_NAME/$historyFileName"

    # Attempt to download existing history
    try {
        Get-PnPFile -Url $historyFileServerRelUrl -Path $env:TEMP -FileName $historyFileName -AsFile -Force | Out-Null
        $csvData = Import-Csv $tempPath -ErrorAction Stop
        if ($null -ne $csvData) {
            # In case it's a single item, force array cast
            $historicalUrls = @($csvData | Select-Object -ExpandProperty URL | Where-Object { $_ -ne $null -and $_ -ne "" })
        }
    } catch {
        # File likely does not exist yet; that's fine.
    }
    
    $options = @()
    $options += [PSCustomObject]@{ Option = "[Enter New Custom URL]"; URL = "" }
    
    $hasDefaultInHistory = $historicalUrls -contains $DefaultUrl
    if (-not $hasDefaultInHistory -and -not [string]::IsNullOrWhiteSpace($DefaultUrl)) {
        $options += [PSCustomObject]@{ Option = "Default"; URL = $DefaultUrl }
    }
    
    foreach ($hUrl in $historicalUrls) {
        if ($hUrl -eq $DefaultUrl) {
            $options += [PSCustomObject]@{ Option = "Default / History"; URL = $hUrl }
        } else {
            $options += [PSCustomObject]@{ Option = "History"; URL = $hUrl }
        }
    }
    
    $selection = $options | Out-GridView -Title "Select Master Inventory URL ($ScriptVersion)" -OutputMode Single
    
    if (-not $selection) {
        Write-Host "No selection made. Exiting." -ForegroundColor Yellow
        exit 0
    }
    
    $finalUrl = $selection.URL
    if ($selection.Option -eq "[Enter New Custom URL]") {
        $finalUrl = Read-Host "Enter the full URL to the Master SharePoint Inventory list"
        if ([string]::IsNullOrWhiteSpace($finalUrl)) {
            Write-Host "No valid URL entered. Exiting." -ForegroundColor Yellow
            exit 0
        }
    }
    
    # If the URL is brand new, save it back to SharePoint
    if (-not ($historicalUrls -contains $finalUrl) -and ($finalUrl -ne $DefaultUrl -or -not $hasDefaultInHistory)) {
        $newRows = @()
        foreach ($u in $historicalUrls) { $newRows += [PSCustomObject]@{ URL = $u } }
        $newRows += [PSCustomObject]@{ URL = $finalUrl }
        
        $newRows | Export-Csv -Path $tempPath -NoTypeInformation -Encoding UTF8
        try {
            Add-PnPFile -Path $tempPath -Folder $ASSETS_LIBRARY_NAME -Values @{ Title = "Master Inventory URL History" } -ErrorAction Stop | Out-Null
            Write-Log "Appended new URL to history: $ASSETS_LIBRARY_NAME/$historyFileName"
        } catch {
            Write-Log "Failed to upload URL history back to $ASSETS_LIBRARY_NAME. $_" -level "WARN"
        }
    }
    
    return $finalUrl
}

function Ensure-PortfolioView {
    param(
        [string]$listName,
        [string]$siteUrl
    )
    $existingView = $null
    try {
        $existingView = Get-PnPView -List $listName -Identity $PORTFOLIO_VIEW_NAME
    }
    catch {
        # View does not exist — expected on first run
    }

    if ($null -ne $existingView) {
        Write-Log "View '$PORTFOLIO_VIEW_NAME' already exists on '$listName'. Skipping." -level "INFO"
        return
    }

    try {
        Add-PnPView -List $listName `
                    -Title $PORTFOLIO_VIEW_NAME `
                    -Fields $PORTFOLIO_VIEW_FIELDS `
                    -Query "<OrderBy><FieldRef Name='Modified' Ascending='FALSE'/></OrderBy>"
        Write-Log "Created view '$PORTFOLIO_VIEW_NAME' on '$listName' at $siteUrl." -level "INFO"
    }
    catch {
        Write-Log "Failed to create view '$PORTFOLIO_VIEW_NAME' on '$listName'. $_" -level "ERROR"
    }
}

function Get-ListLastModifiedDate {
    param([string]$listName)
    $items = $null
    try {
        $items = Get-PnPListItem -List $listName `
                     -Query "<View><Query><OrderBy><FieldRef Name='Modified' Ascending='FALSE'/></OrderBy></Query><RowLimit>1</RowLimit></View>"
    }
    catch {
        Write-Log "Failed to read items from '$listName' for last modified date. $_" -level "ERROR"
        return $null
    }

    if ($null -ne $items -and $items.Count -gt 0) {
        return $items[0]["Modified"]
    }
    return $null
}

function Get-ListDisplayName {
    param([string]$listName)
    $list = $null
    try {
        $list = Get-PnPList -Identity $listName
    }
    catch {
        Write-Log "Failed to retrieve display name for '$listName'. $_" -level "ERROR"
        return $listName
    }
    return $list.Title
}



function Process-DffsConfigList {
    param(
        [string]$configListName,
        [string]$dffsVersion,
        [string]$siteUrl,
        [System.Collections.Generic.List[PSObject]]$reportRows
    )
    $targetNames = Get-DffsTargetLists -configListName $configListName -siteUrl $siteUrl
    if ($null -eq $targetNames) { return }

    for ($i = 0; $i -lt $targetNames.Count; $i++) {
        $targetName = $targetNames[$i]
        $targetList = $null

        try {
            $targetList = Get-PnPList -Identity $targetName
        }
        catch {
            Write-Log "Target list '$targetName' not found on $siteUrl. Cleaning up." -level "WARN"
        }

        if ($null -eq $targetList) {
            Write-Log "Skipping '$targetName' (List does not exist but records remain in '$configListName')." -level "INFO"
            continue
        }

        Ensure-PortfolioView -listName $targetName -siteUrl $siteUrl

        $lastModified = Get-ListLastModifiedDate -listName $targetName
        $displayName  = Get-ListDisplayName -listName $targetName
        $listUrl      = "$siteUrl/Lists/$targetName"

        $row = [PSCustomObject]@{
            "Site URL"           = $siteUrl
            "List URL"           = $listUrl
            "List Display Name"  = $displayName
            "DFFS Version"       = $dffsVersion
            "Last Modified Date" = if ($null -ne $lastModified) { $lastModified.ToString("yyyy-MM-dd") } else { "No items found" }
        }
        $reportRows.Add($row)
        Write-Log "Recorded list '$displayName' ($dffsVersion) at $siteUrl." -level "INFO"
    }
}

function Export-SiteReportToCSV {
    param(
        [string]$siteName,
        [System.Collections.Generic.List[PSObject]]$reportRows
    )
    $todayStr   = Get-Date -Format "yyyy-MM-dd"
    $fileName   = "Site Report for $siteName - $todayStr.csv"
    $tempPath   = Join-Path $env:TEMP $fileName
    $sortedRows = $reportRows | Sort-Object "DFFS Version", "List Display Name"

    $sortedRows | Export-Csv -Path $tempPath -NoTypeInformation -Encoding UTF8

    Write-Log "CSV report written: $tempPath" -level "INFO"
    return $tempPath
}

function Update-TAPCatalog {
    param(
        [string]$siteUrl,
        [string]$reportFilePath,
        [string]$fileName
    )
    # Re-connect to Portfolio site to restore context after processing a target site.
    Connect-ToSite -siteUrl $portfolioSiteUrl

    $catalogListName = Get-ListNameFromUrl -listUrl $CatalogUrl
    $today           = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $catalogItemId   = $null

    $existingItem = $null
    try {
        $existingItem = Get-PnPListItem -List $catalogListName `
                            -Query "<View><Query><Where><Eq><FieldRef Name='$CATALOG_SITE_URL_FIELD'/><Value Type='Text'>$siteUrl</Value></Eq></Where></Query></View>"
    }
    catch {
        Write-Log "Failed to search TAPC Catalog for '$siteUrl'. $_" -level "ERROR"
        return
    }

    if ($null -ne $existingItem -and $existingItem.Count -gt 0) {
        $catalogItemId = $existingItem[0].Id
        try {
            Set-PnPListItem -List $catalogListName -Identity $catalogItemId -Values @{
                $CATALOG_LAST_UPDATED_FIELD = $today
            }
            Write-Log "Updated catalog entry for $siteUrl (ID $catalogItemId)." -level "INFO"
        }
        catch {
            Write-Log "Failed to update catalog item ID $catalogItemId. $_" -level "ERROR"
        }
    } else {
        try {
            $newItem = Add-PnPListItem -List $catalogListName -Values @{
                $CATALOG_SITE_URL_FIELD     = $siteUrl
                $CATALOG_DATE_ADDED_FIELD   = $today
                $CATALOG_LAST_UPDATED_FIELD = $today
            }
            $catalogItemId = $newItem.Id
            Write-Log "Created new catalog entry for $siteUrl (ID $catalogItemId)." -level "INFO"
        }
        catch {
            Write-Log "Failed to create catalog entry for $siteUrl. $_" -level "ERROR"
            return
        }
    }

    # Upload CSV to TAPAssets and tag with Catalog ID
    if ($null -ne $catalogItemId) {
        try {
            $uploadedFile = Add-PnPFile -Path $reportFilePath -Folder $ASSETS_LIBRARY_NAME -Values @{
                "CatalogID" = $catalogItemId
            }
            Write-Log "Uploaded '$fileName' to $ASSETS_LIBRARY_NAME and tagged with Catalog ID $catalogItemId." -level "INFO"

            # Parse absolute URL from ServerRelativeUrl by stripping the current path
            $portfolioRoot = $portfolioSiteUrl -replace "/sites/Portfolio.*", ""
            $absoluteUrl = $portfolioRoot + $uploadedFile.ServerRelativeUrl
            
            # Form SharePoint Hyperlink field value (URL, Description)
            $linkValue = "$absoluteUrl, View Site Report ($todayStr)"

            Set-PnPListItem -List $catalogListName -Identity $catalogItemId -Values @{
                $CATALOG_LAST_REPORT_DATE = $today
                $CATALOG_LAST_REPORT_LINK = $linkValue
            } -UpdateType SystemUpdate | Out-Null
            
            Write-Log "Updated catalog item ID $catalogItemId with latest report link and date." -level "INFO"
        }
        catch {
            Write-Log "Failed to upload or link report to Item ID $catalogItemId. $_" -level "ERROR"
        }
    }
}

#endregion Helper Functions *#

#region Data Retrieval *#

Write-Log "Script started. Catalog: $CatalogUrl"

Connect-ToSite -siteUrl $portfolioSiteUrl

$ActiveMasterInventoryUrl = Get-InventoryUrlWithHistory -DefaultUrl $MasterInventoryUrl

$inventoryListName = Get-ListNameFromUrl -listUrl $ActiveMasterInventoryUrl
if ($null -eq $inventoryListName) {
    Write-Log "Cannot parse inventory list name from URL: $ActiveMasterInventoryUrl" -level "ERROR"
    exit 1
}

$siteItems = $null
try {
    $siteItems = Get-PnPListItem -List $inventoryListName -Fields "SiteURL"
}
catch {
    Write-Log "Failed to read master inventory list '$inventoryListName'. $_" -level "ERROR"
    exit 1
}

# Force to array — a single-item pipeline result is a plain string in PS 5.1,
# which causes the for loop to iterate character-by-character without this cast.
[array]$siteUrls = $siteItems | ForEach-Object {
    $val = $_[$InventoryUrlField]
    if ($val -is [Microsoft.SharePoint.Client.FieldUrlValue]) {
        $val.Url
    } else {
        [string]$val
    }
} | Where-Object { $_ -ne $null -and $_ -ne "" }

Write-Log "Retrieved $($siteUrls.Count) site(s) from master inventory."

#endregion Data Retrieval *#

#region Processing *#

for ($s = 0; $s -lt $siteUrls.Count; $s++) {
    $siteUrl = $siteUrls[$s]
    Write-Log "--- Processing site $($s + 1) of $($siteUrls.Count): $siteUrl ---"

    try {
        Connect-ToSite -siteUrl $siteUrl

        $reportRows = [System.Collections.Generic.List[PSObject]]::new()

        Process-DffsConfigList -configListName $CLASSIC_DFFS_LIST_NAME `
                                -dffsVersion    "Classic DFFS" `
                                -siteUrl        $siteUrl `
                                -reportRows     $reportRows

        Process-DffsConfigList -configListName $MDFFS_LIST_NAME `
                                -dffsVersion    "mDFFS" `
                                -siteUrl        $siteUrl `
                                -reportRows     $reportRows

        if ($reportRows.Count -eq 0) {
            Write-Log "No DFFS-configured lists found on $siteUrl. Skipping report." -level "INFO"
            continue
        }

        $siteName   = Get-SiteNameFromUrl -siteUrl $siteUrl
        $reportPath = Export-SiteReportToCSV -siteName $siteName -reportRows $reportRows
        $fileName   = Split-Path $reportPath -Leaf

        Update-TAPCatalog -siteUrl $siteUrl -reportFilePath $reportPath -fileName $fileName

        Remove-Item -Path $reportPath -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Log "Unhandled error processing site $siteUrl. Skipping. $_" -level "ERROR"
    }
}

#endregion Processing *#

#region Output *#

Write-Log "Script completed. Log written to: $LogFileName"
Write-Host "Site review complete. See log file: $LogFileName"

#endregion Output *#