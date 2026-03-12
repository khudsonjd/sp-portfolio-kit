$siteUrl = 'https://groovepoint.sharepoint.com/sites/Portfolio/'
$clientId = '3dac4cee-ad25-4e62-a904-60d2cbc36c9b'
Connect-PnPOnline -Url $siteUrl -Interactive -ClientId $clientId -WarningAction SilentlyContinue 

$items = Get-PnPListItem -List 'DFFSConfigurationList' -PageSize 20
$mdffs = $items | Where-Object { $_["Title"] -like "*TAPCatalog*" }

if ($mdffs) {
    Write-Output "Found matching configs:"
    foreach ($item in $mdffs) {
        Write-Output "TITLE: $($item['Title']) | TYPE: $($item['FormType'])"
        $json = $item["JSON"]
        Write-Output "JSON starts with: $($json.Substring(0, [math]::Min(50, $json.Length)))"
        Write-Output "JSON ends with: $($json.Substring([math]::Max(0, $json.Length - 50)))"
        Write-Output "Length: $($json.Length)`n"
    }
} else {
    Write-Output "No TAPCatalog configs found"
}
