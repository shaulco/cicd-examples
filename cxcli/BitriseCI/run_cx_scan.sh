#!/bin/sh

set -e	# exit on first failed command
wget -O ~/cxcli.zip https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.0.zip
unzip ~/cxcli.zip -d ~/cxcli
rm -rf ~/cxcli.zip
chmod +x ~/cxcli/runCxConsole.sh
~/cxcli/runCxConsole.sh Scan -CxServer $CX_SERVER -CxUser $CX_USER -CxPassword $CX_PASSWORD -ProjectName "$CX_TEAM\\$BITRISE_APP_TITLE-$BITRISE_GIT_BRANCH" -preset "$CX_PRESET" -LocationType folder -LocationPath $BITRISE_SOURCE_DIR -SASTHigh $CX_HIGH -SASTMedium $CX_MEDIUM -SASTLow $CX_LOW -ReportXML results-$BITRISE_APP_TITLE-$BITRISE_GIT_BRANCH.xml -ReportPDF results-$BITRISE_APP_TITLE-$BITRISE_GIT_BRANCH.pdf -Comment "git $BITRISE_GIT_BRANCH@$BITRISE_GIT_COMMIT" -verbose