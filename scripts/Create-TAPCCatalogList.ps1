# v08Mar26.2.1
# Create-TAPCCatalogList.ps1
# Creates the TAPC Solution Catalog list on a SharePoint site.
# Requires: PnP PowerShell module, Site Collection Admin access.
# Compatible with: PowerShell 5.1 and PowerShell 7.
# Note: No columns are marked required in the list schema. Required field
# enforcement is handled through mDFFS form configuration, not the list itself.

#region Module Check *#

$pnpModule = Get-Module -Name PnP.PowerShell -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
$psVersion = $PSVersionTable.PSVersion.Major

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

$listInternalName = "TAPCCatalog"
$listDisplayName  = "TAPC Solution Catalog"

$existing = Get-PnPList -Identity $listInternalName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "A list named '$listInternalName' already exists on this site. Exiting without changes." -ForegroundColor Yellow
    exit 0
}

Write-Host "Creating list: $listInternalName..." -ForegroundColor Cyan
New-PnPList -Title $listInternalName -Template GenericList -OnQuickLaunch
Set-PnPList -Identity $listInternalName -Title $listDisplayName
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
    Add-PnPFieldFromXml -List $listInternalName -FieldXml $choiceXml | Out-Null
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
    Add-PnPFieldFromXml -List $listInternalName -FieldXml $xml | Out-Null
}

function Add-DateField {
    param (
        [string]$DisplayName,
        [string]$InternalName
    )
    $xml = "<Field Type='DateTime' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' Format='DateOnly' />"
    Add-PnPFieldFromXml -List $listInternalName -FieldXml $xml | Out-Null
}

function Add-NumberField {
    param (
        [string]$DisplayName,
        [string]$InternalName
    )
    $xml = "<Field Type='Number' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' />"
    Add-PnPFieldFromXml -List $listInternalName -FieldXml $xml | Out-Null
}

#endregion Helper Functions *#

#region Section A: Solution Identity *#

Write-Host "Adding Section A: Solution Identity..." -ForegroundColor Cyan
Set-PnPField -List $listInternalName -Identity "Title" -Values @{Title = "Solution Name"} | Out-Null
Add-TextField    -DisplayName "Solution ID"                -InternalName "SolutionID"
Add-TextField    -DisplayName "Solution URL(s)"            -InternalName "SolutionURLs"
Add-TextField    -DisplayName "Site Collection"            -InternalName "SiteCollection"
Add-TextField    -DisplayName "Department / Business Unit" -InternalName "Department"
Add-TextField    -DisplayName "Business Owner Name"        -InternalName "BusinessOwnerName"
Add-TextField    -DisplayName "Business Owner Email"       -InternalName "BusinessOwnerEmail"
Add-TextField    -DisplayName "IT Contact / Developer"     -InternalName "ITContact"
Add-DateField    -DisplayName "Date Added to Catalog"      -InternalName "DateAdded"
Add-DateField    -DisplayName "Last Updated"               -InternalName "LastUpdated"

#endregion Section A: Solution Identity *#

#region Section B: Technical Profile *#

Write-Host "Adding Section B: Technical Profile..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "Platform Type"              -InternalName "PlatformType"         -Choices @("Power Apps","Classic DFFS","mDFFS","Native SharePoint","Other")
Add-ChoiceField  -DisplayName "SharePoint Version"         -InternalName "SPVersion"            -Choices @("SharePoint Online","SharePoint 2019","SharePoint 2016","Other")
Add-TextField    -DisplayName "Third-Party Components"     -InternalName "ThirdPartyComponents" -Multiline $true
Add-TextField    -DisplayName "SharePoint Groups"          -InternalName "SPGroups"             -Multiline $true
Add-TextField    -DisplayName "Permission Structure"       -InternalName "PermissionStructure"  -Multiline $true
Add-TextField    -DisplayName "Workflows / Automation"     -InternalName "Workflows"            -Multiline $true
Add-TextField    -DisplayName "External Integrations"      -InternalName "ExternalIntegrations" -Multiline $true
Add-ChoiceField  -DisplayName "Handles Sensitive Data?"    -InternalName "SensitiveData"        -Choices @("Yes","No","Unknown")
Add-TextField    -DisplayName "Compliance Notes"           -InternalName "ComplianceNotes"      -Multiline $true
Add-ChoiceField  -DisplayName "Deprecated Dependencies?"   -InternalName "DeprecatedDeps"       -Choices @("Yes","No","Unknown")

#endregion Section B: Technical Profile *#

#region Section C: Business Profile *#

