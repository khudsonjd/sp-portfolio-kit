$catalogListName = 'TAPCatalog'
$linkDesc = 'View Site Report (20260311)'
$linkUrl = 'https://foo.com/bar.csv?web=1'
$CATALOG_LAST_REPORT_LINK = 'LastReportLink'

$payload = "{
    ""__metadata"": { ""type"": ""SP.Data.$($catalogListName)ListItem"" },
    ""$CATALOG_LAST_REPORT_LINK"": {
        ""Description"": ""$linkDesc"",
        ""Url"": ""$linkUrl""
    }
}"

Write-Host $payload
