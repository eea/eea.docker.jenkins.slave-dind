# Jenkins Slave with Docker Engine and Docker Compose inside  (Jenkins Swarm Plugin)

Docker images for Jenkins Slave with Docker Engine and Docker Compose inside.

This image is generic, thus you can obviously re-use it within your non-related EEA projects.

## Supported tags and respective Dockerfile links

- [`:latest`  (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave-dind/blob/master/Dockerfile)
- [`:1.10` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave-dind/blob/1.10/Dockerfile)
- [`:1.9` (*Dockerfile*)](https://github.com/eea/eea.docker.jenkins.slave-dind/blob/1.9/Dockerfile)

## Changes

- [CHANGELOG.md](https://github.com/eea/eea.docker.jenkins.slave-dind/blob/master/CHANGELOG.md)

## Base docker image

- [hub.docker.com](https://registry.hub.docker.com/u/eeacms/jenkins-slave-dind)

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

    $ docker run --name=docker19 \
                 --privileged=true \
             docker:1.9-dind

Start Jenkins slave:

    $ docker run --name=worker \
                 --link=docker19 \
                 -e DOCKER_HOST=tcp://dind:2375 \
             eeacms/jenkins-slave-dind:1.9

See base image [eeacms/jenkins-slave](https://hub.docker.com/r/eeacms/jenkins-slave) for more options.

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
