#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
docker run \
  -e BAIR_GOOGLE_DRIVE_CLIENT_ID=$BAIR_GOOGLE_DRIVE_CLIENT_ID \
  -e BAIR_GOOGLE_DRIVE_CLIENT_SECRET=$BAIR_GOOGLE_DRIVE_CLIENT_SECRET \
  -e CLOUDINARY_CLOUD_NAME=$CLOUDINARY_CLOUD_NAME \
  -e CLOUDINARY_API_KEY=$CLOUDINARY_API_KEY \
  -e CLOUDINARY_API_SECRET=$CLOUDINARY_API_SECRET \
  -e HOME=/root \
  -v $DIR:/root \
  -ti dementrock/bair-builder ${1-/bin/bash} "${@:2}"
