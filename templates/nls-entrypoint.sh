#!/bin/bash

set -e
set -x

export PATH=$GOPATH/bin:/usr/local/go/bin:/usr/lib/postgresql/$POSTGRES_VERSION/bin/:$PATH
export NUT_PG_DSN="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_IP/$POSTGRES_DB?sslmode=disable"
#!/bin/bash

/etc/init.d/pg_entrypoint.sh $POSTGRES_MAIN_USER
