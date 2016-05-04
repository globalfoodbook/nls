#!/bin/bash

set -e
set -x

export PATH=$GOPATH/bin:/usr/local/go/bin:/usr/local/bin:/usr/lib/postgresql/$POSTGRES_VERSION/bin/:$PATH

if [ -d "$PROJECT_DIR" ]; then

  if [ -f "/go/bin/$PROJECT_NAME" ]; then
    rm -rf /go/bin/$PROJECT_NAME
  fi

  cd $PROJECT_DIR && go get github.com/tools/godep && godep restore && go install

  echo -e "**** Start nutrition facts label service api ***"
  /go/bin/$PROJECT_NAME &
  echo -e "**** Start and loading data to postgres db ***"
  # Reusing entrypoint from nls-pg
  /etc/init.d/entrypoint.sh

fi
