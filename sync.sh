#!/bin/bash

set -e

echo "Job started: $(date)"

backuptime=`date "+%Y%m%d%H%M"`
backupfolder=/tmp/$backuptime
backupdumpfile=/tmp/$backuptime/dump-$backuptime.sql

mkdir -p $backupfolder

/usr/bin/pg_dump -h db -U "$PGUSER" -f "$backupdumpfile"

gzip "$backupdumpfile"

/usr/local/bin/s3cmd put $backupdumpfile.gz $S3_PATH/$backuptime/dump-$backuptime.sql.gz

echo -n $backuptime > /tmp/LATEST
/usr/local/bin/s3cmd put --acl-public --mime-type="text/plain" --force /tmp/LATEST $S3_PATH/LATEST

rm -rf $backupfolder

echo "Job finished: $(date)"
