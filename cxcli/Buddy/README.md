# CxBuddy ![Checkmarx](images/checkmarx.png) <img src="images/buddy.png" alt="Buddy" width="40" height="40">

## Checkmarx Buddy Integration via YML (CLI)

It is possible to run a Checkmarx Scan using the YML file of Buddy (https://buddy.works/) and take advantage of CLI as well.

## Custom Environment Varibles

First you need to configure the Buddy Environment Variables, as you can see below:

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

## Buddy Default Environment Variables Used

| Variable Name  | Description |
| ------------- | ------------- |
| BUDDY_PROJECT_NAME | Project Name  |
| BUDDY_EXECUTION_BRANCH | Branch Name |
| BUDDY_EXECUTION_ID | Commit SHA1 Hash  |

To use a environment variable you need to call it like this in YML:

$ENV_VAR

## Config

Then, please add to your repository source code a file called **"buddy.yml"** with following configuration for Checkmarx Scan:

```yml
- pipeline: "Checkmarx Scan"
  trigger_mode: "ON_EVERY_PUSH"
  ref_name: "master"
  ref_type: "BRANCH"
  trigger_condition: "ALWAYS"
  actions:
  - action: "Run Checkmarx Scan"
    type: "BUILD"
    working_directory: "/buddy/cxbuddy"
    docker_image_name: "library/java"
    docker_image_tag: "latest"
    execute_commands:
    - "~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName \"$CX_TEAM\\\\$BUDDY_PROJECT_NAME-$BUDDY_EXECUTION_BRANCH\" -preset \"$CX_PRESET\" -LocationType folder -LocationPath /buddy/cxbuddy -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML /buddy/cxbuddy/results-$BUDDY_PROJECT_NAME-$BUDDY_EXECUTION_BRANCH.xml -ReportPDF /buddy/cxbuddy/results-$BUDDY_PROJECT_NAME-$BUDDY_EXECUTION_BRANCH.pdf -Comment \"git $BUDDY_EXECUTION_BRANCH@$BUDDY_EXECUTION_ID\" -verbose"
    setup_commands:
    - "wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip"
    - "unzip ~/cxcli.zip -d ~/cxcli"
    - "rm -rf cxcli.zip"
    - "chmod +x ~/cxcli/runCxConsole.sh"
    mount_filesystem_path: "/buddy/cxbuddy"
    shell: "BASH"
    trigger_condition: "ALWAYS"
```