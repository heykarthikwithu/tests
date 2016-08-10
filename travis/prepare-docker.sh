#!/bin/bash

# Run this script in your .travis.yml file to upgrade docker.

DOCKER_VERSION=1.11.2-0~trusty
DOCKER_COMPOSE_VERSION=1.7.1

apt-cache madison docker-engine

apt-get -o Dpkg::Options::="--force-confnew" install -y docker-engine=${DOCKER_VERSION}

# reinstall docker-compose at specific version
rm /usr/local/bin/docker-compose
curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
chmod +x docker-compose
mv docker-compose /usr/local/bin
docker --version
docker-compose --version

# Prepare local docker container
echo "Preparing local aegir container for UID $USER_UID"

# Get Dockerfile
wget https://raw.githubusercontent.com/aegir-project/dockerfiles/master/Dockerfile

# Run Docker build
docker build --build-arg AEGIR_UID=$USER_UID --build-arg AEGIR_GID=$USER_UID -t aegir/hostmaster:local .
