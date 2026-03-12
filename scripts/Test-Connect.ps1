# Test-Connect.ps1
# Purpose: Verify PnP authentication and confirm inventory list is accessible.

$siteUrl  = "https://groovepoint.sharepoint.com/sites/Portfolio"
$listName = "MasterSharePointInventory"
$tenant   = "groovepoint.onmicrosoft.com"
$clientId = "b5f5a994-c6ce-4f72-b9fe-9d309bd0cb40"

# --- Load PnP 1.x ---
$pnpV1 = Get-Module -ListAvailable -Name "PnP.PowerShell" |
          Where-Object { $_.Version.Major -lt 2 } |
          Sort-Object Version -Descending |
          Select-Object -First 1

if ($null -eq $pnpV1) {
    Write-Host "ERROR: PnP.PowerShell 1.x not found." -ForegroundColor Red
    exit 1
}

Import-Module $pnpV1.Path -ErrorAction Stop
Write-Host "Loaded PnP.PowerShell $($pnpV1.Version)" -ForegroundColor Cyan

# --- Connect ---
Write-Host ""
Write-Host "Connecting to $siteUrl ..." -ForegroundColor Cyan
Write-Host "Watch for a device code prompt in this console window." -ForegroundColor Yellow

try {
    Connect-PnPOnline -Url $siteUrl -DeviceLogin -Tenant $tenant -ClientId $clientId
    Write-Host "Connection succeeded." -ForegroundColor Green
}
catch {
    Write-Host "Connection FAILED: $_" -ForegroundColor Red
    exit 1
}

# --- Check list ---
Write-Host ""
Write-Host "Looking for list '$listName' ..." -ForegroundColor Cyan

try {
    $list = Get-PnPList -Identity $listName
    if ($null -ne $list) {
        Write-Host "SUCCESS: Found list '$($list.Title)' (item count: $($list.ItemCount))" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Get-PnPList returned null for '$listName'." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "FAILED to retrieve list '$listName': $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Test complete." -ForegroundColor Cyan