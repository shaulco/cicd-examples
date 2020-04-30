# CxGithubActions ![Checkmarx](images/checkmarx.png) <img src="images/github.png" alt="Github" width="40" height="40">

## Checkmarx Github Actions Integration via YML (CLI)

It is possible to run a Checkmarx Scan using the YML file of Github Actions (https://github.com/features/actions) and take advantage of CLI as well.

## Custom Environment Varibles

First you need to configure the Github Actions Environment Variables, as you can see below:

| Variable Name  | Variable Value (Example) |
| ------------- | ------------- |
| CX_SERVER | https://checkmarx.company.com  |
| CX_USER | admin@cx  |
| CX_TEAM | \CxServer\SP\Company\TeamA  |
| CX_PRESET | Checkmarx Default  |
| CX_HIGH | 0 |
| CX_MEDIUM | 0 |
| CX_LOW | 0 |

Configure the Password in Secrets section (Repo → Settings → Secrets → Add New Secret): 

| Secret Name  | Variable Value (Example) |
| ------------- | ------------- |
| CX_PASSWORD | ******** (secured)  |

## Github Actions Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| GITHUB_REPOSITORY | Project Name  |
| GITHUB_REF | Branch Name |
| GITHUB_WORKSPACE | Source Code Folder Path |
| GITHUB_SHA | Commit SHA1 Hash  |

To use a environment variable you need to call it like this in YML:

$ENV_VAR

## Config

Then, please add to your repository source code a file called **".github/workflows/cx-cli-scan.yml"** with following configuration for Checkmarx Scan:

```yml
name: Checkmarx SAST Scan

on:
  push:
    branches: 
      - master
jobs:
  checkmarx-cli-san:
    name: Run Checkmarx CLI Scan
    runs-on: ubuntu-latest
    steps:
    - name: Download CxCLI Zip
      run: wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
    - name: Unzip CxCLI Zip
      run: unzip ~/cxcli.zip -d ~/cxcli
    - name: Make CxCLI executable
      run: chmod +x ~/cxcli/runCxConsole.sh
      
    - uses: actions/checkout@v1
    - name: Run Checkmarx Scan
      run: |
        export CX_PROJECT_NAME=$(basename "$GITHUB_REPOSITORY")
        export BRANCH=$(basename "$GITHUB_REF")
        ~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName "$CX_TEAM\\$CX_PROJECT_NAME-$BRANCH" -preset "$CX_PRESET" -LocationType folder -LocationPath $GITHUB_WORKSPACE -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML $GITHUB_WORKSPACE/results.xml -ReportPDF $GITHUB_WORKSPACE/results.pdf -Comment "git $BRANCH@$GITHUB_SHA" -verbose
      env:
        CX_SERVER: https://test.checkmarx.net
        CX_TEAM: \CxServer\SP\EMEA\__psteam
        CX_PRESET: Checkmarx Default
        CX_USER: test@company.com
        CX_PASSWORD: ${{ secrets.CX_PASSWORD }}
        CX_HIGH: 0
        CX_MEDIUM: 0
        CX_LOW: 0
    - name: Upload PDF Artifact
      uses: actions/upload-artifact@master
      with:
        name: results.pdf
        path: results.pdf
    - name: Upload XML Artifact
      uses: actions/upload-artifact@master
      with:
        name: results.xml
        path: results.xml

```
PDF and XML Artifacts will be uploaded and attached to the execution of the build
