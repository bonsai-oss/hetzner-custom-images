#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
trap 'echo "ERROR: ${BASH_SOURCE[0]} at about line ${LINENO}" >&2' ERR

for image in output/*.tar.gz; do
  echo "Uploading ${image}..."
  rclone copy ${image} remote:hetzner-images/${CI_COMMIT_REF_SLUG}/ --progress --stats-one-line --stats 5s --stats-log-level NOTICE
done
