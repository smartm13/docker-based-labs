#!/bin/bash

USERS_HOME=/users/home
base_image=mlflow_based:latest

# Make sure Base-Image exists
[ -n "$(docker images -q $base_image)" ] || docker build -t $base_image --build-arg http_proxy=http://genproxy.amdocs.com:8080/ --build-arg https_proxy=http://genproxy.amdocs.com:8080/ --build-arg HTTP_PROXY=http://genproxy.amdocs.com:8080/ --build-arg HTTPS_PROXY=http://genproxy.amdocs.com:8080/ .


for S_USER in $(find $USERS_HOME -mindepth 1 -maxdepth 1 -type d) ; do
    S_USER=${S_USER##*/}
    echo S_USER=$S_USER
    docker run -d -v $USERS_HOME/$S_USER:/root/ --network=host --name env_$S_USER --restart=always $base_image 2>/dev/null || true
done

# MAKE SURE DOCKER-SSH IMAGE EXISTS
[ -n "$(docker images -q docker-ssh:latest)" ] || http_proxy=http://genproxy:8080 https_proxy=http://genproxy:8080 docker build -t docker-ssh --build-arg http_proxy=http://genproxy.amdocs.com:8080/ --build-arg https_proxy=http://genproxy.amdocs.com:8080/ --build-arg HTTP_PROXY=http://genproxy.amdocs.com:8080/ --build-arg HTTPS_PROXY=http://genproxy.amdocs.com:8080/ github.com/smartm13/docker-ssh#patch-1

docker rm -f docker_env_ssh || true
docker run -d -p 22:22 -p 8022:8022 --name docker_env_ssh \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e AUTH_MECHANISM=multiContainerAuthLDAP \
  -e org_domain=MYORGG.com \
  docker-ssh

