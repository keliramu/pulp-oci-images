#!/bin/bash

echo "Rebuild pulp OCI images..."

podman build --platform linux/amd64 --format docker --file images/Containerfile.core.base --tag pulp/base:latest-amd64 . 2>&1 | tee podman-build1.log

podman build --platform linux/amd64 --format docker --file images/pulp_ci_centos/Containerfile --tag pulp/pulp-ci-centos:latest-amd64 --build-arg FROM_TAG=latest-amd64 . 2>&1 | tee podman-build2.log

podman build --platform linux/amd64 --format docker --pull=false --file images/pulp/stable/Containerfile --tag pulp/pulp:latest-amd64 --build-arg FROM_TAG=latest-amd64 . 2>&1 | tee podman-build3.log

podman images
