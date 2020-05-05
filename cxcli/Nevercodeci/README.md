# CxNevercodeCI ![Checkmarx](images/checkmarx.png) <img src="images/nevercode.png" alt="Nevercode" width="40" height="40">

## Checkmarx Nevercode CI Integration via Bash Script (CLI)

It is possible to run a Checkmarx Scan using a bash script in Nevercode CI (https://app.nevercode.io/) and take advantage of CLI as well.

## Custom Environment Varibles

First you need to configure the Nevercode CI Environment Variables, as you can see below:

| Variable Name  | Variable Value (Example) |
| ------------- | ------------- |
| CX_SERVER | https://checkmarx.company.com  |
| CX_USER | admin@cx  |
| CX_PASSWORD | ******** (secured)  |
| CX_TEAM | \CxServer\SP\Company\TeamA  |
| CX_PRESET | Checkmarx Default  |
| CX_HIGH | 0 |
| CX_MEDIUM | 0 |
| CX_LOW | 0 |

## Nevercode CI Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| NEVERCODE_REPO_SLUG | Project Name  |
| NEVERCODE_BRANCH | Branch Name |
| NEVERCODE_BUILD_DIR | Source Code Folder Path |
| NEVERCODE_COMMIT | Commit SHA1 Hash  |

To use a environment variable you need to call it like this in Bash Script:

$ENV_VAR

## Config

Then, please add to the section Environment Files a Bash script associated to the variable name “NC_POST_CLONE_SCRIPT” with following configuration for Checkmarx Scan:

```bash
#!/bin/sh

set -e	# exit on first failed command
export CX_PROJECT_NAME=$(basename "$NEVERCODE_REPO_SLUG")
wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
unzip ~/cxcli.zip -d ~/cxcli
rm -rf ~/cxcli.zip
chmod +x ~/cxcli/runCxConsole.sh
~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName "$CX_TEAM\\$CX_PROJECT_NAME-$NEVERCODE_BRANCH" -preset "$CX_PRESET" -LocationType folder -LocationPath $NEVERCODE_BUILD_DIR -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML results-$CX_PROJECT_NAME-$NEVERCODE_BRANCH.xml -ReportPDF results-$CX_PROJECT_NAME-$NEVERCODE_BRANCH.pdf -Comment "git $NEVERCODE_BRANCH@$NEVERCODE_COMMIT" -verbose
```
