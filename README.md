tmoreira2020/docker-backup-postgres-to-s3
======================

Docker container that periodically backups Postgres (9.6.1) dumps to Amazon S3 using [s3cmd sync](http://s3tools.org/s3cmd-sync) and cron.

### Usage

    docker run -d [OPTIONS] tmoreira2020/docker-backup-postgres-to-s3

### Parameters:

* `-e ACCESS_KEY=<AWS_KEY>`: Your AWS key.
* `-e SECRET_KEY=<AWS_SECRET>`: Your AWS secret.
* `-e PG_USER=<POSTGRES_USER>`: Postgres user with admin privilegies to dump databases
* `-e PG_PASSWORD=<POSTGRES_PASSWORD>`: Postgres user's password
* `-e S3_PATH=s3://<BUCKET_NAME>/<PATH>`: S3 Bucket name and path. Should NOT end with trailing slash.

### Optional parameters:

* `-e PARAMS="--dry-run"`: parameters to pass to the sync command ([full list here](http://s3tools.org/usage)).
* `-e 'CRON_SCHEDULE=0 1 * * *'`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)). Default is `0 1 * * *` (runs every day at 1:00 am).
* `no-cron`: run container once and exit (no cron scheduling).

### Examples:

Run upload to S3 everyday at 12:00pm:

    docker run -d \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e PG_USER=myuser \
        -e PG_PASSWORD=mypassword \
        -e S3_PATH=s3://my-bucket/backup \
        -e 'CRON_SCHEDULE=0 12 * * *' \
        tmoreira2020/docker-backup-postgres-to-s3

Run once then delete the container:

    docker run --rm \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e PG_USER=myuser \
        -e PG_PASSWORD=mypassword \
        -e S3_PATH=s3://my-bucket/backup \
        tmoreira2020/docker-backup-postgres-to-s3 no-cron

Run once to delete from s3 then delete the container:

    docker run --rm \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e PG_USER=myuser \
        -e PG_PASSWORD=mypassword \
        -e S3_PATH=s3://my-bucket/backup \
        tmoreira2020/docker-backup-postgres-to-s3 delete
