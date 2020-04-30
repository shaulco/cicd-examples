# CxTravisCI ![Checkmarx](images/checkmarx.png) <img src="images/travis.png" alt="Travis" width="40" height="40">

## Checkmarx Travis CI Integration via YML (CLI)

It is possible to run a Checkmarx Scan using the YML file of Travis CI (https://travis-ci.com/) and take advantage of CLI as well.

## Custom Environment Varibles

First you need to configure the Travis CI Environment Variables, as you can see below:

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

## Travis CI Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| PWD | Project Name  |
| TRAVIS_BRANCH | Branch Name |
| TRAVIS_BUILD_DIR | Source Code Folder Path |
| TRAVIS_COMMIT | Commit SHA1 Hash  |

To use a environment variable you need to call it like this in YML:

$ENV_VAR

## Config

Then, please add to your repository source code a file called **".travis.yml"** with following configuration for Checkmarx Scan:

```yml
matrix:
include:
- language: java
env:
  global:
    - PROJECT_NAME=$(basename "$PWD")
install:
- wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
- unzip ~/cxcli.zip -d ~/cxcli
- chmod +x ~/cxcli/runCxConsole.sh
script:
- ~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName "$CX_TEAM\\$PROJECT_NAME-$TRAVIS_BRANCH" -preset "$CX_PRESET" -LocationType folder -LocationPath $TRAVIS_BUILD_DIR -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML $TRAVIS_BUILD_DIR/results-PROJECT_NAME-$TRAVIS_BRANCH.xml -ReportPDF $TRAVIS_BUILD_DIR/results-$PROJECT_NAME-$TRAVIS_BRANCH.pdf -Comment "git $TRAVIS_BRANCH@$TRAVIS_COMMIT" -verbose
addons:
  artifacts:
    paths:
    - results-$PROJECT_NAME-$TRAVIS_BRANCH.pdf
    - results-$PROJECT_NAME-$TRAVIS_BRANCH.xml
```
