#!/bin/sh
cat >docker-compose.yaml <<EOF
version: "2"
services:
EOF
cp docker-compose.yaml docker-compose.err.yaml
for DOCKERFILE in Dockerfile.*; do
  TAG=${DOCKERFILE#Dockerfile.}
  case $DOCKERFILE in
  *.err) COMPOSEFILE=docker-compose.err.yaml ;;
  *)     COMPOSEFILE=docker-compose.yaml     ;;
  esac
  cat >>$COMPOSEFILE <<EOF
  $TAG:
    image: minimage:$TAG
    build:
      context: .
      dockerfile: $DOCKERFILE
EOF
done
