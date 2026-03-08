# SharePoint Solution Portfolio Kit
### Think Like an Enterprise Architect

## The Problem

SharePoint solutions are often built to meet urgent, unfunded, or "temporary" needs — with plans to sunset them in a few months or rebuild them properly once funding arrives. Years later, those tools are still running. Your support team is maintaining dozens or hundreds of custom solutions of uncertain value, with no systematic way to evaluate them.

## The Solution

Learn to think like an Enterprise Architect. Apply TOGAF principles to create a standardized, repeatable process for regularly reviewing your solution portfolio — informed by relevant organizational and technical context.

This project gives SharePoint developers, support technicians, and their managers an organized approach to this problem, and a way to demonstrate the value they deliver in terms senior leadership can grasp quickly.

## How This Project Was Built

Built around four core ideas:

1. **Ultra-fast learning** — Using the meta-learning principles from Timothy Ferriss's *The Four-Hour Chef* to acquire new skills in a fraction of the usual time.
2. **TOGAF without the training burden** — Quickly absorbing the TOGAF principles needed to think like an Enterprise Architect, without weeks of formal study.
3. **A living solution catalog** — Maintaining an organized portfolio with a low-friction process for solution owners to keep their metadata current, so leadership can always see which tools deliver value and which should be consolidated or retired.
4. **Thoughtful use of modern tools** — Combining AI, PowerShell, SharePoint lists, and structured AI prompts to build a portfolio review process in minimum time, and a repeatable pattern for rapid solution development that weighs ease of build, support burden, skill requirements, licensing cost, and business value.

## Design Decisions

**No required columns in SharePoint lists.** None of the lists created by scripts in this project mark any columns as required at the list level. Required field enforcement is handled through mDFFS form configuration, not the SharePoint list schema. This keeps the list flexible and avoids validation conflicts during scripted data operations.

## Installation

Follow these steps to deploy the TAPC Solution Catalog to your SharePoint environment.

### Prerequisites

- Site Collection Admin access to your target SharePoint site
- PowerShell 5.1 or PowerShell 7
- Tenant Admin access (required for the App Catalog step only)

### Step 1: Create the Catalog List

Run the following script to create the `TAPCCatalog` list with all required fields and human-readable display names:

```powershell
.\scripts\Create-TAPCCatalogList.ps1
```

The script will prompt for your SharePoint site URL and connect via browser login. It creates all six sections of the catalog (Identity, Technical Profile, Business Profile, Cost & Dependency, Disposition & Modernization, Operational Documentation) and updates all field display names automatically.

### Step 2: Add the Site Collection App Catalog

A Site Collection App Catalog is required to deploy mDFFS to your site.

1. Sign in to the SharePoint Admin Center with Tenant Admin credentials
2. Go to **Sites → Active sites** and select your target site
3. Run the following command using PnP PowerShell with Tenant Admin credentials:

```powershell
Connect-PnPOnline -Url "https://your-site-url" -UseWebLogin
Add-PnPSiteCollectionAppCatalog -Site "https://your-site-url"
```

### Step 3: Install mDFFS

mDFFS (Modern Dynamic Forms For SharePoint) is used to configure the New, Edit, and Display forms for the catalog list.

1. Download the latest `dffs.sppkg` file from **https://files.spjsworks.com/?dir=files%2FModernDFFS**
2. Unzip the downloaded file
3. Navigate to your Site Collection App Catalog at `https://your-site-url/sites/your-site/_catalogs/AppCatalog`
4. Upload `dffs.sppkg`
5. When prompted, trust and deploy the app

### Step 4: Configure the mDFFS Form

*Coming soon — form configuration instructions for the TAPCCatalog list will be documented here.*

## Assets

*Coming soon.*

## License

This project is the personal IP of the author and is made freely available for individual and organizational use.