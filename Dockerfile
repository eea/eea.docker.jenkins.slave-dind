FROM eeacms/jenkins-slave:3.49

ENV DOCKER_VERSION=5:28.1.1 \
    DOCKER_COMPOSE_VERSION=v2.36.1 \
    DOCKER_COMPOSE_MD5=578d96985b66af0aa5cce8abb25c79ad \
    RANCHER_CLI_VERSION=v0.6.14 \
    KUBE_VERSION=1.21.14 \
    HELM_VERSION=3.6.3 

RUN apt-get update \
 && apt-get install -y --no-install-recommends gpg-agent apt-transport-https ca-certificates software-properties-common acl \
 && install -m 0755 -d /etc/apt/keyrings \
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
 && chmod a+r /etc/apt/keyrings/docker.asc \
 # Add the repository to Apt sources:
 && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null \
 && apt-get update \
 && apt-get install -y --no-install-recommends docker-ce=$DOCKER_VERSION* \
 && rm -rf /var/lib/apt/lists/* \
 && curl -o /bin/docker-compose -SL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 \
 && echo "$DOCKER_COMPOSE_MD5  /bin/docker-compose" | md5sum -c - \
 && chmod +x /bin/docker-compose \
 && pip install j2cli \
 && curl -L -o rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz https://releases.rancher.com/cli/${RANCHER_CLI_VERSION}/rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz \
 && tar -xzvf rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz  \
 && mv rancher-${RANCHER_CLI_VERSION}/rancher /usr/bin/rancher \
 && rm -rf rancher-* \
 && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
 && chmod +x /usr/local/bin/helm \
 && helm repo add "stable" "https://charts.helm.sh/stable" --force-update 
    
    

COPY ini/settings.xml.j2 /tmp/settings.xml.j2
COPY scripts/scan_catalog_entry.sh docker-entrypoint-dind.sh /

ENTRYPOINT ["/docker-entrypoint-dind.sh"]
CMD ["java", "-jar", "/bin/swarm-client.jar"]
