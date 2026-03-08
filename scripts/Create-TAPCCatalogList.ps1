# Create-TAPCCatalogList.ps1
# Creates the TAPC Solution Catalog list on a SharePoint site.
# Requires: PnP PowerShell module, Site Collection Admin access.
# Compatible with: PowerShell 5.1 and PowerShell 7.

# --- Prompt for site URL ---
$defaultUrl = "https://groovepoint.sharepoint.com/sites/Portfolio/"
$inputUrl = Read-Host "Enter SharePoint site URL [press Enter for default: $defaultUrl]"
$siteUrl = if ($inputUrl.Trim() -eq "") { $defaultUrl } else { $inputUrl.Trim() }

Write-Host "`nConnecting to: $siteUrl" -ForegroundColor Cyan

# --- Connect ---
try {
    Connect-PnPOnline -Url $siteUrl -WebLogin
    Write-Host "Connected successfully.`n" -ForegroundColor Green
} catch {
    Write-Host "Connection failed: $_" -ForegroundColor Red
    exit 1
}

# --- List name ---
$listName = "TAPC Solution Catalog"

# --- Check if list already exists ---
$existing = Get-PnPList -Identity $listName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "A list named '$listName' already exists on this site. Exiting without changes." -ForegroundColor Yellow
    exit 0
}

# --- Create the list ---
Write-Host "Creating list: $listName..." -ForegroundColor Cyan
New-PnPList -Title $listName -Template GenericList -OnQuickLaunch
Write-Host "List created.`n" -ForegroundColor Green

# --- Helper function to add a choice field ---
function Add-ChoiceField {
    param (
        [string]$DisplayName,
        [string]$InternalName,
        [string[]]$Choices,
        [bool]$Required = $false
    )
    $choiceXml = "<Field Type='Choice' DisplayName='$DisplayName' Name='$InternalName' Required='$(if($Required){'TRUE'}else{'FALSE'})' Format='Dropdown'><CHOICES>"
    foreach ($c in $Choices) { $choiceXml += "<CHOICE>$c</CHOICE>" }
    $choiceXml += "</CHOICES></Field>"
    Add-PnPFieldFromXml -List $listName -FieldXml $choiceXml | Out-Null
}

# --- Helper function to add a text field ---
function Add-TextField {
    param (
        [string]$DisplayName,
        [string]$InternalName,
        [bool]$Required = $false,
        [bool]$Multiline = $false
    )
    if ($Multiline) {
        $xml = "<Field Type='Note' DisplayName='$DisplayName' Name='$InternalName' Required='$(if($Required){'TRUE'}else{'FALSE'})' NumLines='6' />"
    } else {
        $xml = "<Field Type='Text' DisplayName='$DisplayName' Name='$InternalName' Required='$(if($Required){'TRUE'}else{'FALSE'})' />"
    }
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}

# --- Helper function to add a date field ---
function Add-DateField {
    param (
        [string]$DisplayName,
        [string]$InternalName,
        [bool]$Required = $false
    )
    $xml = "<Field Type='DateTime' DisplayName='$DisplayName' Name='$InternalName' Required='$(if($Required){'TRUE'}else{'FALSE'})' Format='DateOnly' />"
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}

# --- Helper function to add a number field ---
function Add-NumberField {
    param (
        [string]$DisplayName,
        [string]$InternalName,
        [bool]$Required = $false
    )
    $xml = "<Field Type='Number' DisplayName='$DisplayName' Name='$InternalName' Required='$(if($Required){'TRUE'}else{'FALSE'})' />"
    Add-PnPFieldFromXml -List $listName -FieldXml $xml | Out-Null
}

# --- Section A: Solution Identity ---
Write-Host "Adding Section A: Solution Identity..." -ForegroundColor Cyan
# Title field (Solution Name) is created by default — rename it
Set-PnPField -List $listName -Identity "Title" -Values @{Title = "Solution Name"} | Out-Null
Add-TextField    -DisplayName "Solution ID"              -InternalName "SolutionID"           -Required $true
Add-TextField    -DisplayName "Solution URL(s)"          -InternalName "SolutionURLs"          -Required $true
Add-TextField    -DisplayName "Site Collection"          -InternalName "SiteCollection"        -Required $true
Add-TextField    -DisplayName "Department / Business Unit" -InternalName "Department"          -Required $true
Add-TextField    -DisplayName "Business Owner Name"      -InternalName "BusinessOwnerName"     -Required $true
Add-TextField    -DisplayName "Business Owner Email"     -InternalName "BusinessOwnerEmail"    -Required $true
Add-TextField    -DisplayName "IT Contact / Developer"   -InternalName "ITContact"             -Required $true
Add-DateField    -DisplayName "Date Added to Catalog"    -InternalName "DateAdded"             -Required $true
Add-DateField    -DisplayName "Last Updated"             -InternalName "LastUpdated"           -Required $true

# --- Section B: Technical Profile ---
Write-Host "Adding Section B: Technical Profile..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "Platform Type"            -InternalName "PlatformType"          -Choices @("Power Apps","Classic DFFS","mDFFS","Native SharePoint","Other")
Add-ChoiceField  -DisplayName "SharePoint Version"       -InternalName "SPVersion"             -Choices @("SharePoint Online","SharePoint 2019","SharePoint 2016","Other")
Add-TextField    -DisplayName "Third-Party Components"   -InternalName "ThirdPartyComponents"  -Multiline $true
Add-TextField    -DisplayName "SharePoint Groups"        -InternalName "SPGroups"              -Multiline $true
Add-TextField    -DisplayName "Permission Structure"     -InternalName "PermissionStructure"   -Multiline $true
Add-TextField    -DisplayName "Workflows / Automation"   -InternalName "Workflows"             -Multiline $true
Add-TextField    -DisplayName "External Integrations"    -InternalName "ExternalIntegrations"  -Multiline $true
Add-ChoiceField  -DisplayName "Handles Sensitive Data?"  -InternalName "SensitiveData"         -Choices @("Yes","No","Unknown")
Add-TextField    -DisplayName "Compliance Notes"         -InternalName "ComplianceNotes"       -Multiline $true
Add-ChoiceField  -DisplayName "Deprecated Dependencies?" -InternalName "DeprecatedDeps"        -Choices @("Yes","No","Unknown")

