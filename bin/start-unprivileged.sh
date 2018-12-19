#!/bin/bash
set -x

EXECUTABLE=/opt/axe/bin/axed
DIR=$HOME/.axecore
FILENAME=axe.conf
FILE=$DIR/$FILENAME

# create directory and config file if it does not exist yet
if [ ! -e "$FILE" ]; then
    mkdir -p $DIR

    echo "Creating $FILENAME"

    # Seed a random password for JSON RPC server
    cat <<EOF > $FILE
printtoconsole=${PRINTTOCONSOLE:-1}
rpcbind=127.0.0.1
rpcallowip=10.0.0.0/8
rpcallowip=172.16.0.0/12
rpcallowip=192.168.0.0/16
server=1
rpcuser=${RPCUSER:-axerpc}
rpcpassword=${RPCPASSWORD:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}
EOF

fi

cat $FILE
ls -lah $DIR/

echo "Initialization completed successfully"

exec $EXECUTABLE
