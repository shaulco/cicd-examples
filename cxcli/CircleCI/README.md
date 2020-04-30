# CxCircleCI ![Checkmarx](images/checkmarx.png) <img src="images/circleci.png" alt="Circle CI" width="40" height="40">

## Checkmarx Circle CI Integration via YML (CLI)

It is possible to run a Checkmarx Scan using the YML file of Circle CI (https://circleci.com/) and take advantage of CLI as well.

## Custom Environment Varibles

First you need to configure the Circle CI Environment Variables, as you can see below:

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

## Circle CI Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| CIRCLE_PROJECT_REPONAME | Project Name  |
| CIRCLE_BRANCH | Branch Name |
| CIRCLE_SHA1 | Commit SHA1 Hash  |

To use a environment variable you need to call it like this in YML:

${ENV_VAR}

## Config

Then, please add to your repository source code a file called **".circleci/config.yml"** with following configuration for Checkmarx Scan:

```yml
version: 2
jobs:
  build:
    docker:
      - image: circleci/openjdk:8-jdk
    steps:
      - checkout

      - run:
          name: Install CxCLI Plugin
          command: |
            wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
            unzip ~/cxcli.zip -d ~/cxcli
            chmod +x ~/cxcli/runCxConsole.sh
      - run:
          name: Execute CxSAST Scan
          command: |
            ~/cxcli/runCxConsole.sh Scan -CxServer "${CX_SERVER}" -CxUser "${CX_USER}" -CxPassword "${CX_PASSWORD}" -ProjectName "${CX_TEAM}\\${CIRCLE_PROJECT_REPONAME}-${CIRCLE_BRANCH}" -preset "${CX_PRESET}" -LocationType folder -LocationPath ~/ -SASTHigh ${CX_HIGH} -SASTMedium ${CX_MEDIUM} -SASTLow ${CX_LOW} -Comment "git ${CIRCLE_BRANCH}@${CIRCLE_SHA1}" -verbose
```