#!/bin/bash

GIT_TAG=$(curl -sL https://api.github.com/repos/zcash/zcash/releases/latest | jq -r ".tag_name")
echo "building version $GIT_TAG" 
docker build -t zcashd --build-arg GIT_TAG=$GIT_TAG .

