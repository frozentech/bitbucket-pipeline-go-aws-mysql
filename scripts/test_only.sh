#!/usr/bin/env bash

# exit on error
set -e

# must be run inside the project. this is a hack for codeship
if [ ! -z ${1+x} ]; then
  cd $1
fi

GOPATH_WORKDIR=$GOPATH/src/$REPO_OWNER/$APP_NAME

# create directories
mkdir -p  $GOPATH_WORKDIR &&\
 mkdir -p /log

# Add files
cp ./*.go $GOPATH_WORKDIR
cp ./packages.sh $GOPATH_WORKDIR

# install packages
cd $GOPATH_WORKDIR &&\
 sh packages.sh &&\
 go test
