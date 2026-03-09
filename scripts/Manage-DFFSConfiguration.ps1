# v08Mar26.3.0
# Manage-DFFSConfiguration.ps1
# Manages form configurations in the DFFSConfigurationList on a SharePoint site.
# Supports copying a configuration from one list to another,
# and writing a configuration from a local JSON file.
# Requires: PnP PowerShell module, Manage Lists permission on the target site.
# Compatible with: PowerShell 5.1 and PowerShell 7.

#region Script Metadata *#

# DFFSConfigurationList fields used by this script:
#   Title    - Format: [ListInternalName_100]
#   Form     - Values: new | disp | edit
#   FormJSON - The JSON configuration object for the form

#endregion Script Metadata *#

#region Configuration *#

$listName       = 'DFFSConfigurationList'
$defaultSiteUrl = 'https://groovepoint.sharepoint.com/sites/Portfolio/'

#endregion Configuration *#

#region Module Check *#

$psVersion = $PSVersionTable.PSVersion.Major
$pnpModule = Get-Module -Name PnP.PowerShell -ListAvailable |
             Sort-Object Version -Descending |
             Select-Object -First 1

if (-not $pnpModule) {
    if ($psVersion -ge 7) {
        Write-Host 'Installing PnP.PowerShell (latest)...' -ForegroundColor Cyan
        Install-Module PnP.PowerShell -Scope CurrentUser -Force
    } else {
        Write-Host 'Installing PnP.PowerShell 1.12.0 (compatible with PowerShell 5.1)...' -ForegroundColor Cyan
        Install-Module PnP.PowerShell -RequiredVersion 1.12.0 -Scope CurrentUser -Force
    }
}

if (-not (Get-Module -Name PnP.PowerShell)) {
    if ($psVersion -ge 7) {
        Import-Module PnP.PowerShell
    } else {
        Import-Module PnP.PowerShell -RequiredVersion 1.12.0
    }
}

#endregion Module Check *#

#region Connection *#

$inputUrl = Read-Host 'Enter SharePoint site URL [press Enter for default]'
$siteUrl  = if ($inputUrl.Trim() -eq '') { $defaultSiteUrl } else { $inputUrl.Trim() }

Write-Host "Connecting to: $siteUrl" -ForegroundColor Cyan

$env:PNPPOWERSHELL_UPDATECHECK = 'Off'

try {
    Connect-PnPOnline -Url $siteUrl -UseWebLogin -WarningAction SilentlyContinue
    Write-Host 'Connected successfully.' -ForegroundColor Green
}
catch {
    Write-Host "Connection failed: $_" -ForegroundColor Red
    exit 1
}

#endregion Connection *#

#region Helper Functions *#

function Get-NonHiddenLists {
    try {
        $lists = Get-PnPList -Includes RootFolder |
                 Where-Object { -not $_.Hidden } |
                 Select-Object @{N='DisplayName'; E={$_.Title}},
                               @{N='InternalName'; E={$_.RootFolder.Name}}
        return $lists
    }
    catch {
        Write-Error "Failed to retrieve site lists. $_"
        return $null
    }
}

function Get-DFFSConfigEntry {
    param (
        [string]$titleValue,
        [string]$formType
    )
    try {
        $items = Get-PnPListItem -List $listName -Fields 'Title','Form','FormJSON' |
                 Where-Object { $_['Title'] -eq $titleValue -and $_['Form'] -eq $formType }
        return $items
    }
    catch {
        Write-Error "Failed to query '$listName'. $_"
        return $null
    }
}

function Write-DFFSConfigEntry {
    param (
        [string]$titleValue,
        [string]$formType,
        [string]$formJson
    )

    $existing = Get-DFFSConfigEntry -titleValue $titleValue -formType $formType

    if ($existing) {
        Write-Host "  Existing entry found — updating..." -ForegroundColor Cyan
        Set-PnPListItem -List $listName -Identity $existing.Id -Values @{
            Title    = $titleValue
            Form     = $formType
            FormJSON = $formJson
        } | Out-Null
        Write-Host "  Updated: $titleValue / $formType" -ForegroundColor Green
    }
    else {
        Write-Host "  No existing entry — creating..." -ForegroundColor Cyan
        Add-PnPListItem -List $listName -Values @{
            Title    = $titleValue
            Form     = $formType
            FormJSON = $formJson
        } | Out-Null
        Write-Host "  Created: $titleValue / $formType" -ForegroundColor Green
    }
}

#endregion Helper Functions *#

#region Action Selection *#

$actions = @(
    [PSCustomObject]@{ Action = 'A'; Description = 'Copy a configuration from one list to another' }
    [PSCustomObject]@{ Action = 'B'; Description = 'Write TAPCCatalog form configurations from JSON files' }
)

$selectedAction = $actions | Out-GridView -Title 'Select an action' -OutputMode Single

if (-not $selectedAction) {
    Write-Host 'No action selected. Exiting.' -ForegroundColor Yellow
    exit 0
}

#endregion Action Selection *#

#region Action B — Write from JSON Files *#

