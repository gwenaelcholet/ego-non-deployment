#!/usr/bin/env bash

version=$1

rm -rf ../egononfront/egonon-webserver.tar
rm -rf ../ego-non-back/egonon-back.tar

cd ../egononfront
git checkout master
git merge develop
git tag V$version
git push origin --tags
./devops.sh $version
docker save -o egonon-webserver.tar egonon-webserver:$version

cd ../ego-non-back
./devops.sh $version
docker save -o egonon-back.tar egonon-back:$version