# v11Mar26.1.1
# Create-TAPCatalogList.ps1
# Creates the TAPCatalog list on a SharePoint site, then updates all field
# display names to human-readable values.
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
$clientId = "3dac4cee-ad25-4e62-a904-60d2cbc36c9b"

try {
    Connect-PnPOnline -Url $siteUrl -Interactive -ClientId $clientId -WarningAction SilentlyContinue
    Write-Host "Connected successfully.`n" -ForegroundColor Green
} catch {
    Write-Host "Connection failed: $_" -ForegroundColor Red
    exit 1
}

#endregion Connection *#

#region List Creation *#

$listName = "TAPCatalog"

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

#region Function: Add-ChoiceField *#
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
#endregion Function: Add-ChoiceField *#

#region Function: Add-TextField *#
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
#endregion Function: Add-TextField *#

#region Function: Add-DateField *#
function Add-DateField {
    param (
        [string]$DisplayName,
        [string]$InternalName
    )
    $xml = "<Field Type='DateTime' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' Format='DateOnly' />"
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}
#endregion Function: Add-DateField *#

#region Function: Add-UrlField *#
function Add-UrlField {
    param (
        [string]$DisplayName,
        [string]$InternalName
    )
    $xml = "<Field Type='URL' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' Format='Hyperlink' />"
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}
#endregion Function: Add-UrlField *#

#region Function: Add-NumberField *#
function Add-NumberField {
    param (
        [string]$DisplayName,
        [string]$InternalName
    )
    $xml = "<Field Type='Number' DisplayName='$DisplayName' Name='$InternalName' Required='FALSE' />"
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}
#endregion Function: Add-NumberField *#

#endregion Helper Functions *#

#region Section A: Solution Identity *#

Write-Host "Adding Section A: Solution Identity..." -ForegroundColor Cyan
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
Add-TextField    -DisplayName "LicensingCost"           -InternalName "LicensingCost"
Add-ChoiceField  -DisplayName "LicensingType"           -InternalName "LicensingType"        -Choices @("Power Apps per-user","Power Apps per-app","M365 included","No additional license","Other")
Add-NumberField  -DisplayName "DevHours"                -InternalName "DevHours"
Add-NumberField  -DisplayName "TicketVolume"            -InternalName "TicketVolume"
Add-ChoiceField  -DisplayName "KnowledgeRisk"           -InternalName "KnowledgeRisk"        -Choices @("High (one person)","Medium (small team)","Low (documented)")
Add-TextField    -DisplayName "KnowledgeHolder"         -InternalName "KnowledgeHolder"
Add-ChoiceField  -DisplayName "HandoffReadiness"        -InternalName "HandoffReadiness"     -Choices @("Ready","Partially ready","Not ready")

#endregion Section D: Cost and Dependency Profile *#

#region Section E: Disposition and Modernization *#

Write-Host "Adding Section E: Disposition and Modernization..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "Disposition"             -InternalName "Disposition"           -Choices @("Sunset","Migrate","Modernize","Retain and Document")
Add-TextField    -DisplayName "DispositionRationale"    -InternalName "DispositionRationale"  -Multiline $true
Add-TextField    -DisplayName "DispositionConfirmedBy"  -InternalName "DispositionConfirmedBy"
Add-DateField    -DisplayName "DispositionDate"         -InternalName "DispositionDate"
Add-ChoiceField  -DisplayName "TargetPlatform"          -InternalName "TargetPlatform"        -Choices @("mDFFS","Native SharePoint","Power Apps","Other enterprise platform")
Add-TextField    -DisplayName "ModernizationEffort"     -InternalName "ModernizationEffort"
Add-ChoiceField  -DisplayName "ModernizationPriority"   -InternalName "ModernizationPriority" -Choices @("High","Medium","Low","Deferred")
Add-ChoiceField  -DisplayName "mDFFSCandidate"          -InternalName "mDFFSCandidate"        -Choices @("Yes","No","Possibly")
Add-DateField    -DisplayName "NextReviewDate"          -InternalName "NextReviewDate"

#endregion Section E: Disposition and Modernization *#

#region Section F: Operational Documentation Status *#

