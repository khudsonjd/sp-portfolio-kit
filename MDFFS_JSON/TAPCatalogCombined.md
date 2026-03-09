# mDFFS Form Configuration — TAPCCatalog
# Version: v08Mar26.1.0
#
# Instructions:
# 1. Go to DFFSConfigurationList on your SharePoint site.
# 2. Create three new items — one per block below.
# 3. For each item set:
#    - Title: as specified in each block header
#    - FormJSON: paste the FormJSON value
#    - RulesJSON: paste the RulesJSON value
# 4. All three entries use identical FormJSON and RulesJSON.
#
# Tab pivot IDs (used by RulesJSON):
#   Tab A — Identity:           11111111111111111
#   Tab B — Technical Profile:  22222222222222222
#   Tab C — Business Profile:   33333333333333333
#   Tab D — Cost & Dependency:  44444444444444444
#   Tab E — Disposition:        55555555555555555
#   Tab F — Documentation:      66666666666666666

# ============================================================
# ENTRIES 1, 2, AND 3
# Titles: TAPCCatalog_New / TAPCCatalog_Edit / TAPCCatalog_Display
# FormJSON and RulesJSON are identical for all three.
# ============================================================

# --- FORMJSON ---

[{"id":"1000000000000001","type":"grid","width":"","widthUnit":"px","style":"","children":[{"id":"1000000000000002","type":"row","style":"","children":[{"id":"1000000000000003","type":"col","style":"","size":{"sm":12,"md":12,"lg":12,"xl":4},"children":[{"id":"1000000000000004","type":"field","fin":"ID","useCustomFieldLabel":false,"useCustomFieldLabelMUI":false,"fieldLabel":"ID","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":0}],"childIndex":0}],"childIndex":0},{"id":"1000000000000005","type":"row","style":"","children":[{"id":"1000000000000006","type":"col","style":"","size":{"sm":12,"md":12,"lg":12,"xl":12},"children":[{"id":"1000000000000007","type":"pivot","style":"","sticky":false,"children":[{"id":"11111111111111111","type":"pivotItem","text":"A — Identity","style":"","children":[{"id":"1000000000000008","type":"row","style":"","children":[{"id":"1000000000000009","type":"col","style":"","size":{"sm":12,"md":12,"lg":12,"xl":12},"children":[],"childIndex":0}],"childIndex":0}],"childIndex":0},{"id":"22222222222222222","type":"pivotItem","text":"B — Technical","style":"","children":[{"id":"1000000000000010","type":"row","style":"","children":[{"id":"1000000000000011","type":"col","style":"","size":{"sm":12,"md":12,"lg":12,"xl":12},"children":[],"childIndex":0}],"childIndex":0}],"childIndex":1},{"id":"33333333333333333","type":"pivotItem","text":"C — Business","style":"","children":[{"id":"1000000000000012","type":"row","style":"","children":[{"id":"1000000000000013","type":"col","style":"","size":{"sm":12,"md":12,"lg":12,"xl":12},"children":[],"childIndex":0}],"childIndex":0}],"childIndex":2},{"id":"44444444444444444","type":"pivotItem","text":"D — Cost & Dependency","style":"","children":[{"id":"1000000000000014","type":"row","style":"","children":[{"id":"1000000000000015","type":"col","style":"","size":{"sm":12,"md":12,"lg":12,"xl":12},"children":[],"childIndex":0}],"childIndex":0}],"childIndex":3},{"id":"55555555555555555","type":"pivotItem","text":"E — Disposition","style":"","children":[{"id":"1000000000000016","type":"row","style":"","children":[{"id":"1000000000000017","type":"col","style":"","size":{"sm":12,"md":12,"lg":12,"xl":12},"children":[],"childIndex":0}],"childIndex":0}],"childIndex":4},{"id":"66666666666666666","type":"pivotItem","text":"F — Documentation","style":"","children":[{"id":"1000000000000018","type":"row","style":"","children":[{"id":"1000000000000019","type":"col","style":"","size":{"sm":12,"md":12,"lg":12,"xl":12},"children":[],"childIndex":0}],"childIndex":0}],"childIndex":5}],"childIndex":0,"defaultSelected":"11111111111111111"},
{"id":"2000000000000001","type":"field","fin":"Title","useCustomFieldLabel":true,"fieldLabel":"Solution Name","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":1},
{"id":"2000000000000002","type":"field","fin":"SolutionID","useCustomFieldLabel":true,"fieldLabel":"Solution ID","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":2},
{"id":"2000000000000003","type":"field","fin":"SolutionURLs","useCustomFieldLabel":true,"fieldLabel":"Solution URL(s)","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":3},
{"id":"2000000000000004","type":"field","fin":"SiteCollection","useCustomFieldLabel":true,"fieldLabel":"Site Collection","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":4},
{"id":"2000000000000005","type":"field","fin":"Department","useCustomFieldLabel":true,"fieldLabel":"Department / Business Unit","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":5},
{"id":"2000000000000006","type":"field","fin":"BusinessOwnerName","useCustomFieldLabel":true,"fieldLabel":"Business Owner Name","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":6},
{"id":"2000000000000007","type":"field","fin":"BusinessOwnerEmail","useCustomFieldLabel":true,"fieldLabel":"Business Owner Email","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":7},
{"id":"2000000000000008","type":"field","fin":"ITContact","useCustomFieldLabel":true,"fieldLabel":"IT Contact / Developer","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":8},
{"id":"2000000000000009","type":"field","fin":"DateAdded","useCustomFieldLabel":true,"fieldLabel":"Date Added to Catalog","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":9},
{"id":"2000000000000010","type":"field","fin":"LastUpdated","useCustomFieldLabel":true,"fieldLabel":"Last Updated","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":10},
{"id":"3000000000000001","type":"field","fin":"PlatformType","useCustomFieldLabel":true,"fieldLabel":"Platform Type","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":11},
{"id":"3000000000000002","type":"field","fin":"SPVersion","useCustomFieldLabel":true,"fieldLabel":"SharePoint Version","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":12},
{"id":"3000000000000003","type":"field","fin":"ThirdPartyComponents","useCustomFieldLabel":true,"fieldLabel":"Third-Party Components","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":13},
{"id":"3000000000000004","type":"field","fin":"SPGroups","useCustomFieldLabel":true,"fieldLabel":"SharePoint Groups","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":14},
{"id":"3000000000000005","type":"field","fin":"PermissionStructure","useCustomFieldLabel":true,"fieldLabel":"Permission Structure","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":15},
{"id":"3000000000000006","type":"field","fin":"Workflows","useCustomFieldLabel":true,"fieldLabel":"Workflows / Automation","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":16},
{"id":"3000000000000007","type":"field","fin":"ExternalIntegrations","useCustomFieldLabel":true,"fieldLabel":"External Integrations","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":17},
{"id":"3000000000000008","type":"field","fin":"SensitiveData","useCustomFieldLabel":true,"fieldLabel":"Handles Sensitive Data?","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":18},
{"id":"3000000000000009","type":"field","fin":"ComplianceNotes","useCustomFieldLabel":true,"fieldLabel":"Compliance Notes","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":19},
{"id":"3000000000000010","type":"field","fin":"DeprecatedDeps","useCustomFieldLabel":true,"fieldLabel":"Deprecated Dependencies?","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":20},
{"id":"4000000000000001","type":"field","fin":"BusinessPurpose","useCustomFieldLabel":true,"fieldLabel":"Business Purpose","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":21},
{"id":"4000000000000002","type":"field","fin":"ActiveUsers","useCustomFieldLabel":true,"fieldLabel":"Active Users (Approx.)","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":22},
{"id":"4000000000000003","type":"field","fin":"UsageFrequency","useCustomFieldLabel":true,"fieldLabel":"Usage Frequency","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":23},
{"id":"4000000000000004","type":"field","fin":"LastActiveDate","useCustomFieldLabel":true,"fieldLabel":"Last Confirmed Active Date","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":24},
{"id":"4000000000000005","type":"field","fin":"BusinessNeedStatus","useCustomFieldLabel":true,"fieldLabel":"Business Need Status","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":25},
{"id":"4000000000000006","type":"field","fin":"BusinessNeedNotes","useCustomFieldLabel":true,"fieldLabel":"Business Need Notes","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":26},
{"id":"4000000000000007","type":"field","fin":"BusinessImpact","useCustomFieldLabel":true,"fieldLabel":"Business Impact if Failed","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":27},
{"id":"4000000000000008","type":"field","fin":"AlternativeAvailable","useCustomFieldLabel":true,"fieldLabel":"Alternative Available?","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":28},
{"id":"5000000000000001","type":"field","fin":"LicensingCost","useCustomFieldLabel":true,"fieldLabel":"Licensing Cost (Annual)","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":29},
{"id":"5000000000000002","type":"field","fin":"LicensingType","useCustomFieldLabel":true,"fieldLabel":"Licensing Type","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":30},
{"id":"5000000000000003","type":"field","fin":"DevHours","useCustomFieldLabel":true,"fieldLabel":"Developer Hours (Annual Est.)","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":31},
{"id":"5000000000000004","type":"field","fin":"TicketVolume","useCustomFieldLabel":true,"fieldLabel":"Support Ticket Volume (Annual Est.)","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":32},
{"id":"5000000000000005","type":"field","fin":"KnowledgeRisk","useCustomFieldLabel":true,"fieldLabel":"Institutional Knowledge Risk","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":33},
{"id":"5000000000000006","type":"field","fin":"KnowledgeHolder","useCustomFieldLabel":true,"fieldLabel":"Key Knowledge Holder","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":34},
{"id":"5000000000000007","type":"field","fin":"HandoffReadiness","useCustomFieldLabel":true,"fieldLabel":"Hand-off Readiness","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":35},
{"id":"6000000000000001","type":"field","fin":"Disposition","useCustomFieldLabel":true,"fieldLabel":"Recommended Disposition","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":36},
{"id":"6000000000000002","type":"field","fin":"DispositionRationale","useCustomFieldLabel":true,"fieldLabel":"Disposition Rationale","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":37},
{"id":"6000000000000003","type":"field","fin":"DispositionConfirmedBy","useCustomFieldLabel":true,"fieldLabel":"Disposition Confirmed By","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":38},
{"id":"6000000000000004","type":"field","fin":"DispositionDate","useCustomFieldLabel":true,"fieldLabel":"Disposition Date","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":39},
{"id":"6000000000000005","type":"field","fin":"TargetPlatform","useCustomFieldLabel":true,"fieldLabel":"Target Platform","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":40},
{"id":"6000000000000006","type":"field","fin":"ModernizationEffort","useCustomFieldLabel":true,"fieldLabel":"Estimated Modernization Effort","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":41},
{"id":"6000000000000007","type":"field","fin":"ModernizationPriority","useCustomFieldLabel":true,"fieldLabel":"Modernization Priority","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":42},
{"id":"6000000000000008","type":"field","fin":"mDFFSCandidate","useCustomFieldLabel":true,"fieldLabel":"mDFFS Pattern Candidate?","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":43},
{"id":"6000000000000009","type":"field","fin":"NextReviewDate","useCustomFieldLabel":true,"fieldLabel":"Next Review Date","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":44},
{"id":"7000000000000001","type":"field","fin":"URLsDocumented","useCustomFieldLabel":true,"fieldLabel":"URL(s) Documented","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":45},
{"id":"7000000000000002","type":"field","fin":"PermissionsDocumented","useCustomFieldLabel":true,"fieldLabel":"Permission Structure Documented","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":46},
{"id":"7000000000000003","type":"field","fin":"FormConfigDocumented","useCustomFieldLabel":true,"fieldLabel":"Form Configuration Documented","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":47},
{"id":"7000000000000004","type":"field","fin":"WorkflowsDocumented","useCustomFieldLabel":true,"fieldLabel":"Workflows Documented","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":48},
{"id":"7000000000000005","type":"field","fin":"EscalationDefined","useCustomFieldLabel":true,"fieldLabel":"Escalation Path Defined","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":49},
{"id":"7000000000000006","type":"field","fin":"FirstLineResolvable","useCustomFieldLabel":true,"fieldLabel":"First-Line Resolvable?","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":50},
{"id":"7000000000000007","type":"field","fin":"DocumentationLocation","useCustomFieldLabel":true,"fieldLabel":"Documentation Location","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":51},
{"id":"7000000000000008","type":"field","fin":"Attachments","useCustomFieldLabel":false,"fieldLabel":"Attachments","labelPosition":"left","labelStyle":"","style":"","fieldLabelMUI":{},"fieldDescription":"","fieldDescriptionMUI":{},"useCustomFieldDescription":false,"useCustomDescriptionMUI":false,"childIndex":52}
],"childIndex":0}],"childIndex":0}],"childIndex":1}]}]


