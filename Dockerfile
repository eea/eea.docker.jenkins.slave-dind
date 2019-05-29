FROM eeacms/jenkins-slave:3.15

ENV DOCKER_VERSION=17.12.1 \
    DOCKER_COMPOSE_VERSION=1.24.0 \
    DOCKER_COMPOSE_MD5=df94d0cee88e15ab28fb95b0b2204f99 \
    CLAIR_SCANNER_VERSION=v8

RUN apt-get update \
 && apt-get install -y --no-install-recommends apt-transport-https ca-certificates software-properties-common acl \
 && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
 && apt-get update \
 && apt-get install -y --no-install-recommends docker-ce=$DOCKER_VERSION* \
 && rm -rf /var/lib/apt/lists/* \
 && curl -o /bin/docker-compose -SL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 \
 && echo "$DOCKER_COMPOSE_MD5  /bin/docker-compose" | md5sum -c - \
 && chmod +x /bin/docker-compose \
 && curl "https://bootstrap.pypa.io/get-pip.py" -o "/tmp/get-pip.py" \
 && python /tmp/get-pip.py \
 && pip install j2cli virtualenv \
 && curl -L -o /usr/bin/clair-scanner https://github.com/arminc/clair-scanner/releases/download/$CLAIR_SCANNER_VERSION/clair-scanner_linux_amd64 \
 && chmod 777 /usr/bin/clair-scanner

COPY ini/settings.xml.j2 /tmp/settings.xml.j2
COPY scripts/scan_catalog_entry.sh docker-entrypoint-dind.sh /

ENTRYPOINT ["/docker-entrypoint-dind.sh"]
CMD ["java", "-jar", "/bin/swarm-client.jar"]
