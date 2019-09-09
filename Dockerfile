FROM ubuntu:18.04
RUN apt-get update && \
 apt-get install  -y software-properties-common && \
 add-apt-repository ppa:deadsnakes/ppa && \
 apt-get update && \
 apt-get install -y  python3.6 \
                        openjdk-8-jdk \
                        wget \
                        curl \
                        git \
                        swig \
                        python3-pip \
                        libgpgme-dev \
                        python3-gpg 

RUN cd /tmp && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.deb && \
    dpkg -i elasticsearch-6.3.2.deb
RUN cd /tmp && \
    wget -c http://download.redis.io/redis-stable.tar.gz && \
    tar xvzf redis-stable.tar.gz
WORKDIR "/tmp/redis-stable"

RUN cd deps &&\
    make hiredis jemalloc linenoise lua geohash-int && \
    cd .. && \
    make & make install && \
    ./utils/install_server.sh && \
    sed -i 's/databases 16/databases 32/g' /etc/redis/6379.conf && \
    rm -rf /var/run/* && \
    pip3 install pipenv
ENTRYPOINT service elasticsearch start && service redis_6379 start && bash

