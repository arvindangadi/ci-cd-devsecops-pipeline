#!/bin/bash

IMAGE=$1

echo "Running Trivy scan on Docker image: $IMAGE"
trivy image --severity HIGH,CRITICAL $IMAGE || true
