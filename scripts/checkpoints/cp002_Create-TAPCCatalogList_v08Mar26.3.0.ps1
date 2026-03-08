# v08Mar26.3.0
# Create-TAPCCatalogList.ps1
# Creates the TAPC Solution Catalog list on a SharePoint site.
# Requires: PnP PowerShell module, Site Collection Admin access.
# Compatible with: PowerShell 5.1 and PowerShell 7.
# Note: No columns are marked required in the list schema. Required field
# enforcement is handled through mDFFS form configuration, not the list itself.

#region Module Check *#

$psVersion = $PSVersionTable.PSVersion.Major
$pnpModule = Get-Module -Name PnP.PowerShell -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1

if (-not $pnpModule) {
    if ($psVersion -ge 7) {
        Write-Host "Installing PnP.PowerShell (latest)..." -ForegroundColor Cyan
        Install-Module PnP.PowerShell -Scope CurrentUser -Force
    } else {
        Write-Host "Installing PnP.PowerShell 1.12.0 (compatible with PowerShell 5.1)..." -ForegroundColor Cyan
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

$defaultUrl = "https://groovepoint.sharepoint.com/sites/Portfolio/"
$inputUrl = Read-Host "Enter SharePoint site URL [press Enter for default: $defaultUrl]"
$siteUrl = if ($inputUrl.Trim() -eq "") { $defaultUrl } else { $inputUrl.Trim() }

Write-Host "`nConnecting to: $siteUrl" -ForegroundColor Cyan

$env:PNPPOWERSHELL_UPDATECHECK = "Off"
try {
    Connect-PnPOnline -Url $siteUrl -UseWebLogin -WarningAction SilentlyContinue
    Write-Host "Connected successfully.`n" -ForegroundColor Green
} catch {
    Write-Host "Connection failed: $_" -ForegroundColor Red
    exit 1
}

#endregion Connection *#

#region List Creation *#

$listName = "TAPCCatalog"

$existing = Get-PnPList -Identity $listName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "A list named '$listName' already exists on this site. Exiting without changes." -ForegroundColor Yellow
    exit 0
}

Write-Host "Creating list: $listName..." -ForegroundColor Cyan
New-PnPList -Title $listName -Template GenericList -OnQuickLaunch
Write-Host "List created.`n" -ForegroundColor Green

#endregion List Creation *#

#region Helper Functions *#

function Add-ChoiceField {
    param (
        [string]$DisplayName,
        [string]$InternalName,
        [string[]]$Choices
    )
    $choiceXml = "<Field Type='Choice' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' Format='Dropdown'><CHOICES>"
    foreach ($c in $Choices) { $choiceXml += "<CHOICE>$c</CHOICE>" }
    $choiceXml += "</CHOICES></Field>"
    Add-PnPFieldFromXml -List $listName -FieldXml $choiceXml | Out-Null
}

function Add-TextField {
    param (
        [string]$DisplayName,
        [string]$InternalName,
        [bool]$Multiline = $false
    )
    if ($Multiline) {
        $xml = "<Field Type='Note' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' NumLines='6' />"
    } else {
        $xml = "<Field Type='Text' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' />"
    }
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}

function Add-DateField {
    param (
        [string]$DisplayName,
        [string]$InternalName
    )
    $xml = "<Field Type='DateTime' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' Format='DateOnly' />"
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}

function Add-NumberField {
    param (
        [string]$DisplayName,
        [string]$InternalName
    )
    $xml = "<Field Type='Number' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' />"
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}

#endregion Helper Functions *#

#region Section A: Solution Identity *#

Write-Host "Adding Section A: Solution Identity..." -ForegroundColor Cyan
Set-PnPField -List $listName -Identity "Title" -Values @{Title = "SolutionName"} | Out-Null
Add-TextField    -DisplayName "SolutionID"              -InternalName "SolutionID"
Add-TextField    -DisplayName "SolutionURLs"            -InternalName "SolutionURLs"
Add-TextField    -DisplayName "SiteCollection"          -InternalName "SiteCollection"
Add-TextField    -DisplayName "Department"              -InternalName "Department"
Add-TextField    -DisplayName "BusinessOwnerName"       -InternalName "BusinessOwnerName"
Add-TextField    -DisplayName "BusinessOwnerEmail"      -InternalName "BusinessOwnerEmail"
Add-TextField    -DisplayName "ITContact"               -InternalName "ITContact"
Add-DateField    -DisplayName "DateAdded"               -InternalName "DateAdded"
Add-DateField    -DisplayName "LastUpdated"             -InternalName "LastUpdated"

#endregion Section A: Solution Identity *#

#region Section B: Technical Profile *#

Write-Host "Adding Section B: Technical Profile..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "PlatformType"            -InternalName "PlatformType"         -Choices @("Power Apps","Classic DFFS","mDFFS","Native SharePoint","Other")
Add-ChoiceField  -DisplayName "SPVersion"               -InternalName "SPVersion"            -Choices @("SharePoint Online","SharePoint 2019","SharePoint 2016","Other")
Add-TextField    -DisplayName "ThirdPartyComponents"    -InternalName "ThirdPartyComponents" -Multiline $true
Add-TextField    -DisplayName "SPGroups"                -InternalName "SPGroups"             -Multiline $true
Add-TextField    -DisplayName "PermissionStructure"     -InternalName "PermissionStructure"  -Multiline $true
Add-TextField    -DisplayName "Workflows"               -InternalName "Workflows"            -Multiline $true
Add-TextField    -DisplayName "ExternalIntegrations"    -InternalName "ExternalIntegrations" -Multiline $true
Add-ChoiceField  -DisplayName "SensitiveData"           -InternalName "SensitiveData"        -Choices @("Yes","No","Unknown")
Add-TextField    -DisplayName "ComplianceNotes"         -InternalName "ComplianceNotes"      -Multiline $true
Add-ChoiceField  -DisplayName "DeprecatedDeps"          -InternalName "DeprecatedDeps"       -Choices @("Yes","No","Unknown")

#endregion Section B: Technical Profile *#

#region Section C: Business Profile *#

Write-Host "Adding Section C: Business Profile..." -ForegroundColor Cyan
Add-TextField    -DisplayName "BusinessPurpose"         -InternalName "BusinessPurpose"      -Multiline $true
Add-NumberField  -DisplayName "ActiveUsers"             -InternalName "ActiveUsers"
Add-ChoiceField  -DisplayName "UsageFrequency"          -InternalName "UsageFrequency"       -Choices @("Daily","Weekly","Monthly","Rarely","Unknown")
Add-DateField    -DisplayName "LastActiveDate"          -InternalName "LastActiveDate"
Add-ChoiceField  -DisplayName "BusinessNeedStatus"      -InternalName "BusinessNeedStatus"   -Choices @("Active","Unclear","No longer active")
Add-TextField    -DisplayName "BusinessNeedNotes"       -InternalName "BusinessNeedNotes"    -Multiline $true
Add-ChoiceField  -DisplayName "BusinessImpact"          -InternalName "BusinessImpact"       -Choices @("Critical","High","Medium","Low")
Add-ChoiceField  -DisplayName "AlternativeAvailable"    -InternalName "AlternativeAvailable" -Choices @("Yes","No","Partial")

#endregion Section C: Business Profile *#

#region Section D: Cost and Dependency Profile *#

Write-Host "Adding Section D: Cost and Dependency Profile..." -ForegroundColor Cyan
Add-TextField    -DisplayName "LicensingCost"               -InternalName "LicensingCost"
Add-ChoiceField  -DisplayName "LicensingType"               -InternalName "LicensingType"        -Choices @("Power Apps per-user","Power Apps per-app","M365 included","No additional license","Other")
Add-NumberField  -DisplayName "DevHours"                    -InternalName "DevHours"
Add-NumberField  -DisplayName "TicketVolume"                -InternalName "TicketVolume"
Add-ChoiceField  -DisplayName "KnowledgeRisk"               -InternalName "KnowledgeRisk"        -Choices @("High (one person)","Medium (small team)","Low (documented)")
Add-TextField    -DisplayName "KnowledgeHolder"             -InternalName "KnowledgeHolder"
Add-ChoiceField  -DisplayName "HandoffReadiness"            -InternalName "HandoffReadiness"     -Choices @("Ready","Partially ready","Not ready")

#endregion Section D: Cost and Dependency Profile *#

#region Section E: Disposition and Modernization *#

Write-Host "Adding Section E: Disposition and Modernization..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "Disposition"                 -InternalName "Disposition"          -Choices @("Sunset","Migrate","Modernize","Retain and Document")
Add-TextField    -DisplayName "DispositionRationale"        -InternalName "DispositionRationale" -Multiline $true
Add-TextField    -DisplayName "DispositionConfirmedBy"      -InternalName "DispositionConfirmedBy"
Add-DateField    -DisplayName "DispositionDate"             -InternalName "DispositionDate"
Add-ChoiceField  -DisplayName "TargetPlatform"              -InternalName "TargetPlatform"       -Choices @("mDFFS","Native SharePoint","Power Apps","Other enterprise platform")
Add-TextField    -DisplayName "ModernizationEffort"         -InternalName "ModernizationEffort"
Add-ChoiceField  -DisplayName "ModernizationPriority"       -InternalName "ModernizationPriority" -Choices @("High","Medium","Low","Deferred")
Add-ChoiceField  -DisplayName "mDFFSCandidate"              -InternalName "mDFFSCandidate"       -Choices @("Yes","No","Possibly")
Add-DateField    -DisplayName "NextReviewDate"              -InternalName "NextReviewDate"

#endregion Section E: Disposition and Modernization *#

#region Section F: Operational Documentation Status *#

Write-Host "Adding Section F: Operational Documentation Status..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "URLsDocumented"              -InternalName "URLsDocumented"       -Choices @("Complete","Partial","Not started")
Add-ChoiceField  -DisplayName "PermissionsDocumented"       -InternalName "PermissionsDocumented" -Choices @("Complete","Partial","Not started")
Add-ChoiceField  -DisplayName "FormConfigDocumented"        -InternalName "FormConfigDocumented" -Choices @("Complete","Partial","Not started","N/A")
Add-ChoiceField  -DisplayName "WorkflowsDocumented"         -InternalName "WorkflowsDocumented"  -Choices @("Complete","Partial","Not started","N/A")
Add-ChoiceField  -DisplayName "EscalationDefined"           -InternalName "EscalationDefined"    -Choices @("Complete","Not started")
Add-ChoiceField  -DisplayName "FirstLineResolvable"         -InternalName "FirstLineResolvable"  -Choices @("Yes","Partially","No")
Add-TextField    -DisplayName "DocumentationLocation"       -InternalName "DocumentationLocation"

#endregion Section F: Operational Documentation Status *#

#region Complete *#

Write-Host "`nAll fields added successfully." -ForegroundColor Green
Write-Host "List '$listName' is ready at: $siteUrl" -ForegroundColor Green

#endregion Complete *#