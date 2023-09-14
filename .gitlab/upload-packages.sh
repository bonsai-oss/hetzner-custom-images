#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
trap 'echo "ERROR: ${BASH_SOURCE[0]} at about line ${LINENO}" >&2' ERR

for image in output/*.tar.gz; do
  echo "Uploading ${image}..."

  curl "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/${IMAGE}/$(date +%s)/$(basename ${image})" \
    --header "JOB-TOKEN: $CI_JOB_TOKEN" \
    --upload-file "${image}" \
    --silent
done
