# Master Inventory List Setup Guide

The `Automate-SiteReview.ps1` script requires a source of truth for all SharePoint sites in your enterprise. It reads this master list, connects to each site URL it finds, and performs a DFFS/mDFFS discovery scan.

If you do not already have a definitive "Site Directory" or "Master Inventory" list in your SharePoint environment, you must create one before running the automation script.

## Minimal Requirements

Create a Custom List (e.g., `MasterSharePointInventory`) on your Portfolio management site with the following structure:

| Column Display Name | Internal Name | Column Type | Required | Description |
|---|---|---|---|---|
| **Title** | `Title` | Single line of text | Yes | The name of the site. |
| **Site URL** | `SiteURL` | Hyperlink or Picture (format as Hyperlink) OR Single line of text | Yes | The absolute URL to the root of the site collection. |

## Important Notes

1. **Parameter Flexibility:** The script expects the URL column's internal name to be `SiteURL` by default. If your enterprise uses a different column name (like `URL` or `Link`), you can pass the `-InventoryUrlField` parameter when running the script:
   ```powershell
   .\scripts\Automate-SiteReview.ps1 -InventoryUrlField "YourCustomColumnName"
   ```
2. **Data Types:** The script gracefully handles the URL column whether it was configured as a standard "Single line of text" column or a "Hyperlink or Picture" column.
3. **PnP Sessions:** The list must reside on a site where your running account has minimum Read access. The script will use your interactive login to read this list, then re-authenticate silently to each target site in the inventory.
