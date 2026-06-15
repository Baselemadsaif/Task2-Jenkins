#!/bin/bash

set -e

: "${JENKINS_URL:?Missing JENKINS_URL}"
: "${JENKINS_USER:?Missing JENKINS_USER}"
: "${JENKINS_TOKEN:?Missing JENKINS_TOKEN}"

JOB_NAME="Jenkins-pipeline"

echo "Triggering Jenkins job: $JOB_NAME"

curl -s -X POST \
  -u "$JENKINS_USER:$JENKINS_TOKEN" \
  "$JENKINS_URL/job/$JOB_NAME/buildWithParameters?ENVIRONMENT=dev&RUN_TESTS=true&SHOW_FILES=false&BUILD_DOCKER=false&RUN_DOCKER_TEST=false"

echo "Build triggered."

sleep 5

while true; do
  RESPONSE=$(curl -s -u "$JENKINS_USER:$JENKINS_TOKEN" \
    "$JENKINS_URL/job/$JOB_NAME/lastBuild/api/json")

  BUILDING=$(echo "$RESPONSE" | jq -r '.building')
  RESULT=$(echo "$RESPONSE" | jq -r '.result')
  BUILD_NUMBER=$(echo "$RESPONSE" | jq -r '.number')

  echo "Build #$BUILD_NUMBER status: building=$BUILDING result=$RESULT"

  if [ "$BUILDING" = "false" ]; then
    break
  fi

  sleep 5
done

if [ "$RESULT" = "SUCCESS" ]; then
  echo "Jenkins build succeeded."
  exit 0
else
  echo "Jenkins build failed with result: $RESULT"
  exit 1
fi
