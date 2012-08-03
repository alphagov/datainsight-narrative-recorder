#!/usr/bin/env bash

set -e

ANSI_YELLOW="\033[33m"
ANSI_RED="\033[31m"
ANSI_RESET="\033[0m"

export VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "USAGE: release.sh <version-hash>"
  exit 1
fi

#HOST="deploy@datainsight"
HOST="deploy@datainsight.alphagov.co.uk"

scp datainsight-recorder-narrative-$VERSION.zip $HOST:/srv/datainsight-recorder-narrative/packages
# deploy
echo -e "${ANSI_YELLOW}Deploying package${ANSI_RESET}"
ssh $HOST "mkdir /srv/datainsight-recorder-narrative/release/$VERSION; unzip -o /srv/datainsight-recorder-narrative/packages/datainsight-recorder-narrative-$VERSION.zip -d /srv/datainsight-recorder-narrative/release/$VERSION;"
# link
echo -e "${ANSI_YELLOW}Linking package${ANSI_RESET}"
ssh $HOST "rm /srv/datainsight-recorder-narrative/current; ln -s /srv/datainsight-recorder-narrative/release/$VERSION/ /srv/datainsight-recorder-narrative/current;"
# restart
echo -e "${ANSI_YELLOW}Restarting service${ANSI_RESET}"
ssh $HOST "sudo service datainsight-recorder-narrative restart"
