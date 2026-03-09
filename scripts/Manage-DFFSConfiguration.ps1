# v08Mar26.2.3
# Manage-DFFSConfiguration.ps1
# Manages form configurations in the DFFSConfigurationList on a SharePoint site.
# Supports copying a configuration from one list to another.
# Requires: PnP PowerShell module, Manage Lists permission on the target site.
# Compatible with: PowerShell 5.1 and PowerShell 7.

#region Script Metadata *#

# DFFSConfigurationList fields used by this script:
#   Title    - Format: [ListInternalName_100]
#   Form     - Values: new | disp | edit
#   FormJSON - The JSON configuration object for the form

# MANUAL STEP REQUIRED — Install DFFS on each form:
# After copying or writing a configuration, DFFS must be manually activated
# for each form (New, Edit, Display) on the target list. There is no known
# programmatic method to do this.
#
# Steps:
#   1. Navigate to the target list in SharePoint.
#   2. Click the DFFS button in the list toolbar.
#   3. Select the form type (New / Edit / Display) from the dropdown.
#   4. Click the "Install DFFS" tab.
#   5. Toggle the button ON for each content type form.
#   6. Click Save.
#   7. Repeat for each form type.

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

#endregion Helper Functions *#

#region Action Selection *#

$actions = @(
    [PSCustomObject]@{ Action = 'A'; Description = 'Copy a configuration from one list to another' }
    [PSCustomObject]@{ Action = 'B'; Description = 'Write a configuration from a JSON file (coming soon)' }
)

$selectedAction = $actions | Out-GridView -Title 'Select an action' -OutputMode Single

if (-not $selectedAction) {
    Write-Host 'No action selected. Exiting.' -ForegroundColor Yellow
    exit 0
}

#endregion Action Selection *#

#region Action B Stub *#

if ($selectedAction.Action -eq 'B') {
    Write-Host 'Write from JSON file - coming soon.' -ForegroundColor Yellow
    exit 0
}

#endregion Action B Stub *#

#region Copy Configuration *#

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

    $sourceJson = $sourceEntry['FormJSON']

    if (-not $sourceJson) {
        Write-Host 'Source configuration exists but has no FormJSON content. Exiting.' -ForegroundColor Yellow
        exit 0
    }

    Write-Host 'Source configuration read successfully.' -ForegroundColor Green

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

    Write-Host 'Checking for existing configuration on target...' -ForegroundColor Cyan

    $existingTarget = Get-DFFSConfigEntry -titleValue $targetTitleValue -formType $selectedTargetForm.FormType

    if ($existingTarget) {
        Write-Host "A configuration already exists for '$targetTitleValue' / '$($selectedTargetForm.FormType)'." -ForegroundColor Yellow
        $confirm = Read-Host 'Overwrite it? (Y / N)'

        if ($confirm.ToUpper() -ne 'Y') {
            Write-Host 'Copy cancelled. No changes made.' -ForegroundColor Yellow
            exit 0
        }

        try {
            Set-PnPListItem -List $listName -Identity $existingTarget.Id -Values @{
                FormJSON = $sourceJson
            } | Out-Null
            Write-Host "Configuration updated on '$($targetList.DisplayName)' / $($selectedTargetForm.Label)." -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to update target configuration. $_"
            exit 1
        }
    }
    else {
        try {
            Add-PnPListItem -List $listName -Values @{
                Title    = $targetTitleValue
                Form     = $selectedTargetForm.FormType
                FormJSON = $sourceJson
            } | Out-Null
            Write-Host "Configuration created on '$($targetList.DisplayName)' / $($selectedTargetForm.Label)." -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to create target configuration. $_"
            exit 1
        }
    }

    #endregion Write Target Configuration *#
}

#endregion Copy Configuration *#

#region Output *#

Write-Host 'Done.' -ForegroundColor Cyan

#endregion Output *#