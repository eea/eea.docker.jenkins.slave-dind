# Jenkins Slave with Docker Engine and Docker Compose inside (Jenkins Swarm Plugin)

Docker images for Jenkins Slave with Docker Engine and Docker Compose inside.

Works best in combination with [eeacms/jenkins-master](https://hub.docker.com/r/eeacms/jenkins-master/)

This image is generic, thus you can obviously re-use it within your non-related EEA projects.

## Supported tags and respective Dockerfile links

- [`:latest`  (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave-dind/blob/master/Dockerfile)
- [`:20.10-3.39` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave/blob/20.10-3.39/Dockerfile)
- [`:20.10-3.37` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave/blob/20.10-3.37/Dockerfile)
- [`:20.10-3.30` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave/blob/20.10-3.30/Dockerfile)
- [`:20.10-3.29` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave/blob/20.10-3.29/Dockerfile)
- [`:19.03-3.27` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave/blob/19.03-3.27/Dockerfile)
- [`:19.03-3.26` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave/blob/19.03-3.26/Dockerfile)
- [`:19.03-3.26-1` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave/blob/19.03-3.26-1/Dockerfile)

See [older versions](https://github.com/eea/eea.docker.jenkins.slave-dind/releases)

## Changes

- [CHANGELOG.md](https://github.com/eea/eea.docker.jenkins.slave-dind/blob/master/CHANGELOG.md)

## Base docker image

- [hub.docker.com](https://hub.docker.com/r/eeacms/jenkins-slave-dind)

## Source code

- [github.com](http://github.com/eea/eea.docker.jenkins.slave-dind)

## Installation

1. Install [Docker](https://www.docker.com/).
2. Install [Docker Compose](https://docs.docker.com/compose/).

## Usage

Start Jenkins master:

    $ docker run --name=jenkins \
                 -p 8080:8080 \
                 -p 50000:50000 \
            eeacms/jenkins-master

Start Docker engine server:

    $ docker run --name=docker13 \
                 --privileged=true \
             docker:1.13-dind

Start Jenkins slave:

    $ docker run --name=worker \
                 --link=docker13 \
                 -e DOCKER_HOST=tcp://docker13:2375 \
             eeacms/jenkins-slave-dind:1.13


You can also bind `/var/run/docker.sock` from host for more stable Jenkins Docker-in-Docker slave:

    $ docker run --name=worker \
                 -v /var/run/docker.sock:/var/run/docker.sock \
             eeacms/jenkins-slave-dind:1.13

See base image [eeacms/jenkins-slave](https://hub.docker.com/r/eeacms/jenkins-slave) for more options.

## Clair-scanner usage

[clair-scanner](https://github.com/arminc/clair-scanner) is a docker containers vulnerability scanner. It is integrated with a standalone [Clair server](https://github.com/coreos/clair). Before scanning, you need first to pull the image locally:

    $ docker pull <IMAGE>

To use it,

    $ clair-scanner --ip <IP_VISIBLE_FROM_CLAIR> -t='High' --clair="http://<CLAIR_HOST>:<CLAIR_PORT>"  --all=false  <IMAGE>

or with a local [whitelist file](https://github.com/arminc/clair-scanner#example-whitelist-yaml-file)


    $ clair-scanner --ip <IP_VISIBLE_FROM_CLAIR> -t='High' --whitelist=<WHITELIST_FILE> --clair="http://<CLAIR_HOST>:<CLAIR_PORT>"  --all=false  <IMAGE>

### Rancher catalog scanner

/scan_catalog_entry.sh is a script that should be used to make sure that all the images from a rancher catalog don't have any Critical or higher vulnerabilities. You can give it an exclude parameter to not scan the images you plan to upgrade in the catalog. The default Clair url is http:/clair:6060. If you want to use another url, you can set it with environment variable CLAIR_URL

    $ /scan_catalog_entry.sh <CATALOG_PATH> <REGEX_TO_EXCLUDE>

Example:

    $ /scan_catalog_entry.sh templates/www-eea  "eeacms/www-devel:|eeacms/apache-eea-www:"


## Supported environment variables

* `DOCKER_HOST` Docker engine server `address:port` to be used to run Docker related jobs
* `JENKINS_USER` jenkins user to be used to connect slaves to Jenkins master. Make sure that this user has the proper rights to connect slaves and run jenkins jobs.
* `JENKINS_PASS` jenkins user password
* `JAVA_OPTS` You might need to customize the JVM running Jenkins slave, typically to pass system properties or tweak heap memory settings. Use JAVA_OPTS environment variable for this purpose.
* `JENKINS_NAME` Name of the slave
* `JENKINS_DESCRIPTION` Description to be put on the slave
* `JENKINS_EXECUTORS` Number of executors. Default is equal with the number of available CPUs
* `JENKINS_LABELS` Whitespace-separated list of labels to be assigned for this slave. Multiple options are allowed.
* `JENKINS_RETRY` Number of retries before giving up. Unlimited if not specified.
* `JENKINS_MODE` The mode controlling how Jenkins allocates jobs to slaves. Can be either 'normal' (utilize this slave as much as possible) or 'exclusive' (leave this machine for tied jobs only). Default is normal.
* `JENKINS_MASTER` The complete target Jenkins URL like 'http://jenkins-server'. If this option is specified, auto-discovery will be skipped
* `JENKINS_TUNNEL` Connect to the specified host and port, instead of connecting directly to Jenkins. Useful when connection to Hudson needs to be tunneled. Can be also HOST: or :PORT, in which case the missing portion will be auto-configured like the default behavior
* `JENKINS_TOOL_LOCATIONS` Whitespace-separated list of tool locations to be defined on this slave. A tool location is specified as 'toolName:location'
* `JENKINS_NO_RETRY_AFTER_CONNECTED` Do not retry if a successful connection gets closed.
* `JENKINS_AUTO_DISCOVERY_ADDRESS` Use this address for udp-based auto-discovery (default 255.255.255.255)
* `JENKINS_DISABLE_SSL_VERIFICATION` Disables SSL verification in the HttpClient.
* `JENKINS_OPTS` You can provide multiple parameters via this environment like: `-e JENKINS_OPTS="-labels docker -mode exclusive"`
* `DOCKERHUB_USER` dockerhub user to be used to push images to dockerhub. If missing, the .m2/settings.xml required for pushing images will not be created.
* `DOCKERHUB_PASS` dockerhub user password

## Copyright and license

The Initial Owner of the Original Code is European Environment Agency (EEA).
All Rights Reserved.

The Original Code is free software;
you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later
version.

## Funding

[European Environment Agency (EU)](http://eea.europa.eu)
