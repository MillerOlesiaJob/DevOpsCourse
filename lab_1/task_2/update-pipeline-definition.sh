#!/bin/bash

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
  -b|--branch)
  BRANCH="$2"
  shift
  shift
  ;;
  -o|--owner)
  OWNER="$2"
  shift
  shift
  ;;
  -p|--poll-for-source-changes)
  POLL="$2"
  shift
  shift
  ;;
  -c|--configuration)
  CONFIG="$2"
  shift
  shift
  ;;
  *)
  FILENAME="$1"
  shift
  ;;
  esac
done

echo "$FILENAME"

BRANCH="${BRANCH:-main}"
POLL="${POLL:-false}"

PIPELINE_FILE="$FILENAME-$(date +'%Y%m%d%H%M%S').json"
echo "$PIPELINE_FILE"
./jq-win64.exe --arg branch "$BRANCH" --arg owner "$OWNER" --arg poll "$POLL" --arg configuration "$CONFIG" \
  '.pipeline.version += 1 |
   .pipeline.artifactStore.location = "codepipeline-artifactStore-location" |
   .pipeline.stages[].actions[] |=
     if .name == "Source" then
       .configuration.Branch = $branch |
       .configuration.Owner = $owner |
       .configuration.PollForSourceChanges = $poll |
       .configuration.EnvironmentVariables = "[{\"name\":\"BUILD_CONFIGURATION\",\"value\":$config,\"type\":\"PLAINTEXT\"}]"
     else
       .
     end |
   del(.metadata)' \
   "$FILENAME" > "$PIPELINE_FILE"

echo "Pipeline definition updated and saved to $PIPELINE_FILE."
