FROM postgres:9.6.1
MAINTAINER Thiago Leão Moreira <tmoreira2020@gmail.com>

RUN apt-get update && \
    apt-get install -y python python-pip cron && \
    rm -rf /var/lib/apt/lists/*

RUN pip install s3cmd

ADD s3cfg /root/.s3cfg

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD sync.sh /sync.sh
RUN chmod +x /sync.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