# --- Section C: Business Profile ---
Write-Host "Adding Section C: Business Profile..." -ForegroundColor Cyan
Add-TextField    -DisplayName "Business Purpose"         -InternalName "BusinessPurpose"       -Multiline $true
Add-NumberField  -DisplayName "Active Users (Approx.)"  -InternalName "ActiveUsers"
Add-ChoiceField  -DisplayName "Usage Frequency"         -InternalName "UsageFrequency"         -Choices @("Daily","Weekly","Monthly","Rarely","Unknown")
Add-DateField    -DisplayName "Last Confirmed Active Date" -InternalName "LastActiveDate"
Add-ChoiceField  -DisplayName "Business Need Status"    -InternalName "BusinessNeedStatus"     -Choices @("Active","Unclear","No longer active")
Add-TextField    -DisplayName "Business Need Notes"     -InternalName "BusinessNeedNotes"      -Multiline $true
Add-ChoiceField  -DisplayName "Business Impact if Failed" -InternalName "BusinessImpact"       -Choices @("Critical","High","Medium","Low")
Add-ChoiceField  -DisplayName "Alternative Available?"  -InternalName "AlternativeAvailable"   -Choices @("Yes","No","Partial")

# --- Section D: Cost & Dependency Profile ---
Write-Host "Adding Section D: Cost and Dependency Profile..." -ForegroundColor Cyan
Add-TextField    -DisplayName "Licensing Cost (Annual)"  -InternalName "LicensingCost"
Add-ChoiceField  -DisplayName "Licensing Type"           -InternalName "LicensingType"         -Choices @("Power Apps per-user","Power Apps per-app","M365 included","No additional license","Other")
Add-NumberField  -DisplayName "Developer Hours (Annual Est.)" -InternalName "DevHours"
Add-NumberField  -DisplayName "Support Ticket Volume (Annual Est.)" -InternalName "TicketVolume"
Add-ChoiceField  -DisplayName "Institutional Knowledge Risk" -InternalName "KnowledgeRisk"     -Choices @("High (one person)","Medium (small team)","Low (documented)")
Add-TextField    -DisplayName "Key Knowledge Holder"     -InternalName "KnowledgeHolder"
Add-ChoiceField  -DisplayName "Hand-off Readiness"       -InternalName "HandoffReadiness"      -Choices @("Ready","Partially ready","Not ready")

# --- Section E: Disposition & Modernization ---
Write-Host "Adding Section E: Disposition and Modernization..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "Recommended Disposition"  -InternalName "Disposition"           -Choices @("Sunset","Migrate","Modernize","Retain and Document")
Add-TextField    -DisplayName "Disposition Rationale"    -InternalName "DispositionRationale"  -Multiline $true
Add-TextField    -DisplayName "Disposition Confirmed By" -InternalName "DispositionConfirmedBy"
Add-DateField    -DisplayName "Disposition Date"         -InternalName "DispositionDate"
Add-ChoiceField  -DisplayName "Target Platform"          -InternalName "TargetPlatform"        -Choices @("mDFFS","Native SharePoint","Power Apps","Other enterprise platform")
Add-TextField    -DisplayName "Estimated Modernization Effort" -InternalName "ModernizationEffort"
Add-ChoiceField  -DisplayName "Modernization Priority"   -InternalName "ModernizationPriority" -Choices @("High","Medium","Low","Deferred")
Add-ChoiceField  -DisplayName "mDFFS Pattern Candidate?" -InternalName "mDFFSCandidate"        -Choices @("Yes","No","Possibly")
Add-DateField    -DisplayName "Next Review Date"         -InternalName "NextReviewDate"

# --- Section F: Operational Documentation Status ---
Write-Host "Adding Section F: Operational Documentation Status..." -ForegroundColor Cyan
Add-ChoiceField  -DisplayName "URL(s) Documented"        -InternalName "URLsDocumented"        -Choices @("Complete","Partial","Not started")
Add-ChoiceField  -DisplayName "Permission Structure Documented" -InternalName "PermissionsDocumented" -Choices @("Complete","Partial","Not started")
Add-ChoiceField  -DisplayName "Form Configuration Documented"  -InternalName "FormConfigDocumented"  -Choices @("Complete","Partial","Not started","N/A")
Add-ChoiceField  -DisplayName "Workflows Documented"     -InternalName "WorkflowsDocumented"   -Choices @("Complete","Partial","Not started","N/A")
Add-ChoiceField  -DisplayName "Escalation Path Defined"  -InternalName "EscalationDefined"     -Choices @("Complete","Not started")
Add-ChoiceField  -DisplayName "First-Line Resolvable?"   -InternalName "FirstLineResolvable"   -Choices @("Yes","Partially","No")
Add-TextField    -DisplayName "Documentation Location"   -InternalName "DocumentationLocation"

Write-Host "`nAll fields added successfully." -ForegroundColor Green
Write-Host "List '$listName' is ready at: $siteUrl" -ForegroundColor Green