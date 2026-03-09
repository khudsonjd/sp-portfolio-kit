# Modern DFFS User Manual
> Last updated October 11, 2025

---

## Table of Contents

1. [Enter Setup](#1-enter-setup)
   - 1.1 [Create Configuration List](#11-create-configuration-list)
   - 1.2 [Enter Setup or Add / Change the License Code](#12-enter-setup-or-add--change-the-license-code)
     - 1.2.1 [Generate Challenge Code](#121-generate-challenge-code)
     - 1.2.2 [Production or Development Mode](#122-production-or-development-mode)
     - 1.2.3 [Select the Form You Want to Configure](#123-select-the-form-you-want-to-configure)
     - 1.2.4 [Install DFFS in the Form](#124-install-dffs-in-the-form)
2. [Configuration of a Form](#2-configuration-of-a-form)
   - 2.1 [Banner Buttons](#21-banner-buttons)
   - 2.2 [Formbuilder](#22-formbuilder)
   - 2.3 [Preview Form](#23-preview-form)
   - 2.4 [Rules](#24-rules)
   - 2.5 [Custom JS](#25-custom-js)
   - 2.6 [Custom CSS](#26-custom-css)
   - 2.7 [Miscellaneous](#27-miscellaneous)
   - 2.8 [Note to Self](#28-note-to-self)
   - 2.9 [Install DFFS](#29-install-dffs)
3. [Printing a DFFS Form](#3-printing-a-dffs-form)
4. [Sending Emails Using FLOW](#4-sending-emails-using-flow)
   - 4.1 [FLOW Configuration for Send Now](#41-flow-configuration-for-send-now)
   - 4.2 [FLOW Configuration for Send Later](#42-flow-configuration-for-send-later)
5. [DFFS Configuration WebPart](#5-dffs-configuration-webpart)
6. [Modern DFFS Formpage Web Part](#6-modern-dffs-formpage-web-part)
   - 6.1 [Setting a Default Redirect in the Form URL](#61-setting-a-default-redirect-in-the-form-url)
7. [Upgrade from Classic DFFS](#7-upgrade-from-classic-dffs)
8. [Troubleshooting](#8-troubleshooting)
   - 8.1 [Blocked Web Resources](#81-blocked-web-resources)
   - 8.2 [Other Blocked Resources](#82-other-blocked-resources)

---

## 1 Enter Setup

### 1.1 Create Configuration List

When you have installed the Modern DFFS you will see a button **"DFFS"** in the banner of the list. This will only be shown for users with **Manage lists** permission. Click this button to enter the setup.

> *In v1.2.0 a new DFFS configuration web part has been added. It lets you configure the forms from a site page on each site. Read more about this web part in a separate section.*

The first time you enter setup you must create the configuration list. Click the **Create list** button when prompted.

This configuration list is a standard custom list, but it is by default hidden from all site contents. You are not supposed to manually edit this list, but it can be accessed by typing in the list name in the URL:

```
…/Lists/DFFSConfigurationList
```

> ⚠️ **Note:** All users must have permission to view items in this list to access the configuration for the list.

---

### 1.2 Enter Setup or Add / Change the License Code

When you have created the configuration list and clicked the DFFS button again you will see the main setup screen.

#### 1.2.1 Generate Challenge Code

When you purchase a site collection license you must generate a challenge code to bind the license code to the current site collection. Click **Add / change license code** to access the challenge code.

You get a **30-day trial** when you first install the solution. To purchase a license or ask for a quote, visit: https://spjsworks.com/purchase

#### 1.2.2 Production or Development Mode

You can toggle between production and development mode using the toggle in the top left corner of the setup screen.

When in **Development mode** and entering a form configuration, you will see a yellow **Development mode** button in the top right corner. Clicking this button lets you assess your development mode configuration in a new window.

#### 1.2.3 Select the Form You Want to Configure

From the drop-down menu you can select which form to configure:

| Form | Purpose |
|---|---|
| **NewForm** | Used to create new list items (not available in document libraries) |
| **DispForm** | Used to display an existing list item |
| **EditForm** | Used to edit an existing list item |

#### 1.2.4 Install DFFS in the Form

From **v1.1.x** of Modern DFFS you must install / register DFFS as the default form for each of the forms in the content types in your list. Use the **Install DFFS** tab and toggle the button to activate it for each form type (New item form, View item form, Edit item form).

> ⚠️ **Note:** Sometimes when toggling the view item form on, it turns the other forms off. If that happens, just toggle them back on.

You can also enable: **Show information dialog when DFFS is not installed in the current form.**

---

## 2 Configuration of a Form

When you open the configuration for the first time, all fields are automatically added to the form. You can delete the ones you do not want to have visible — deleting a field from the configuration for one form does not delete it from the list settings.

To add new fields to your list you must use the default list settings. You will find a link to open list settings from the **Miscellaneous** tab.

You can rearrange fields by drag-and-drop, and access the properties pane for all elements using the hamburger button or the right-click menu.

---

### 2.1 Banner Buttons

#### 2.1.1 Save
Saves the configuration.

#### 2.1.2 Import / Export
Opens a panel where you can:
- Browse other configurations and restore points for this list
- Import configurations from Classic DFFS (if in use on this site)
- Import / export as JSON from Classic or Modern DFFS

#### 2.1.3 Create a Restore Point
Creates a restore point so you can revert to this configuration if needed. **Recommended before making major changes.**

#### 2.1.4 Switch Form
Switch between NewForm, DispForm, and EditForm. (NewForm is not available in document libraries.)

#### 2.1.5 Delete
Sends the configuration to the recycle bin and reverts the list back to the out-of-the-box SharePoint form.

---

### 2.2 Formbuilder

Use the banner buttons to drag-and-drop form elements onto the form. Available elements:

- Row
- Column
- Tab set
- Rich text
- HTML
- Custom Row
- Grid
- Field
- vLookup

Configure all form elements by opening the properties pane via the hamburger button or right-click menu.

#### 2.2.1 Row
Rows are placeholders for columns. You can add an unlimited number of rows to your form.

##### 2.2.1.1 Accordions
Rows can be configured as accordions to let users collapse each row. Select **Row properties** to configure this.

#### 2.2.2 Column
A row has **12 available sections**. You can have one column spanning all 12 sections, or distribute sections across up to 12 columns. Column properties allow responsive sizing for different screen sizes.

#### 2.2.3 Tab Set
Tab sets support any number of tabs. Options include:
- Custom tab colors (individual or default for all tabs via Miscellaneous)
- **Sticky** tab set — stays at the top of the screen when scrolling
- **Multi-step form** mode — hides tabs and shows Previous/Next buttons instead; bullets indicate current tab and highlight tabs with missing required fields
- **Detached tabs** — tabs can be placed vertically to the side of the tab set

##### 2.2.3.1 Set Selected Tab in a Tab Set
You can set the default selected tab in the tab set configuration.

To link directly to a specific tab, use the URL query string:

```
sTab=[id_of_the_tab]
```

Find the tab ID by editing the tab set. Example:

```
sTab=tab_032606594444807735
```

#### 2.2.4 Rich Text
Add your own rich text to the form — for instructions to the user. This text is **not** saved to the list.

#### 2.2.5 HTML
Add custom HTML to the form. Combine with Custom JS and Custom CSS to create your own form elements.

#### 2.2.6 Grid
Creates a grid layout where you can add rows and columns.

#### 2.2.7 Fields
You can select from all built-in SharePoint field types. Fields must first be created in the default list settings before they can be added to the form. A button to open list settings is available in the Miscellaneous tab.

##### 2.2.7.1 Tooltips
Configure tooltips for fields via the hamburger icon (or right-click) → **Tooltips**.

##### 2.2.7.2 Render a Lookup Field as a Tree View
Open field properties and toggle **Render as tree view** to Yes.

Requirements:
- A field that links child items to their parent (e.g., a field named **Parent** holding the Title of the parent item)
- Optionally, a Boolean field that determines whether each item is selectable

The parent field must be empty on root-level items. Child items must have a value matching the Title of their parent item.

##### 2.2.7.3 Create Cascading Lookups
Make lookup fields cascading using the **Filter** option in field properties. Click the filter field and use **Add dynamic content** (bottom right) to pick the field to use as the filter. The filter updates when that field changes.

**Example — Country and Region cascading lookups:**

**Step 1:** Create a `Country` list with only a Title field.

**Step 2:** Create a `Region` list with a lookup column pointing to the Title field of the `Country` list. The region name goes in the Title field.

**Step 3:** In your main list, create two lookup columns — one for Country, one for Region.

**Step 4:** In Modern DFFS configuration, set the filter on the Region lookup column:

```
Country eq '[[fieldValue:Country.LookupId]]'
```

The filter value `[[fieldValue:Country.LookupId]]` is inserted using the **Add dynamic content** menu when you focus on the filter textarea.

Your Region column will then show only the regions matching the selected Country.

##### 2.2.7.4 vLookup
Displays a table view of items from a child list. Configure by selecting the web, list, and filter to retrieve the desired items.

You can:
- Select which fields populate the table
- Configure **Add new** to create a new child item that is automatically linked to the current item by prefilling values from the current item

**Linking parent and child forms using `_DFFSID` or `_vLookupID`:**

If you add a field named `_DFFSID` to your list, it will be automatically populated with an auto-generated id (a timestamp in milliseconds). Use the **Prefill field values** functionality to transfer this to a single line of text field in the child list.

Use in the filter like this:

```
ParentId eq '[[fieldValue:_DFFSID]]'
```

Where `ParentId` is the field in the child list. **Remember:** you must write the `_DFFSID` value to the child items when creating new — set this up in the **Add new item** tab's Prefill field values section.

For backwards compatibility with older Classic DFFS lists, you can use the `_vLookupID` field instead.

**Add a callback function when vLookup table is ready:**

```javascript
function dffs_vLookup_callback(id, items){
  if(id === "vLookup_7943515991751215"){
    // Loaded vLookup with id vLookup_7943515991751215
    console.log(id, items);
  }
}
```

**Override configuration for a vLookup in Custom JS:**

```javascript
var vLookup_config_override = {};
if (getFieldValue("DocLibSelect") === "DocLibA") {
  vLookup_config_override["vLookup_13389631338251728"] = {
    "list": {
      "override": "DocLibA",
      "guid": "f31dfde0-3299-4415-80fd-64806cf091bc",
      "title": "DocLibA",
      "rootfolder": "DocLibA",
      "BaseTemplate": 101
    }
  };
} else {
  vLookup_config_override["vLookup_13389631338251728"] = {
    "list": {
      "override": "DocLibB",
      "guid": "91c5e295-ccdd-4855-8419-06ec284c0c22",
      "title": "DocLibB",
      "rootfolder": "DocLibB",
      "BaseTemplate": 101
    }
  };
}
```

> **Note:** You must add all properties in the override object — you cannot override only a subset (e.g., only `guid`). Export the configuration and parse the `FormJSON` property to find the complete vLookup configuration object.

**Refresh a vLookup table from Custom JS:**

```javascript
vLookup_loadItems("vLookup_06588267196671516").then(() => {
  console.log("done");
});
```

**Open a vLookup form from Custom JS:**

```javascript
// Open NewForm
vlookup_open("vLookup_06588267196671516", "new");

// Open DispForm or EditForm (requires item ID)
vlookup_open("vLookup_06588267196671516", "disp", 123);
vlookup_open("vLookup_06588267196671516", "edit", 123);
```

##### 2.2.7.5 Render a Single Line of Text Field as a Dropdown
Open field properties and toggle **Render field as dropdown** to Yes.

Configure:
- Display name or GUID of the source list
- Internal name of the field to use as selectable options
- Placeholder text
- REST filter to subset the data source
- Sort order
- **Autofill if the dropdown only has one option**

**Pipe-separated options:** If your options are stored in a multiline text field in `Red|Green|Yellow|Blue` format, check this box. Note: enabling this disables the **Set field value** functionality.

**Set field value:** If using a single line of text field, you can populate additional fields from the source list. To pull from a complex field type (people picker or lookup):

```
FieldInternalName/Title
```

##### 2.2.7.6 Render a Single Line or Multi Line of Text Field as an Autocomplete
Open field properties and toggle **Render field as autocomplete search box** to Yes.

Configure:
- Display name or GUID of the source list
- Internal name of the field to show/search
- Additional search fields (comma-separated; these values won't appear in the selection list)
- Placeholder text
- REST filter
- Sort order

Make autocompletes cascading using the **REST filter** — use **Add dynamic content** to pick the upstream field value.

**Set field value:** Same as dropdown — use `FieldInternalName/Title` to pull from complex field types.

##### 2.2.7.7 Cascading Dropdowns / Autocompletes

**Example — three-level cascade (State → City → Suburbs):**

Source list `state_city` with columns: Title (State), field_1 (City), field_2 (Suburb).

In your target list, create: `State` (single-line text), `City` (single-line text), `Suburbs` (multiline plain text).

**First level — State:**

| Setting | Value |
|---|---|
| Source list | `state_city` |
| Field to show | `Title` |
| Placeholder | `--- select state ---` |
| REST filter | *(empty)* |

**Second level — City:**

| Setting | Value |
|---|---|
| Source list | `state_city` |
| Field to show | `field_1` |
| Placeholder | `--- select city ---` |
| REST filter | `Title eq '[[fieldValue:State]]'` |

**Third level — Suburbs (multiselect autocomplete):**

| Setting | Value |
|---|---|
| Source list | `state_city` |
| Field to show | `field_2` |
| Placeholder | `--- select state and city before selecting suburbs ---` |
| REST filter | `field_1 eq '[[fieldValue:City]]'` |

The multiline `Suburbs` field allows multiple selections.

##### 2.2.7.8 Render a Single Line of Text Field Using a Custom Render Function [Advanced]
Open field properties, check **Use a custom render function**, and provide the function name (e.g., `myTxtFieldRenderFn`).

In the Custom JS tab, add a function with that name. Example — a dropdown with two options:

```javascript
function myTxtFieldRenderFn(f) {
  let options = [
    { "val": "Option 1", "text": "Option one" },
    { "val": "Option 2", "text": "Option two" }
  ];
  let currFieldValue = getFieldValue(f.InternalName);
  let b = [];
  b.push("<select onchange='changeCustomDropdown(\"" + f.InternalName + "\", this)' style='padding: 6px 10px'>");
  b.push("<option value=''>---</option>");
  options.forEach(opt => {
    b.push("<option value='" + opt.val + "'" + (currFieldValue === opt.val ? " selected=true'" : "") + ">" + opt.text + "</option>");
  });
  b.push("</select>");
  return b.join("");
}

function changeCustomDropdown(fin, elm) {
  var value = elm.value;
  setFieldValue(fin, value);
}
```

---

### 2.3 Preview Form
You can preview the form configuration from within the configurator. Some fields render as read-only, and lookup columns rendered as tree views will show dummy content.

> **Note:** Rules are not evaluated in preview mode. Open the form in a new tab outside the configurator for full functionality.

---

### 2.4 Rules

Create rules to make your form dynamic. Combine triggers using **and / or** logic.

**Field-based trigger operators:**

| Operator | Operator |
|---|---|
| is equal to | is not equal to |
| contains | does not contain |
| is greater than | is greater than or equal to |
| is less than | is less than or equal to |
| starts with | does not start with |
| ends with | does not end with |
| is changed | is changed from initial value |
| is empty | is not empty |

**Additional triggers:**
- Form loaded
- Before saving the form
- After saving the form
- Using a mobile device
- SharePoint group
- Selected tab
- Current form
- URL query string value
- Run based on the result of another rule
- Run based on the result of a Custom JS function (on form load)
- Run from a Custom JS function

**Actions (configurable for If Yes and If No):**
- Required / Optional fields
- Visible / Hidden fields
- Editable / Readonly fields
- Show / Hide elements
- Show / Hide form buttons
- Call a function
- Set field value
- Prepare / Remove email
- Show / Hide tabs
- Select tab
- vLookup readonly / editable
- vLookup required / optional
- Show a message box
- Show a field message
- Remove a field message

#### 2.4.1 Run Based on the Result of a Custom JS Function (on Form Load)

```javascript
function checkFromRule(ruleId) {
  let result = false;
  // Add your custom logic here
  // Set result to true or false to trigger the If Yes or If No section
  return result;
}
```

#### 2.4.2 Run from a Custom JS Function

```javascript
dffs_triggerRule("43796707680074887", true);
```

The second argument is a Boolean selecting the If Yes (`true`) or If No (`false`) actions.

> **Note:** Only rules configured with the trigger **"Run from a Custom JS function"** can be triggered this way.

---

### 2.5 Custom JS
Load external `.js` files or add Custom JS directly in the editor.

Code examples: https://spjsblog.com/forums/topic/custom-js-examples/

---

### 2.6 Custom CSS
Add Custom CSS to style your custom HTML sections or override any default form styling.

Load external CSS files:

```css
@import "/path_to_file/filename.css";
```

> **Note:** An auto-generated suffix is added to all default classes. To override a class like `formLabel`, write the selector as:
> ```css
> div[class^='formLabel_']
> ```

---

### 2.7 Miscellaneous

#### 2.7.1 Password
Set a password to protect your configuration from others.

#### 2.7.2 Override Strings Used in DFFS
Use this to override individual UI strings in DFFS. A link below the textarea shows all available strings.

#### 2.7.3 Form Panel Type *(vLookup child forms only)*
Choose from:
- Full width
- Large
- Medium
- Small

#### 2.7.4 Show Panel Type Menu in the Form *(vLookup child forms only)*
Shows a form panel-width selector within the form.

#### 2.7.5 Currency Symbol Position for Currency Fields
Place the currency symbol left or right on currency fields.

#### 2.7.6 Comments
Check **Show comments button** to display a comment button in the top right corner of DispForm and EditForm, using the out-of-the-box SharePoint comment functionality.

#### 2.7.7 Use Jodit Editor
Toggle on to use a more advanced rich text editor for rich text fields.

#### 2.7.8 Show an Icon to the Left of the Field Label
Toggle on to show an icon to the left of field labels.

#### 2.7.9 Show Option to Quick-Save the Form Without Closing It
Toggle on to show a quick-save button.

> **Note:** Emails and rules triggered before or after saving are only processed on manual save-and-close, not on auto-save or quick-save.

#### 2.7.10 Show Button to Turn On Automatic Saving in the Footer of the Form
Toggle on to show an auto-save toggle at the bottom of the form.

> **Note:** Same limitation as quick-save — before/after-save rules and emails do not fire on auto-save.

#### 2.7.11 Tab Colors
Set default colors for tab sets added to the form.

#### 2.7.12 Load the Configuration from Another Site or from a File
Lets you load the configuration from another site in your tenant, or from a file. Useful when multiple sites are created from a template and you want to manage form configurations centrally.

To apply this globally for all lists in a site, manually add an item to the configuration list (see Section 1.1 for access instructions):

- **Title:** `LoadAllConfigsFromOtherSite`
- **Misc:** The fully qualified URL of the site where configurations are stored (URL to the site, not the list)

Example:
```
https://contoso.com/sites/your_site
```

---

### 2.8 Note to Self
Internal notes tab to help you track your progress while building the form.

---

### 2.9 Install DFFS
Use this tab to activate DFFS as the form renderer for this list or library.

---

## 3 Printing a DFFS Form

Because of how the DFFS form is rendered, the browser's default print functionality does not work fully. To print properly, add a button to your form using an HTML section with code like this:

```html
<div style="text-align:right">
  <span style="font-size:3em;cursor:pointer;" onclick="dffs_print()">&#128438;</span>
</div>
```

If the icon doesn't display, replace `&#128438;` with an image tag using your preferred print icon.

---

## 4 Sending Emails Using FLOW

Microsoft has deprecated the SendEmail API. When configuring an email in a rule action, select **Send email using: Power Automate FLOW**.

When you first select this option on a site, a new custom list named **ModernDFFSEmail** will appear in Site contents. All emails are written to this list and sent via a Power Automate FLOW that you must create manually.

Two FLOW patterns are provided:
- **Send now** — when `SendDate` is empty
- **Send later** — when `SendDate` contains a date

> **Note:** The Send date field in the email configuration is only visible when using the **Power Automate FLOW** send option.

---

### 4.1 FLOW Configuration for Send Now

This is an **Automated cloud flow** that triggers when a new item is added to the `ModernDFFSEmail` list.

**Flow steps:**

1. **Trigger:** When an item is created in `ModernDFFSEmail`
2. **Condition:** Only if `SendDate` is empty (`SendDate` is equal to `null`)
   - **True branch:**
     1. **Send an email (V2)**
        - To: `To` field
        - Subject: `Subject` field
        - Body: Use the fx button to replace linefeeds with `<br>`:
          ```
          replace(triggerBody()?['Body'],decodeUriComponent('%0A'), '<br>')
          ```
        - CC: `Cc` field
        - BCC: `Bcc` field
     2. **Delete item** from `ModernDFFSEmail` (to prevent list throttling)
   - **False branch:** 0 Actions

---

### 4.2 FLOW Configuration for Send Later

This is a **Scheduled cloud flow** that runs every hour, checking the `ModernDFFSEmail` list for items where `SendDate` matches the current hour.

> ⚠️ **Note:** Uses UTC time. The email Send date field must be in UTC.

**Flow steps:**

1. **Recurrence:** Every 1 hour

2. **Initialize variable — ThisHourStart:**
   ```
   formatDateTime(utcNow(),'yyyy-MM-ddTHH:00:00')
   ```

3. **Initialize variable — ThisHourEnd:**
   ```
   formatDateTime(utcNow(),'yyyy-MM-ddTHH:59:59')
   ```

4. **Get items** from `ModernDFFSEmail`:
   - Filter Query:
     ```
     Active eq 1 and SendDate le datetime'[ThisHourEnd]' and SendDate ge datetime'[ThisHourStart]'
     ```

5. **Loop over items** (body/value)

6. **Check if item exists** — Send an HTTP request to SharePoint (GET):
   - URI: `_api/web/lists/getById('[ListGuid]')/items?$filter=Id eq [ListItemId]`
   - `ListGuid`: `item()?['ListGuid']`
   - `ListItemId`: `item()?['ListItemId']`

7. **Condition — Found item:**
   - Expression: `length(body('Check_if_item_exists').d.results)` is greater than `0`
   - **True branch:**
     - **Send an email (V2)** — same field mapping as Send now; use fx for body linefeeds:
       ```
       replace(item()?['Body'],decodeUriComponent('%0A'), '<br>')
       ```
   - **False branch:** 0 Actions

8. **Delete item** from `ModernDFFSEmail`

---

## 5 DFFS Configuration WebPart

Because Microsoft has issues showing banner buttons associated with a list view command set, a separate **DFFS Configuration WebPart** is available. Add it to a modern site page by searching for `dffs` in the web part picker.

The web part lists all lists and libraries in the current site. When a list is selected, it verifies that the user has **Manage lists** permissions before proceeding.

---

## 6 Modern DFFS Formpage Web Part

> Requires Modern DFFS solution **v1.0.14.0** or later.

This web part displays a Modern DFFS form on a site page. Useful for showing a new item form, or letting users edit a list item via a link in an email.

**URL parameters required:**

| Parameter | Description |
|---|---|
| `DFFSList` | GUID of the target list |
| `DFFSForm` | Form type: `new`, `disp`, or `edit` |
| `DFFSID` | Item ID (required for `disp` and `edit`) |
| `Source` | URL to redirect to after save or cancel (optional) |

Add the web part by searching for `dffs` in the web part picker and selecting **Modern DFFS Formpage**.

> **Note:** This formpage cannot currently be used when adding/viewing/editing from a list view — only via a custom-constructed link.

---

### 6.1 Setting a Default Redirect in the Form URL

Use the `DFFSSource` URL parameter to set a default redirect:

```
https://[site]/SitePages/DFFSForm.aspx?DFFSList={list_guid}&DFFSForm=new&DFFSSource=/the_url_to_redirect_to
```

This can be overridden in Custom JS using `dffs_PostSaveAction` or `dffs_PostCancelAction`.

---

## 7 Upgrade from Classic DFFS

Use **Import / Export** to open the Import, export and restore configurations panel.

- If Classic DFFS is on the same site: browse the list of configurations and import directly.
- If Classic DFFS is on a different site: export from Classic DFFS, then import into Modern DFFS, one form at a time.

> ⚠️ **Important limitations:**
> - **Custom JS and Custom CSS are not imported** — the two versions use completely different technologies. Code using `spjs.dffs` or `spjs.utility` namespaces must be rewritten using the REST API.
> - **Tabs and rules are imported**, but rule configuration differences mean you must manually review all rules after import.
> - You must **manually uninstall the Classic DFFS version** from the list before configuring it with Modern DFFS to avoid conflicts.

Custom JS function examples for Modern DFFS: https://spjsblog.com/forums/topic/custom-js-examples/

---

## 8 Troubleshooting

### 8.1 Blocked Web Resources

Behind a company firewall, some resources may be blocked.

| Resource | Purpose |
|---|---|
| `cdn.jsdelivr.net` | Monaco editor (used in Custom JS and Custom CSS tabs) |
| `https://spjs.blob.core.windows.net` | License validation (Azure CDN) — **must be unblocked** |

### 8.2 Other Blocked Resources

Firewall rules vary by company. If Modern DFFS fails to load, use browser developer tools to check the **Console** and **Network** tabs for errors.

For support: https://spjsworks.com/support