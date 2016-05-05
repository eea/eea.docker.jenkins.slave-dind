FROM eeacms/jenkins-slave:2.1
MAINTAINER "EEA: IDM2 A-Team" <eea-edw-a-team-alerts@googlegroups.com>

ENV DOCKER_VERSION=1.8.2 \
    DOCKER_COMPOSE_VERSION=1.6.2 \
    DOCKER_COMPOSE_MD5=9f56f13032b04645009aa2b3fcd889bd

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
 && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
 && echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends docker-engine=$DOCKER_VERSION* \
 && rm -rf /var/lib/apt/lists/* \
 && curl -o /bin/docker-compose -SL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 \
 && echo "$DOCKER_COMPOSE_MD5  /bin/docker-compose" | md5sum -c - \
 && chmod +x /bin/docker-compose

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "/tmp/get-pip.py" \
 && python /tmp/get-pip.py \
 && pip install j2cli
COPY ini/settings.xml.j2 /tmp/settings.xml.j2

USER jenkins

COPY docker-entrypoint-dind.sh /

ENTRYPOINT ["/docker-entrypoint-dind.sh"]
