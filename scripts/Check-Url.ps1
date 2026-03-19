$siteUrl='https://groovepoint.sharepoint.com/sites/Portfolio/'
Connect-PnPOnline -Url $siteUrl -Interactive -ClientId 'xxxxxx' -WarningAction SilentlyContinue

$linkValue = "=1, View Site Report"

try {
    Set-PnPListItem -List 'TAPCatalog' -Identity 2 -Values @{ LastReportLink = $linkValue } -UpdateType SystemUpdate | Out-Null
    Write-Host 'Success with scalar string'
} catch {
    Write-Host 'Failed with scalar string:' $_
}

try {
    $fieldUrlValue = New-Object Microsoft.SharePoint.Client.FieldUrlValue
    $fieldUrlValue.Url = "=1"
    $fieldUrlValue.Description = "View Site Report"
    Set-PnPListItem -List 'TAPCatalog' -Identity 2 -Values @{ LastReportLink = $fieldUrlValue } -UpdateType SystemUpdate | Out-Null
    Write-Host 'Success with CSOM object'
} catch {
    Write-Host 'Failed with CSOM object:' $_
}
