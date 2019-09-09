FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y  python3.6 \
                        openjdk-8-jdk \
                        wget \
                        curl \
                        git \
                        swig \
                        python3-pip \
                        libgpgme-dev \
                        python3.6-gpg
RUN cd /tmp && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.deb && \
    dpkg -i elasticsearch-6.3.2.deb
RUN wget -c http://download.redis.io/redis-stable.tar.gz && \
    tar xvzf redis-stable.tar.gz && \
    cd redis-stable && \
    make & make install && \
    utils/install_server.sh
ENTRYPOINT service elasticsearch start && service redis_6379 start && bash

