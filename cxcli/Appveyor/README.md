# CxAppVeyor ![Checkmarx](images/checkmarx.png) ![AppVeyor](images/appveyor.png)

## Checkmarx AppVeyor Integration via YML (CLI)

It is possible to run a Checkmarx Scan using the YML file of AppVeyor (https://www.appveyor.com/) and take advantage of Checkmarx CLI as well.

## Custom Environment Varibles

First you need to configure the AppVeyor Environment Variables, as you can see below:

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

## AppVeyor Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| APPVEYOR_PROJECT_NAME | Project Name  |
| APPVEYOR_REPO_BRANCH | Branch Name |
| APPVEYOR_BUILD_FOLDER | Build Folder Path  |
| APPVEYOR_REPO_COMMIT | Commit SHA1 Hash  |

To use a environment variable you need to call it like this in YML:

%ENV_VAR% 

## YML Config

Then, please add to your repository source code a file called **"appveyor.yml"** with following configuration for Checkmarx Scan:

```yml
version: 1.0.{build}
os: Visual Studio 2015
before_build:
- cmd: appveyor DownloadFile https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip -FileName cxcli.zip
- cmd: unzip cxcli.zip -d cxcli
- cmd: rm -rf cxcli.zip
- cmd: chmod +x cxcli/runCxConsole.cmd
build_script:
- cmd: cxcli/runCxConsole.cmd Scan -CxServer %CX_SERVER% -CxUser %CX_USER% -CxPassword %CX_PASSWORD% -ProjectName "%CX_TEAM%\%APPVEYOR_PROJECT_NAME%-%APPVEYOR_REPO_BRANCH%" -preset "%CX_PRESET%" -LocationType folder -LocationPath %APPVEYOR_BUILD_FOLDER% -SASTHigh %CX_HIGH% -SASTMedium %CX_MEDIUM% -SASTLow %CX_LOW% -ReportXML %APPVEYOR_BUILD_FOLDER%/results.xml -ReportPDF %APPVEYOR_BUILD_FOLDER%/results.pdf -Comment "git %APPVEYOR_REPO_BRANCH%@%APPVEYOR_REPO_COMMIT%" -verbose
artifacts:
  - path: results.pdf
    name: results.pdf
  - path: results.xml
    name: results.xml
```