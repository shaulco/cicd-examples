#!/bin/sh

set -e	# exit on first failed command
export CX_PROJECT_NAME=$(basename "$NEVERCODE_REPO_SLUG")
wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
unzip ~/cxcli.zip -d ~/cxcli
rm -rf ~/cxcli.zip
chmod +x ~/cxcli/runCxConsole.sh
~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName "$CX_TEAM\\$CX_PROJECT_NAME-$NEVERCODE_BRANCH" -preset "$CX_PRESET" -LocationType folder -LocationPath $NEVERCODE_BUILD_DIR -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML results-$CX_PROJECT_NAME-$NEVERCODE_BRANCH.xml -ReportPDF results-$CX_PROJECT_NAME-$NEVERCODE_BRANCH.pdf -Comment "git $NEVERCODE_BRANCH@$NEVERCODE_COMMIT" -verbose