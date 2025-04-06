#!/bin/bash

readonly DOCKER_ORG="sommerfeldio"
readonly DOCKER_IMAGE="devcontainer"
readonly DOCKER_TAG="0.8.0"

# docker pull "$DOCKER_IMAGE/$DOCKER_IMAGE":"$DOCKER_TAG"

echo "[INFO] ---- Vendor ----------------------------"
docker run --rm -it \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  chef/inspec:5.22.76 vendor "$DOCKER_IMAGE" --overwrite --chef-license=accept

echo "[INFO] ---- Check -----------------------------"
docker run --rm -it \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  chef/inspec:5.22.76 check "$DOCKER_IMAGE" --chef-license=accept

echo "[INFO] ---- Start system under test -----------"
sleep 5s
system_under_test=$(docker run -d "$DOCKER_ORG/$DOCKER_IMAGE":"$DOCKER_TAG" tail -f /dev/null)

echo "[INFO] ---- Run profile -----------------------"
sleep 5s
docker run --rm -it \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  chef/inspec:5.22.76 exec "$DOCKER_IMAGE" --target "docker://$system_under_test" --chef-license=accept

echo "[INFO] ---- Stop system under test ------------"
sleep 5s
docker stop "$system_under_test"
docker rm "$system_under_test"
