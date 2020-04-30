# CxAWSCodeBuild ![Checkmarx](images/checkmarx.png) ![AWS Code Build](images/awscodebuild.png)

## Checkmarx AWS CodeBuild Integration via YML (CLI)

It is possible to run a Checkmarx Scan using a bash script in AWS CodeBuild (https://aws.amazon.com/codebuild/) and take advantage of CLI as well.

## Custom Environment Varibles

First you need to configure Create a Build Project with following details (for example):

 - Project Name: CxCodeBuild
 - Source Provider: Code Commit
 - Repository: CxCodeCommit (for example)
 - Branch: master (for example)
 - Operating System: Ubuntu (for example)
 - Runtime: Standard
 - Image: aws/codebuild/standard:3.0
 - Additional Configurations:
    - Environment Variables:

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

- Buildspec: Use a buildspec file
- Create build Project

## AWS Code Build Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| CODEBUILD_SOURCE_REPO_URL | Repo URL |
| CODEBUILD_SOURCE_VERSION | Branch Name |
| CODEBUILD_SRC_DIR | Source Code Folder Path |
| CODEBUILD_RESOLVED_SOURCE_VERSION | Commit SHA1 Hash |

To use a environment variable you need to call it like this in YML:

$ENV_VAR 

## YML Config

Then, to your CodeCommit or Github Project or other Repository add a file called **“buildspec.yml”** with following code:

```yml
version: 0.2 
 
phases: 
  install: 
    runtime-versions: 
      java: openjdk11 
  post_build: 
    commands: 
      - wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip 
      - unzip ~/cxcli.zip -d ~/cxcli 
      - rm -rf ~/cxcli.zip 
      - chmod +x ~/cxcli/runCxConsole.sh 
      - export CX_PROJECT_NAME=$(basename "$CODEBUILD_SOURCE_REPO_URL") 
      - export CX_PROJECT_BRANCH=$(basename "$CODEBUILD_SOURCE_VERSION") 
      - ~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName "$CX_TEAM\\$CX_PROJECT_NAME-$CX_PROJECT_BRANCH" -preset "$CX_PRESET" -LocationType folder -LocationPath $CODEBUILD_SRC_DIR -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML results-$CX_PROJECT_NAME-$CX_PROJECT_BRANCH.xml -ReportPDF results-$CX_PROJECT_NAME-$CX_PROJECT_BRANCH.pdf -Comment "git $CX_PROJECT_BRANCH@$CODEBUILD_RESOLVED_SOURCE_VERSION" -verbose
```