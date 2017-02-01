#!/bin/bash

set -e

: ${ACCESS_KEY:?"ACCESS_KEY env variable is required"}
: ${SECRET_KEY:?"SECRET_KEY env variable is required"}
: ${PG_USER:?"PG_USER env variable is required"}
: ${PG_PASSWORD:?"PG_PASSWORD env variable is required"}
: ${S3_PATH:?"S3_PATH env variable is required"}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

echo "access_key=$ACCESS_KEY" >> /root/.s3cfg
echo "secret_key=$SECRET_KEY" >> /root/.s3cfg

if [[ "$1" == 'no-cron' ]]; then
    exec /sync.sh
elif [[ "$1" == 'delete' ]]; then
    exec /usr/local/bin/s3cmd del -r "$S3_PATH"
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV="PARAMS='$PARAMS'"
    CRON_ENV="$CRON_ENV\nPGPASSWORD='$PG_PASSWORD'"
    CRON_ENV="$CRON_ENV\nPGUSER='$PG_USER'"
    CRON_ENV="$CRON_ENV\nS3_PATH='$S3_PATH'"
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /sync.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
fi