Write-Host "Adding Section F: Operational Documentation Status..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "URLsDocumented"          -InternalName "URLsDocumented"        -Choices @("Complete","Partial","Not started")
Add-ChoiceField  -DisplayName "PermissionsDocumented"   -InternalName "PermissionsDocumented" -Choices @("Complete","Partial","Not started")
Add-ChoiceField  -DisplayName "FormConfigDocumented"    -InternalName "FormConfigDocumented"  -Choices @("Complete","Partial","Not started","N/A")
Add-ChoiceField  -DisplayName "WorkflowsDocumented"     -InternalName "WorkflowsDocumented"   -Choices @("Complete","Partial","Not started","N/A")
Add-ChoiceField  -DisplayName "EscalationDefined"       -InternalName "EscalationDefined"     -Choices @("Complete","Not started")
Add-ChoiceField  -DisplayName "FirstLineResolvable"     -InternalName "FirstLineResolvable"   -Choices @("Yes","Partially","No")
Add-TextField    -DisplayName "DocumentationLocation"   -InternalName "DocumentationLocation"
Add-DateField    -DisplayName "LastReportDate"          -InternalName "LastReportDate"
Add-UrlField     -DisplayName "LastReportLink"          -InternalName "LastReportLink"

#endregion Section F: Operational Documentation Status *#

#region Display Name Updates *#

Write-Host "`nUpdating display names..." -ForegroundColor Cyan

# Section A
Set-PnPField -List $listName -Identity "Title"                  -Values @{Title = "Solution Name"} | Out-Null
Set-PnPField -List $listName -Identity "SolutionID"             -Values @{Title = "Solution ID"} | Out-Null
Set-PnPField -List $listName -Identity "SolutionURLs"           -Values @{Title = "Solution URL(s)"} | Out-Null
Set-PnPField -List $listName -Identity "SiteCollection"         -Values @{Title = "Site Collection"} | Out-Null
Set-PnPField -List $listName -Identity "Department"             -Values @{Title = "Department / Business Unit"} | Out-Null
Set-PnPField -List $listName -Identity "BusinessOwnerName"      -Values @{Title = "Business Owner Name"} | Out-Null
Set-PnPField -List $listName -Identity "BusinessOwnerEmail"     -Values @{Title = "Business Owner Email"} | Out-Null
Set-PnPField -List $listName -Identity "ITContact"              -Values @{Title = "IT Contact / Developer"} | Out-Null
Set-PnPField -List $listName -Identity "DateAdded"              -Values @{Title = "Date Added to Catalog"} | Out-Null
Set-PnPField -List $listName -Identity "LastUpdated"            -Values @{Title = "Last Updated"} | Out-Null

# Section B
Set-PnPField -List $listName -Identity "PlatformType"           -Values @{Title = "Platform Type"} | Out-Null
Set-PnPField -List $listName -Identity "SPVersion"              -Values @{Title = "SharePoint Version"} | Out-Null
Set-PnPField -List $listName -Identity "ThirdPartyComponents"   -Values @{Title = "Third-Party Components"} | Out-Null
Set-PnPField -List $listName -Identity "SPGroups"               -Values @{Title = "SharePoint Groups"} | Out-Null
Set-PnPField -List $listName -Identity "PermissionStructure"    -Values @{Title = "Permission Structure"} | Out-Null
Set-PnPField -List $listName -Identity "Workflows"              -Values @{Title = "Workflows / Automation"} | Out-Null
Set-PnPField -List $listName -Identity "ExternalIntegrations"   -Values @{Title = "External Integrations"} | Out-Null
Set-PnPField -List $listName -Identity "SensitiveData"          -Values @{Title = "Handles Sensitive Data?"} | Out-Null
Set-PnPField -List $listName -Identity "ComplianceNotes"        -Values @{Title = "Compliance Notes"} | Out-Null
Set-PnPField -List $listName -Identity "DeprecatedDeps"         -Values @{Title = "Deprecated Dependencies?"} | Out-Null

