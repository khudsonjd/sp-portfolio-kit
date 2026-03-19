$siteUrl='https://groovepoint.sharepoint.com/sites/Portfolio/'
Connect-PnPOnline -Url $siteUrl -Interactive -ClientId 'xxxxxx' -WarningAction SilentlyContinue
$item = Get-PnPListItem -List 'TAPCatalog' -Id 2
if ($item) {
    Write-Host 'Title:' $item.FieldValues.Title
    Write-Host 'Site:' $item.FieldValues.SiteCollection
    Write-Host 'ReportLink:' $item.FieldValues.LastReportLink
    Write-Host 'ReportDate:' $item.FieldValues.LastReportDate
} else {
    Write-Host 'Item 2 not found'
}
