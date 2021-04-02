#!/bin/bash

TAG=$(git describe --always)

docker tag "${DOCKER_USERNAME}/slim-php-realworld-example-app:latest" "${DOCKER_USERNAME}/slim-php-realworld-example-app:${TAG}"
docker images

echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
docker push "${DOCKER_USERNAME}/slim-php-realworld-example-app:latest"
docker push "${DOCKER_USERNAME}/slim-php-realworld-example-app:${TAG}"
docker logout
