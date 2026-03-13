$catalogListName='TAPCatalog'
$linkDesc='Desc'
$linkUrl='url'
$CATALOG_LAST_REPORT_LINK='Link'
$payloadStr = "{""__metadata"": {""type"": ""SP.Data.$($catalogListName)ListItem""}, ""$CATALOG_LAST_REPORT_LINK"": {""Description"": ""$linkDesc"", ""Url"": ""$linkUrl""}}"
Write-Host ""$payloadStr""
