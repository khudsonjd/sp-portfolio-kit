# Version & Checkpoint Conventions

## Version Numbering

**Format:** `vddMMMyy.x.z`

| Component | Description | Example |
|---|---|---|
| `v` | Literal prefix, means "version" | v |
| `dd` | 2-digit day, with leading zero | 02 |
| `MMM` | 3-character month abbreviation | Mar |
| `yy` | 2-digit year | 26 |
| `x` | Major version number | 3 |
| `z` | Minor version number | 0 |

**Full example:** `v02Mar26.3.0`

### Version Bump Rules

- **Major bump (x):** Significant new features, structural changes, or breaking changes. Reset z to 0. Example: adding persistence, adding a new screen.
- **Minor bump (z):** Small tweaks, cosmetic changes, bug fixes. Example: text changes, color adjustments, minor UI fixes.

### Where the Version Appears

**Flutter/Dart projects:**
1. As a comment on the first line of the main code file:
```dart
// v02Mar26.3.0
```
2. As a constant in the code, displayed unobtrusively in the UI (e.g. small text at the bottom of the screen):
```dart
const kVersion = 'v02Mar26.3.0';
```

**PowerShell scripts:**
1. As a comment on the first line of the script:
```powershell
# v08Mar26.1.4
```
There is no UI equivalent for PowerShell scripts.

---

## Checkpoint System

### Purpose

Checkpoints are stable, tested snapshots of a code file. They allow rollback to any previously working version if a new version fails testing.

### Folder Structure

Create a `checkpoints/` subfolder inside the project or scripts folder:

**Flutter/Dart projects:**
```
my_project/
  lib/
    main.dart
  checkpoints/
    cp001_v02Mar26.2.0.dart
    cp002_v02Mar26.3.0.dart
```

**PowerShell projects:**
```
scripts/
  Create-TAPCCatalogList.ps1
  checkpoints/
    cp001_Create-TAPCCatalogList_v08Mar26.1.4.ps1
```

### Checkpoint File Naming

**Flutter/Dart:** `cpNNN_vddMMMyy.x.z.dart`

| Component | Description | Example |
|---|---|---|
| `cp` | Literal prefix, means "checkpoint" | cp |
| `NNN` | 3-digit sequential number, starting at 001 | 001 |
| `_` | Separator | _ |
| `vddMMMyy.x.z` | Full version number of the snapshot | v02Mar26.3.0 |
| `.dart` | File extension | .dart |

**Full example:** `cp002_v02Mar26.3.0.dart`

---

**PowerShell:** `cpNNN_ScriptName_vddMMMyy.x.z.ps1`

| Component | Description | Example |
|---|---|---|
| `cp` | Literal prefix, means "checkpoint" | cp |
| `NNN` | 3-digit sequential number, starting at 001 | 001 |
| `_` | Separator | _ |
| `ScriptName` | Name of the script without extension | Create-TAPCCatalogList |
| `_` | Separator | _ |
| `vddMMMyy.x.z` | Full version number of the snapshot | v08Mar26.1.4 |
| `.ps1` | File extension | .ps1 |

**Full example:** `cp001_Create-TAPCCatalogList_v08Mar26.1.4.ps1`

The `cp` prefix and 3-digit number ensure checkpoint files sort alphabetically = chronologically in any file explorer or IDE, regardless of script name.

---

### When to Create a Checkpoint

Create a checkpoint after each version that passes real-world testing on the target device or environment. Do not checkpoint untested code.

### How to Create a Checkpoint

1. Confirm the version has passed testing
2. Copy the main code file
3. Paste it into the `checkpoints/` folder
4. Rename it using the checkpoint naming convention above

### How to Roll Back

1. Open the desired checkpoint file in the `checkpoints/` folder
2. Copy all its contents
3. Paste into the main code file, replacing all existing content
4. Save and redeploy

### Checkpoint Log

Maintain a checkpoint log in the project plan or README:

| # | Version | Date | Notes |
|---|---|---|---|
| cp001 | v02Mar26.2.0 | 02 Mar 2026 | Example: persistence added |
| cp002 | v02Mar26.3.0 | 02 Mar 2026 | Example: inline editing added |

---

*These conventions were designed for small solo projects with infrequent releases. For larger team projects, consider a full Git branching strategy instead.*