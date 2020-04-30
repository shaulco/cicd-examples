# CxBitriseCI ![Checkmarx](images/checkmarx.png) ![Bitrise](images/bitrise.png)

## Checkmarx Bitrise Integration via Bash Script (CLI)

It is possible to run a Checkmarx Scan using a bash script in Bitrise CI (https://app.bitrise.io/) and take advantage of CLI as well.

After you add/configure the Application in Bitrise CI, you need to edit the Workflow.

## Custom Environment Varibles

For both it is required to configure Environment Variables for the Workflow, such as:

| Variable Name  | Variable Value (Example) |
| ------------- | ------------- |
| CX_SERVER | https://checkmarx.company.com  |
| CX_USER | admin@cx  |
| CX_TEAM | \CxServer\SP\Company\TeamA  |
| CX_PRESET | Checkmarx Default  |
| CX_HIGH | 0 |
| CX_MEDIUM | 0 |
| CX_LOW | 0 |

And where the Cx Password should be placed in Secret section for the Workflow, such as:

| Secret Env. Variable Name  | Variable Value (Example) |
| ------------- | ------------- |
| CX_PASSWORD | ******** (secured)  |

## Bitrise Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| BITRISE_APP_TITLE | Project Name  |
| BITRISE_GIT_BRANCH | Branch Name |
| BITRISE_SOURCE_DIR | Build Folder Path  |
| BITRISE_GIT_COMMIT | Commit SHA1 Hash  |

To use a environment variable you need to call it like this in Bash Script:

$ENV_VAR

## Config

In the Workflow you can use one of 2 Steps, such as:

Script Runner - where you only need to specify the path to the Bash Script for executing Checkmarx Scan, requiring the file exists in the source code

```bash
#!/bin/sh

set -e	# exit on first failed command
wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
unzip ~/cxcli.zip -d ~/cxcli
rm -rf ~/cxcli.zip
chmod +x ~/cxcli/runCxConsole.sh
~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName "$CX_TEAM\\$BITRISE_APP_TITLE-$BITRISE_GIT_BRANCH" -preset "$CX_PRESET" -LocationType folder -LocationPath $BITRISE_SOURCE_DIR -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML results-$BITRISE_APP_TITLE-$BITRISE_GIT_BRANCH.xml -ReportPDF results-$BITRISE_APP_TITLE-$BITRISE_GIT_BRANCH.pdf -Comment "git $BITRISE_GIT_BRANCH@$BITRISE_GIT_COMMIT" -verbose
```