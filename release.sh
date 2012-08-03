#!/usr/bin/env bash

set -e

export VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "USAGE: release.sh <version-hash>"
  exit 1
fi

#HOST="deploy@datainsight"
HOST="deploy@datainsight.alphagov.co.uk"

scp datainsight-recorder-narrative-$VERSION.zip $HOST:/srv/datainsight-recorder-narrative/packages
# deploy
ssh $HOST "mkdir /srv/datainsight-recorder-narrative/release/$VERSION; unzip -o /srv/datainsight-recorder-narrative/packages/datainsight-recorder-narrative-$VERSION.zip -d /srv/datainsight-recorder-narrative/release/$VERSION;"
# link
ssh $HOST "rm /srv/datainsight-recorder-narrative/current; ln -s /srv/datainsight-recorder-narrative/release/$VERSION/ /srv/datainsight-recorder-narrative/current;"
# restart
ssh $HOST "sudo service datainsight-recorder-narrative restart"