if ($selectedAction.Action -eq 'B') {

    # Locate the /forms folder relative to this script
    $formsFolder = Join-Path $PSScriptRoot '..\forms'
    $formsFolder = (Resolve-Path $formsFolder).Path

    $formFiles = @(
        @{ File = 'TAPCCatalog_new.json';  FormType = 'new'  }
        @{ File = 'TAPCCatalog_edit.json'; FormType = 'edit' }
        @{ File = 'TAPCCatalog_disp.json'; FormType = 'disp' }
    )

    $titleValue = '[TAPCCatalog_100]'

    Write-Host "`nWriting TAPCCatalog form configurations to '$listName'..." -ForegroundColor Cyan

    foreach ($entry in $formFiles) {
        $filePath = Join-Path $formsFolder $entry.File

        if (-not (Test-Path $filePath)) {
            Write-Host "  File not found: $filePath — skipping." -ForegroundColor Yellow
            continue
        }

        Write-Host "`nProcessing: $($entry.File)" -ForegroundColor Cyan

        try {
            $formJson = Get-Content -Path $filePath -Raw -Encoding UTF8

            # Validate it parses as JSON before writing
            $null = $formJson | ConvertFrom-Json

            Write-DFFSConfigEntry -titleValue $titleValue -formType $entry.FormType -formJson $formJson
        }
        catch {
            Write-Host "  Failed to process $($entry.File): $_" -ForegroundColor Red
        }
    }

    Write-Host "`nDone. All form configurations processed." -ForegroundColor Green
    Write-Host "IMPORTANT: You must manually activate mDFFS for each form type in SharePoint." -ForegroundColor Yellow
    Write-Host "  1. Go to the TAPCCatalog list" -ForegroundColor Yellow
    Write-Host "  2. Click the DFFS button in the toolbar" -ForegroundColor Yellow
    Write-Host "  3. For each form type (New / Edit / Display): Install DFFS tab > toggle ON > Save" -ForegroundColor Yellow

    exit 0
}

#endregion Action B — Write from JSON Files *#

#region Action A — Copy Configuration *#

if ($selectedAction.Action -eq 'A') {

    Write-Host 'Retrieving site lists...' -ForegroundColor Cyan

    $siteLists = Get-NonHiddenLists

    if (-not $siteLists -or $siteLists.Count -eq 0) {
        Write-Host 'No lists found on this site. Exiting.' -ForegroundColor Yellow
        exit 0
    }

    #region Select Source List *#

    $sourceList = $siteLists | Out-GridView -Title 'Select the SOURCE list' -OutputMode Single

    if (-not $sourceList) {
        Write-Host 'No source list selected. Exiting.' -ForegroundColor Yellow
        exit 0
    }

    $sourceTitleValue = '[' + $sourceList.InternalName + '_100]'
    Write-Host "Source list: $($sourceList.DisplayName) (internal: $($sourceList.InternalName))" -ForegroundColor Cyan

    #endregion Select Source List *#

    #region Select Source Form Type *#

    $formTypes = @(
        [PSCustomObject]@{ FormType = 'new';  Label = 'New Form' }
        [PSCustomObject]@{ FormType = 'disp'; Label = 'Display Form' }
        [PSCustomObject]@{ FormType = 'edit'; Label = 'Edit Form' }
    )

    $selectedSourceForm = $formTypes | Out-GridView -Title 'Select the SOURCE form type' -OutputMode Single

    if (-not $selectedSourceForm) {
        Write-Host 'No source form type selected. Exiting.' -ForegroundColor Yellow
        exit 0
    }

    Write-Host "Source form type: $($selectedSourceForm.Label)" -ForegroundColor Cyan

    #endregion Select Source Form Type *#

    #region Read Source Configuration *#

    Write-Host 'Reading source configuration...' -ForegroundColor Cyan

    $sourceEntry = Get-DFFSConfigEntry -titleValue $sourceTitleValue -formType $selectedSourceForm.FormType

    if (-not $sourceEntry) {
        Write-Host "No configuration found for '$sourceTitleValue' / '$($selectedSourceForm.FormType)'. Exiting." -ForegroundColor Yellow
        exit 0
    }

    $sourceJson = $sourceEntry[0]['FormJSON']
    Write-Host "Source configuration retrieved ($($sourceJson.Length) characters)." -ForegroundColor Green

    #endregion Read Source Configuration *#

    #region Select Target List *#

    $targetList = $siteLists | Out-GridView -Title 'Select the TARGET list' -OutputMode Single

    if (-not $targetList) {
        Write-Host 'No target list selected. Exiting.' -ForegroundColor Yellow
        exit 0
    }

    $targetTitleValue = '[' + $targetList.InternalName + '_100]'
    Write-Host "Target list: $($targetList.DisplayName) (internal: $($targetList.InternalName))" -ForegroundColor Cyan

    #endregion Select Target List *#

    #region Select Target Form Type *#

    $selectedTargetForm = $formTypes | Out-GridView -Title 'Select the TARGET form type' -OutputMode Single

    if (-not $selectedTargetForm) {
        Write-Host 'No target form type selected. Exiting.' -ForegroundColor Yellow
        exit 0
    }

    Write-Host "Target form type: $($selectedTargetForm.Label)" -ForegroundColor Cyan

    #endregion Select Target Form Type *#

    #region Write Target Configuration *#

    Write-Host "`nWriting configuration to target..." -ForegroundColor Cyan
    Write-DFFSConfigEntry -titleValue $targetTitleValue -formType $selectedTargetForm.FormType -formJson $sourceJson

    Write-Host "`nDone." -ForegroundColor Green
    Write-Host "IMPORTANT: You must manually activate mDFFS on the target list form in SharePoint." -ForegroundColor Yellow

    #endregion Write Target Configuration *#
}

#endregion Action A — Copy Configuration *#