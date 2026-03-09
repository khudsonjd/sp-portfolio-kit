### Step 4: Configure the mDFFS Forms

Use the `Manage-DFFSConfiguration.ps1` script to copy or write form configurations to the `DFFSConfigurationList` on your target site:

```powershell
.\scripts\Manage-DFFSConfiguration.ps1
```

The script supports:
- **Copy** — copy a New, Edit, or Display form configuration from one list to another
- **Write from JSON** — write a configuration from a JSON file (coming soon)

> ⚠️ **Manual step required after every configuration write or copy:**
> Copying a configuration into `DFFSConfigurationList` does not automatically activate mDFFS on the target list forms. You must enable it manually for each form type (New, Edit, Display) as follows:
>
> 1. Navigate to the target list in SharePoint
> 2. Click the **DFFS** button in the list toolbar
> 3. Select the form type (New / Edit / Display) from the dropdown
> 4. Click the **Install DFFS** tab
> 5. Toggle the button **ON** for each content type row
> 6. Click **Save**
> 7. Repeat for each form type
>
> There is no known programmatic method to perform this step.