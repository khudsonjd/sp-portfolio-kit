$siteUrl = 'https://groovepoint.sharepoint.com/sites/Portfolio/'
$clientId = 'xxxxxx'
Connect-PnPOnline -Url $siteUrl -Interactive -ClientId $clientId -WarningAction SilentlyContinue

$fields = Get-PnPField -List 'DFFSConfigurationList'
$fields | Select-Object InternalName, Title | Format-Table -AutoSize