# Section C
Set-PnPField -List $listName -Identity "BusinessPurpose"        -Values @{Title = "Business Purpose"} | Out-Null
Set-PnPField -List $listName -Identity "ActiveUsers"            -Values @{Title = "Active Users (Approx.)"} | Out-Null
Set-PnPField -List $listName -Identity "UsageFrequency"         -Values @{Title = "Usage Frequency"} | Out-Null
Set-PnPField -List $listName -Identity "LastActiveDate"         -Values @{Title = "Last Confirmed Active Date"} | Out-Null
Set-PnPField -List $listName -Identity "BusinessNeedStatus"     -Values @{Title = "Business Need Status"} | Out-Null
Set-PnPField -List $listName -Identity "BusinessNeedNotes"      -Values @{Title = "Business Need Notes"} | Out-Null
Set-PnPField -List $listName -Identity "BusinessImpact"         -Values @{Title = "Business Impact if Failed"} | Out-Null
Set-PnPField -List $listName -Identity "AlternativeAvailable"   -Values @{Title = "Alternative Available?"} | Out-Null

# Section D
Set-PnPField -List $listName -Identity "LicensingCost"          -Values @{Title = "Licensing Cost (Annual)"} | Out-Null
Set-PnPField -List $listName -Identity "LicensingType"          -Values @{Title = "Licensing Type"} | Out-Null
Set-PnPField -List $listName -Identity "DevHours"               -Values @{Title = "Developer Hours (Annual Est.)"} | Out-Null
Set-PnPField -List $listName -Identity "TicketVolume"           -Values @{Title = "Support Ticket Volume (Annual Est.)"} | Out-Null
Set-PnPField -List $listName -Identity "KnowledgeRisk"          -Values @{Title = "Institutional Knowledge Risk"} | Out-Null
Set-PnPField -List $listName -Identity "KnowledgeHolder"        -Values @{Title = "Key Knowledge Holder"} | Out-Null
Set-PnPField -List $listName -Identity "HandoffReadiness"       -Values @{Title = "Hand-off Readiness"} | Out-Null

# Section E
Set-PnPField -List $listName -Identity "Disposition"            -Values @{Title = "Recommended Disposition"} | Out-Null
Set-PnPField -List $listName -Identity "DispositionRationale"   -Values @{Title = "Disposition Rationale"} | Out-Null
Set-PnPField -List $listName -Identity "DispositionConfirmedBy" -Values @{Title = "Disposition Confirmed By"} | Out-Null
Set-PnPField -List $listName -Identity "DispositionDate"        -Values @{Title = "Disposition Date"} | Out-Null
Set-PnPField -List $listName -Identity "TargetPlatform"         -Values @{Title = "Target Platform"} | Out-Null
Set-PnPField -List $listName -Identity "ModernizationEffort"    -Values @{Title = "Estimated Modernization Effort"} | Out-Null
Set-PnPField -List $listName -Identity "ModernizationPriority"  -Values @{Title = "Modernization Priority"} | Out-Null
Set-PnPField -List $listName -Identity "mDFFSCandidate"         -Values @{Title = "mDFFS Pattern Candidate?"} | Out-Null
Set-PnPField -List $listName -Identity "NextReviewDate"         -Values @{Title = "Next Review Date"} | Out-Null

# Section F
Set-PnPField -List $listName -Identity "URLsDocumented"         -Values @{Title = "URL(s) Documented"} | Out-Null
Set-PnPField -List $listName -Identity "PermissionsDocumented"  -Values @{Title = "Permission Structure Documented"} | Out-Null
Set-PnPField -List $listName -Identity "FormConfigDocumented"   -Values @{Title = "Form Configuration Documented"} | Out-Null
Set-PnPField -List $listName -Identity "WorkflowsDocumented"    -Values @{Title = "Workflows Documented"} | Out-Null
Set-PnPField -List $listName -Identity "EscalationDefined"      -Values @{Title = "Escalation Path Defined"} | Out-Null
Set-PnPField -List $listName -Identity "FirstLineResolvable"    -Values @{Title = "First-Line Resolvable?"} | Out-Null
Set-PnPField -List $listName -Identity "DocumentationLocation"  -Values @{Title = "Documentation Location"} | Out-Null
Set-PnPField -List $listName -Identity "LastReportDate"         -Values @{Title = "Automated Review Date"} | Out-Null
Set-PnPField -List $listName -Identity "LastReportLink"         -Values @{Title = "Automated Review Link"} | Out-Null

#endregion Display Name Updates *#

#region Complete *#

Write-Host "`nAll fields added and display names updated successfully." -ForegroundColor Green
Write-Host "List '$listName' is ready at: $siteUrl" -ForegroundColor Green

#endregion Complete *#