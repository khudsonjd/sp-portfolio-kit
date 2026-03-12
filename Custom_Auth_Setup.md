# Configuring Custom Enterprise App Authentication for PnP PowerShell

If your enterprise tenant restricts or has deleted the default multi-tenant "PnP Management Shell" application (App ID `31359c7f-bd7e-475c-86db-fdb8c937548e`), you will receive `AADSTS700016` errors when attempting to use `-Interactive` login.

To maintain a secure, enterprise-approved authentication flow, you must register a **custom application** specifically for this portfolio tooling. 

## Step 1: Register the Application

The fastest and most reliable way to register a custom PnP app is to use the automated script provided by the PnP PowerShell team.

1. Open a new PowerShell window as an Administrator.
2. Run the following command:
   ```powershell
   Register-PnPAzureADApp -ApplicationName "Portfolio Review Automation" -Tenant "groovepoint.onmicrosoft.com" -Interactive
   ```
3. A browser window will open. Log in with your Tenant Administrator credentials.
4. You will be prompted to grant consent to this *new* application for your tenant. Accept the permissions.

## Step 2: Update Your Scripts

The `Register-PnPAzureADApp` command will output a new **Client ID** (a GUID) to your console. 

1. Copy that new Client ID.
2. In your `Automate-SiteReview.ps1`, `Manage-DFFSConfiguration.ps1`, and `Create-TAPCatalogList.ps1` scripts, you must now use `-Interactive` but pass your custom Client ID instead of relying on the default one. 
3. The connection strings should look like this:

```powershell
Connect-PnPOnline -Url $siteUrl -Interactive -ClientId "YOUR-NEW-CLIENT-ID-HERE"
```

Because you created and consented to this specific app in *your* tenant, Entra ID will allow the interactive login to proceed seamlessly.
