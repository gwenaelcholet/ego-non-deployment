#!/usr/bin/env bash

version=$1

rm -rf ../egononfront/egonon-webserver.tar
rm -rf ../ego-non-back/egonon-back.tar
ssh root@188.166.122.181 'rm -rf egonon-webserver.tar egonon-back.tar'

cd ../egononfront || exit
git checkout master
git merge develop
git push origin master
git tag V"$version"
git push origin --tags
./devops.sh "$version"
docker save -o egonon-webserver.tar egonon-webserver:"$version"

cd ../ego-non-back || exit
./devops.sh "$version"
docker save -o egonon-back.tar egonon-back:"$version"

scp egonon-back.tar root@188.166.122.181:/root
scp ../egononfront/egonon-webserver.tar root@188.166.122.181:/root

rm -rf egonon-back.tar
rm -rf ../egononfront/egonon-webserver.tar

ssh root@188.166.122.181 'docker load < egonon-webserver.tar'
ssh root@188.166.122.181 'docker load < egonon-back.tar'

ssh root@188.166.122.181 'sed -i "s/\(egonon-back:\).*/\1'"$version"'/g" ./egononmount/docker-compose.yaml'
ssh root@188.166.122.181 'sed -i "s/\(egonon-webserver:\).*/\1'"$version"'/g" ./egononmount/docker-compose.yaml'

ssh root@188.166.122.181 'docker-compose -f "./egononmount/docker-compose.yaml" down'
ssh root@188.166.122.181 'docker-compose -f "./egononmount/docker-compose.yaml" up -d --build'

cd ../egononfront || exit
git checkout .
rm -rf src/egononfront/events.cljs.bak
git checkout develop