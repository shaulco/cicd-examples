# CxWercker ![Checkmarx](images/checkmarx.png) <img src="images/wercker.png" alt="Wercker" width="40" height="40">

## Checkmarx Wercker CI Integration via YML (CLI)

It is possible to run a Checkmarx Scan using the YML file of Wercker CI (https://app.wercker.com/) and take advantage of CLI as well.
 
## Custom Environment Varibles

First you need to configure the Wercker CI Environment Variables, as you can see below:

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

## Wercker CI Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| WERCKER_GIT_REPOSITORY | Project Name  |
| WERCKER_GIT_BRANCH | Branch Name |
| WERCKER_SOURCE_DIR | Source Code Folder Path |
| WERCKER_GIT_COMMIT | Commit SHA1 Hash  |

To use a environment variable you need to call it like this in YML:

$ENV_VAR

## Config

Then, please add to your repository source code a file called **".wercker.yml"** with following configuration for Checkmarx Scan:

```yml
box: openjdk:8-jdk
build:
  steps:
    - script:
      name: Download CxCLI
      code: |
        wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
        unzip ~/cxcli.zip -d ~/cxcli
        rm -rf ~/cxcli.zip
        chmod +x ~/cxcli/runCxConsole.sh
    - script:
      name: Run Checkmarx Scan
      code: |
        ~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName "$CX_TEAM\\$WERCKER_GIT_REPOSITORY-$WERCKER_GIT_BRANCH" -preset "$CX_PRESET" -LocationType folder -LocationPath $WERCKER_SOURCE_DIR -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML results-$WERCKER_GIT_REPOSITORY-$WERCKER_GIT_BRANCH.xml -ReportPDF results-$WERCKER_GIT_REPOSITORY-$WERCKER_GIT_BRANCH.pdf -Comment "git $WERCKER_GIT_BRANCH@$WERCKER_GIT_COMMIT" -verbose
```
