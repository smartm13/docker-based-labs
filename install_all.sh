#!/bin/bash

USERS_HOME=/users/home
base_image=mlflow_based:latest

# Make sure Base-Image exists
[ -n "$(docker images -q $base_image)" ] || docker build -t $base_image .


for S_USER in $(find $USERS_HOME -mindepth 1 -maxdepth 1 -type d) ; do
    S_USER=${S_USER##*/}
    echo S_USER=$S_USER
    docker run -d -v $USERS_HOME/$S_USER:/root/ --network=host --name env_$S_USER --restart=always $base_image 2>/dev/null || true
done

# MAKE SURE DOCKER-SSH IMAGE EXISTS
[ -n "$(docker images -q docker-ssh:latest)" ] || docker build -t docker-ssh  github.com/smartm13/docker-ssh#patch-1

# docker rm -f docker_env_ssh || true
docker run -d -p 22:22 -p 8022:8022 --name docker_env_ssh \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e AUTH_MECHANISM=multiContainerAuthLDAP \
  -e org_domain=MYORGG.com \
  docker-ssh || true

## ADDITIONAL MLFLOW_TRACKING SERVER
mkdir -p $USERS_HOME/admin/mlflow || true
docker run -d --restart=always --name mlflow_tracking_central_server -p 5000:5000 -v $USERS_HOME/admin/mlflow:/mlflow --workdir /mlflow --entrypoint mlflow $base_image \
server --backend-store-uri sqlite:////mlflow/mlflow.db --default-artifact-root /mlflow/artifacts --host 0.0.0.0 --port 5000 || true
