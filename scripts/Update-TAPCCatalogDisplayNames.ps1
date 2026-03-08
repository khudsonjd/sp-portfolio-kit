# v08Mar26.1.0
# Update-TAPCCatalogDisplayNames.ps1
# Updates the display names of all fields in the TAPCCatalog list.
# Requires: PnP PowerShell module, Site Collection Admin access.
# Compatible with: PowerShell 5.1 and PowerShell 7.

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

#region Display Name Updates *#

$listName = "TAPCCatalog"

Write-Host "Updating display names on list: $listName..." -ForegroundColor Cyan

# Helper function
function Set-DisplayName {
    param (
        [string]$InternalName,
        [string]$DisplayName
    )
    try {
        Set-PnPField -List $listName -Identity $InternalName -Values @{Title = $DisplayName} | Out-Null
        Write-Host "  $InternalName -> $DisplayName" -ForegroundColor Gray
    } catch {
        Write-Host "  FAILED: $InternalName - $_" -ForegroundColor Red
    }
}

# Section A: Solution Identity
Write-Host "`nSection A: Solution Identity..." -ForegroundColor Cyan
Set-DisplayName -InternalName "Title"                -DisplayName "Solution Name"
Set-DisplayName -InternalName "SolutionID"           -DisplayName "Solution ID"
Set-DisplayName -InternalName "SolutionURLs"         -DisplayName "Solution URL(s)"
Set-DisplayName -InternalName "SiteCollection"       -DisplayName "Site Collection"
Set-DisplayName -InternalName "Department"           -DisplayName "Department / Business Unit"
Set-DisplayName -InternalName "BusinessOwnerName"    -DisplayName "Business Owner Name"
Set-DisplayName -InternalName "BusinessOwnerEmail"   -DisplayName "Business Owner Email"
Set-DisplayName -InternalName "ITContact"            -DisplayName "IT Contact / Developer"
Set-DisplayName -InternalName "DateAdded"            -DisplayName "Date Added to Catalog"
Set-DisplayName -InternalName "LastUpdated"          -DisplayName "Last Updated"

# Section B: Technical Profile
Write-Host "`nSection B: Technical Profile..." -ForegroundColor Cyan
Set-DisplayName -InternalName "PlatformType"         -DisplayName "Platform Type"
Set-DisplayName -InternalName "SPVersion"            -DisplayName "SharePoint Version"
Set-DisplayName -InternalName "ThirdPartyComponents" -DisplayName "Third-Party Components"
Set-DisplayName -InternalName "SPGroups"             -DisplayName "SharePoint Groups"
Set-DisplayName -InternalName "PermissionStructure"  -DisplayName "Permission Structure"
Set-DisplayName -InternalName "Workflows"            -DisplayName "Workflows / Automation"
Set-DisplayName -InternalName "ExternalIntegrations" -DisplayName "External Integrations"
Set-DisplayName -InternalName "SensitiveData"        -DisplayName "Handles Sensitive Data?"
Set-DisplayName -InternalName "ComplianceNotes"      -DisplayName "Compliance Notes"
Set-DisplayName -InternalName "DeprecatedDeps"       -DisplayName "Deprecated Dependencies?"

# Section C: Business Profile
Write-Host "`nSection C: Business Profile..." -ForegroundColor Cyan
Set-DisplayName -InternalName "BusinessPurpose"      -DisplayName "Business Purpose"
Set-DisplayName -InternalName "ActiveUsers"          -DisplayName "Active Users (Approx.)"
Set-DisplayName -InternalName "UsageFrequency"       -DisplayName "Usage Frequency"
Set-DisplayName -InternalName "LastActiveDate"       -DisplayName "Last Confirmed Active Date"
Set-DisplayName -InternalName "BusinessNeedStatus"   -DisplayName "Business Need Status"
Set-DisplayName -InternalName "BusinessNeedNotes"    -DisplayName "Business Need Notes"
Set-DisplayName -InternalName "BusinessImpact"       -DisplayName "Business Impact if Failed"
Set-DisplayName -InternalName "AlternativeAvailable" -DisplayName "Alternative Available?"

# Section D: Cost and Dependency Profile
Write-Host "`nSection D: Cost and Dependency Profile..." -ForegroundColor Cyan
Set-DisplayName -InternalName "LicensingCost"        -DisplayName "Licensing Cost (Annual)"
Set-DisplayName -InternalName "LicensingType"        -DisplayName "Licensing Type"
Set-DisplayName -InternalName "DevHours"             -DisplayName "Developer Hours (Annual Est.)"
Set-DisplayName -InternalName "TicketVolume"         -DisplayName "Support Ticket Volume (Annual Est.)"
Set-DisplayName -InternalName "KnowledgeRisk"        -DisplayName "Institutional Knowledge Risk"
Set-DisplayName -InternalName "KnowledgeHolder"      -DisplayName "Key Knowledge Holder"
Set-DisplayName -InternalName "HandoffReadiness"     -DisplayName "Hand-off Readiness"

# Section E: Disposition and Modernization
Write-Host "`nSection E: Disposition and Modernization..." -ForegroundColor Cyan
Set-DisplayName -InternalName "Disposition"            -DisplayName "Recommended Disposition"
Set-DisplayName -InternalName "DispositionRationale"   -DisplayName "Disposition Rationale"
Set-DisplayName -InternalName "DispositionConfirmedBy" -DisplayName "Disposition Confirmed By"
Set-DisplayName -InternalName "DispositionDate"        -DisplayName "Disposition Date"
Set-DisplayName -InternalName "TargetPlatform"         -DisplayName "Target Platform"
Set-DisplayName -InternalName "ModernizationEffort"    -DisplayName "Estimated Modernization Effort"
Set-DisplayName -InternalName "ModernizationPriority"  -DisplayName "Modernization Priority"
Set-DisplayName -InternalName "mDFFSCandidate"         -DisplayName "mDFFS Pattern Candidate?"
Set-DisplayName -InternalName "NextReviewDate"         -DisplayName "Next Review Date"

# Section F: Operational Documentation Status
Write-Host "`nSection F: Operational Documentation Status..." -ForegroundColor Cyan
Set-DisplayName -InternalName "URLsDocumented"         -DisplayName "URL(s) Documented"
Set-DisplayName -InternalName "PermissionsDocumented"  -DisplayName "Permission Structure Documented"
Set-DisplayName -InternalName "FormConfigDocumented"   -DisplayName "Form Configuration Documented"
Set-DisplayName -InternalName "WorkflowsDocumented"    -DisplayName "Workflows Documented"
Set-DisplayName -InternalName "EscalationDefined"      -DisplayName "Escalation Path Defined"
Set-DisplayName -InternalName "FirstLineResolvable"    -DisplayName "First-Line Resolvable?"
Set-DisplayName -InternalName "DocumentationLocation"  -DisplayName "Documentation Location"

#endregion Display Name Updates *#

#region Complete *#

Write-Host "`nDisplay name updates complete." -ForegroundColor Green
Write-Host "List '$listName' is ready at: $siteUrl" -ForegroundColor Green

#endregion Complete *#