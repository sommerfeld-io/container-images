#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

## Use nftables backend for iptables to ensure Docker networking works on Ubuntu 26.04+
## <https://github.com/orgs/sommerfeld-io/projects/1/views/1?pane=issue&itemId=184218287>
sudo update-alternatives --set iptables /usr/sbin/iptables-nft
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-nft

## Restart the docker-in-docker containerd with umask 0022. The docker-in-docker feature starts it
## via sudo, so it inherits the hardened `UMASK 027` from /etc/login.defs of sommerfeldio/devcontainer
## and unpacks every image layer with a root directory of mode 0750. Containers running as a non-root
## user then fail to open any file (e.g. nginx: "can't open '/docker-entrypoint.sh': Permission denied").
SNAPSHOTS_DIR="/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots"
CONTAINERD_PID="$(pgrep -xo containerd || true)"
if [ -n "$CONTAINERD_PID" ] && ! grep -q '^Umask:[[:space:]]*0022$' "/proc/$CONTAINERD_PID/status"; then
  echo "[INFO] Restarting containerd with umask 0022"
  CONTAINERD_CMD="$(tr '\0' ' ' <"/proc/$CONTAINERD_PID/cmdline")"
  sudo kill "$CONTAINERD_PID"
  while kill -0 "$CONTAINERD_PID" 2>/dev/null; do sleep 0.1; done
  sudo sh -c "umask 0022 && nohup $CONTAINERD_CMD >/tmp/containerd.log 2>&1 &"
  until docker info >/dev/null 2>&1; do sleep 0.5; done

  # Layers unpacked so far keep their 0750 root directory
  sudo find "$SNAPSHOTS_DIR" -mindepth 2 -maxdepth 2 -name fs -type d -perm 0750 -exec chmod 0755 {} +
fi

task cleanup:update
task symlinks
task info
