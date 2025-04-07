#!/bin/bash
## Sample Usage
##
## ```bash
## ./inspec.sh vendor devcontainer
## ./inspec.sh check devcontainer
## ./inspec.sh exec devcontainer local/devcontainer:dev
## ```

set -o errexit
set -o pipefail
# set -o nounset
# set -o xtrace

readonly INSPEC_IMAGE="chef/inspec:5.22.76"

if [ -z "$1" ]; then
  echo "[ERROR] Command missing (vendor | check | exec)"
  echo "[ERROR] Exited with code 1"
  exit 1
fi

case "$1" in
"vendor")
  echo "[INFO] ---- Vendor ----------------------------"

  if [ -z "$2" ]; then
    echo "[ERROR] Inspec profile name missing"
    echo "[ERROR] Exited with code 2"
    exit 2
  fi

  echo "[INFO] Running command with profile: $2"
  docker run --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    "$INSPEC_IMAGE" vendor "$2" --overwrite --chef-license=accept
  ;;

"check")
  echo "[INFO] ---- Check -----------------------------"

  if [ -z "$2" ]; then
    echo "[ERROR] Inspec profile name missing"
    echo "[ERROR] Exited with code 2"
    exit 2
  fi

  echo "[INFO] Running command with profile: $2"
  docker run --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    "$INSPEC_IMAGE" check "$2" --chef-license=accept
  ;;

"exec")
  echo "[INFO] ---- Exec ------------------------------"

  if [ -z "$2" ]; then
    echo "[ERROR] Inspec profile name missing"
    echo "[ERROR] Exited with code 2"
    exit 2
  fi

  if [ -z "$3" ]; then
    echo "[ERROR] Docker image name missing"
    echo "[ERROR] Provide a real Docker image name from a local or remote registry"
    echo "[ERROR] Exited with code 3"
    exit 3
  fi

  echo "[INFO] Start system under test ($3)"
  system_under_test=$(docker run -d -v "$(pwd):$(pwd):ro" -w "$(pwd)" "$3" sleep 180s)
  echo "$system_under_test"
  sleep 5s

  echo "[INFO] Running command with profile: $2"
  echo "[INFO] Running command for image: $3"
  docker run --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    "$INSPEC_IMAGE" exec "$2" --target "docker://$system_under_test" --no-distinct-exit --chef-license=accept

  echo "[INFO] Stop and remove system under test ($3)"
  sleep 5s
  docker stop "$system_under_test"
  docker rm "$system_under_test"
  ;;

*)
  echo "[ERROR] Provide valid command (vendor | check | exec)"
  echo "[ERROR] Exited with code 4"
  exit 4
  ;;
esac