Write-Host "Adding Section C: Business Profile..." -ForegroundColor Cyan
Add-TextField    -DisplayName "Business Purpose"           -InternalName "BusinessPurpose"      -Multiline $true
Add-NumberField  -DisplayName "Active Users (Approx.)"    -InternalName "ActiveUsers"
Add-ChoiceField  -DisplayName "Usage Frequency"           -InternalName "UsageFrequency"        -Choices @("Daily","Weekly","Monthly","Rarely","Unknown")
Add-DateField    -DisplayName "Last Confirmed Active Date" -InternalName "LastActiveDate"
Add-ChoiceField  -DisplayName "Business Need Status"      -InternalName "BusinessNeedStatus"    -Choices @("Active","Unclear","No longer active")
Add-TextField    -DisplayName "Business Need Notes"       -InternalName "BusinessNeedNotes"     -Multiline $true
Add-ChoiceField  -DisplayName "Business Impact if Failed" -InternalName "BusinessImpact"        -Choices @("Critical","High","Medium","Low")
Add-ChoiceField  -DisplayName "Alternative Available?"    -InternalName "AlternativeAvailable"  -Choices @("Yes","No","Partial")

#endregion Section C: Business Profile *#

#region Section D: Cost & Dependency Profile *#

Write-Host "Adding Section D: Cost and Dependency Profile..." -ForegroundColor Cyan
Add-TextField    -DisplayName "Licensing Cost (Annual)"        -InternalName "LicensingCost"
Add-ChoiceField  -DisplayName "Licensing Type"                 -InternalName "LicensingType"        -Choices @("Power Apps per-user","Power Apps per-app","M365 included","No additional license","Other")
Add-NumberField  -DisplayName "Developer Hours (Annual Est.)"  -InternalName "DevHours"
Add-NumberField  -DisplayName "Support Ticket Volume (Annual Est.)" -InternalName "TicketVolume"
Add-ChoiceField  -DisplayName "Institutional Knowledge Risk"   -InternalName "KnowledgeRisk"        -Choices @("High (one person)","Medium (small team)","Low (documented)")
Add-TextField    -DisplayName "Key Knowledge Holder"           -InternalName "KnowledgeHolder"
Add-ChoiceField  -DisplayName "Hand-off Readiness"             -InternalName "HandoffReadiness"     -Choices @("Ready","Partially ready","Not ready")

#endregion Section D: Cost & Dependency Profile *#

#region Section E: Disposition & Modernization *#

Write-Host "Adding Section E: Disposition and Modernization..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "Recommended Disposition"        -InternalName "Disposition"          -Choices @("Sunset","Migrate","Modernize","Retain and Document")
Add-TextField    -DisplayName "Disposition Rationale"          -InternalName "DispositionRationale" -Multiline $true
Add-TextField    -DisplayName "Disposition Confirmed By"       -InternalName "DispositionConfirmedBy"
Add-DateField    -DisplayName "Disposition Date"               -InternalName "DispositionDate"
Add-ChoiceField  -DisplayName "Target Platform"                -InternalName "TargetPlatform"       -Choices @("mDFFS","Native SharePoint","Power Apps","Other enterprise platform")
Add-TextField    -DisplayName "Estimated Modernization Effort" -InternalName "ModernizationEffort"
Add-ChoiceField  -DisplayName "Modernization Priority"         -InternalName "ModernizationPriority" -Choices @("High","Medium","Low","Deferred")
Add-ChoiceField  -DisplayName "mDFFS Pattern Candidate?"       -InternalName "mDFFSCandidate"       -Choices @("Yes","No","Possibly")
Add-DateField    -DisplayName "Next Review Date"               -InternalName "NextReviewDate"

#endregion Section E: Disposition & Modernization *#

#region Section F: Operational Documentation Status *#

Write-Host "Adding Section F: Operational Documentation Status..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "URL(s) Documented"                  -InternalName "URLsDocumented"       -Choices @("Complete","Partial","Not started")
Add-ChoiceField  -DisplayName "Permission Structure Documented"    -InternalName "PermissionsDocumented" -Choices @("Complete","Partial","Not started")
Add-ChoiceField  -DisplayName "Form Configuration Documented"      -InternalName "FormConfigDocumented" -Choices @("Complete","Partial","Not started","N/A")
Add-ChoiceField  -DisplayName "Workflows Documented"               -InternalName "WorkflowsDocumented"  -Choices @("Complete","Partial","Not started","N/A")
Add-ChoiceField  -DisplayName "Escalation Path Defined"            -InternalName "EscalationDefined"    -Choices @("Complete","Not started")
Add-ChoiceField  -DisplayName "First-Line Resolvable?"             -InternalName "FirstLineResolvable"  -Choices @("Yes","Partially","No")
Add-TextField    -DisplayName "Documentation Location"             -InternalName "DocumentationLocation"

#endregion Section F: Operational Documentation Status *#

#region Complete *#

Write-Host "`nAll fields added successfully." -ForegroundColor Green
Write-Host "List '$listDisplayName' is ready at: $siteUrl" -ForegroundColor Green

#endregion Complete *#