# --- RULESJSON ---

[
  {
    "id":"1100000000000001",
    "name":"Tab A — Identity",
    "groupName":"Default group",
    "condition":{"operator":"and","children":[{"type":"row","trigger":"selectedTab","operator":"","triggervalue":"11111111111111111"}]},
    "actionYes":{"expanded":{"visibleFields":true},"sortOrder":["visibleFields"],"visibleFields":["Title","SolutionID","SolutionURLs","SiteCollection","Department","BusinessOwnerName","BusinessOwnerEmail","ITContact","DateAdded","LastUpdated"]},
    "actionNo":{"expanded":{"hiddenFields":true},"sortOrder":["hiddenFields"],"hiddenFields":["Title","SolutionID","SolutionURLs","SiteCollection","Department","BusinessOwnerName","BusinessOwnerEmail","ITContact","DateAdded","LastUpdated"]},
    "ruleActionTriggerOn":"load"
  },
  {
    "id":"1100000000000002",
    "name":"Tab B — Technical",
    "groupName":"Default group",
    "condition":{"operator":"and","children":[{"type":"row","trigger":"selectedTab","operator":"","triggervalue":"22222222222222222"}]},
    "actionYes":{"expanded":{"visibleFields":true},"sortOrder":["visibleFields"],"visibleFields":["PlatformType","SPVersion","ThirdPartyComponents","SPGroups","PermissionStructure","Workflows","ExternalIntegrations","SensitiveData","ComplianceNotes","DeprecatedDeps"]},
    "actionNo":{"expanded":{"hiddenFields":true},"sortOrder":["hiddenFields"],"hiddenFields":["PlatformType","SPVersion","ThirdPartyComponents","SPGroups","PermissionStructure","Workflows","ExternalIntegrations","SensitiveData","ComplianceNotes","DeprecatedDeps"]}
  },
  {
    "id":"1100000000000003",
    "name":"Tab C — Business",
    "groupName":"Default group",
    "condition":{"operator":"and","children":[{"type":"row","trigger":"selectedTab","operator":"","triggervalue":"33333333333333333"}]},
    "actionYes":{"expanded":{"visibleFields":true},"sortOrder":["visibleFields"],"visibleFields":["BusinessPurpose","ActiveUsers","UsageFrequency","LastActiveDate","BusinessNeedStatus","BusinessNeedNotes","BusinessImpact","AlternativeAvailable"]},
    "actionNo":{"expanded":{"hiddenFields":true},"sortOrder":["hiddenFields"],"hiddenFields":["BusinessPurpose","ActiveUsers","UsageFrequency","LastActiveDate","BusinessNeedStatus","BusinessNeedNotes","BusinessImpact","AlternativeAvailable"]}
  },
  {
    "id":"1100000000000004",
    "name":"Tab D — Cost & Dependency",
    "groupName":"Default group",
    "condition":{"operator":"and","children":[{"type":"row","trigger":"selectedTab","operator":"","triggervalue":"44444444444444444"}]},
    "actionYes":{"expanded":{"visibleFields":true},"sortOrder":["visibleFields"],"visibleFields":["LicensingCost","LicensingType","DevHours","TicketVolume","KnowledgeRisk","KnowledgeHolder","HandoffReadiness"]},
    "actionNo":{"expanded":{"hiddenFields":true},"sortOrder":["hiddenFields"],"hiddenFields":["LicensingCost","LicensingType","DevHours","TicketVolume","KnowledgeRisk","KnowledgeHolder","HandoffReadiness"]}
  },
  {
    "id":"1100000000000005",
    "name":"Tab E — Disposition",
    "groupName":"Default group",
    "condition":{"operator":"and","children":[{"type":"row","trigger":"selectedTab","operator":"","triggervalue":"55555555555555555"}]},
    "actionYes":{"expanded":{"visibleFields":true},"sortOrder":["visibleFields"],"visibleFields":["Disposition","DispositionRationale","DispositionConfirmedBy","DispositionDate","TargetPlatform","ModernizationEffort","ModernizationPriority","mDFFSCandidate","NextReviewDate"]},
    "actionNo":{"expanded":{"hiddenFields":true},"sortOrder":["hiddenFields"],"hiddenFields":["Disposition","DispositionRationale","DispositionConfirmedBy","DispositionDate","TargetPlatform","ModernizationEffort","ModernizationPriority","mDFFSCandidate","NextReviewDate"]}
  },
  {
    "id":"1100000000000006",
    "name":"Tab F — Documentation",
    "groupName":"Default group",
    "condition":{"operator":"and","children":[{"type":"row","trigger":"selectedTab","operator":"","triggervalue":"66666666666666666"}]},
    "actionYes":{"expanded":{"visibleFields":true},"sortOrder":["visibleFields"],"visibleFields":["URLsDocumented","PermissionsDocumented","FormConfigDocumented","WorkflowsDocumented","EscalationDefined","FirstLineResolvable","DocumentationLocation","Attachments"]},
    "actionNo":{"expanded":{"hiddenFields":true},"sortOrder":["hiddenFields"],"hiddenFields":["URLsDocumented","PermissionsDocumented","FormConfigDocumented","WorkflowsDocumented","EscalationDefined","FirstLineResolvable","DocumentationLocation","Attachments"]}
  }
]