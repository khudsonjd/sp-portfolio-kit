$siteUrl = 'https://groovepoint.sharepoint.com/sites/Portfolio/'
$clientId = '3dac4cee-ad25-4e62-a904-60d2cbc36c9b'
Connect-PnPOnline -Url $siteUrl -Interactive -ClientId $clientId -WarningAction SilentlyContinue

$fields = Get-PnPField -List 'DFFSConfigurationList'
$fields | Select-Object InternalName, Title | Format-Table -AutoSize
