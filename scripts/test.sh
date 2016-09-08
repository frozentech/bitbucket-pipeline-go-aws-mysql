#!/usr/bin/env bash

# exit on error
set -e

export APP_ENV=TESTING
export DB_NAME=test_app
export DB_OPEN="root:$MYSQL_ROOT_PASSWORD@tcp(localhost:3306)/$DB_NAME"

# must be run inside the project. this is a hack for codeship
if [ ! -z ${1+x} ]; then
  cd $1
fi

GOPATH_WORKDIR=$GOPATH/src/$REPO_OWNER/$APP_NAME

# create directories
mkdir -p  $GOPATH_WORKDIR &&\
 mkdir -p /log &&\
 mkdir -p /db/migrations

# create config for goose
goose-conf.sh mysql $DB_OPEN > /db/dbconf.yml

# Add files
cp ./*.go $GOPATH_WORKDIR
cp ./packages.sh $GOPATH_WORKDIR
cp -R ./docs $GOPATH_WORKDIR/docs
cp ./db/migrations/*.sql /db/migrations

# create and deploy database
cd / &&\
 /etc/init.d/mysql start &&\
 mysql --user=root --password=$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $DB_NAME;"

echo "Execting goose.." &&\
 goose -env default up

# install packages
cd $GOPATH_WORKDIR &&\
 sh packages.sh &&\
 go test
