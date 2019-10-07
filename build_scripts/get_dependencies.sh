#!/bin/bash -e

# PLEASE NOTE: running this script on a non-virtual machine/container will have dubious results at best

# this doesn't really work most of the time
# for downloading commands only
APT_OPTS='-o APT::Architecture=armhf -o Dir::Etc::sourcelist="/etc/apt/sources.list.d/raspbian.list"'

apt-get update
apt-get install -y curl gnupg

echo "deb http://archive.raspbian.org/raspbian buster main contrib non-free" > /etc/apt/sources.list.d/raspbian.list
echo "deb-src http://archive.raspbian.org/raspbian buster main contrib non-free" >> /etc/apt/sources.list.d/raspbian.list
curl https://archive.raspbian.org/raspbian.public.key | apt-key add -

dpkg --add-architecture armhf
apt-get update

ls packages/deps/*
dpkg -I packages/deps/opensight*.deb
for file in packages/deps/*; do
    #                                          Removes depends  Comma to newline   Remove all after : and (
    dpkg-deb -I "$file" | grep Depends | sed -e 's/ Depends: //' -e 's/, /\n/g' -e 's/:.*$//g' -e 's/ (.*$//g' > dependencies
done
sort -u dependencies -o dependencies
echo "DEPENDENCIES STAGE 1"
cat dependencies

# remove packages already in folder
for file in packages/deps/*; do
    remove="$(basename $file | sed 's/_.*$//')"
    sed -i "/$remove/d" dependencies
done

for line in $(cat dependencies); do
    apt-cache $APT_OPTS depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances $line 2>&- | grep -v '<' | grep Depends | sed -r 's/.+Depends: //' >> dependencies
done
sort -u dependencies -o dependencies
echo "DEPENDENCIES STAGE 2"
cat dependencies

# this is one of those "wtf, why would you do this, what is going on" moments so let me explain
# basically, apt does not have any method (reliable) of setting the default architecture
# APT:Architecture works _sometimes_, but not enough to be anywhere near reliable
# here, it iterates through all of the dependencies and checks if it is an "all" package or an armhf/amd64 package (amd64 happens when APT:Architecture does not work)
# this ensures that apt-download always downloads the correct architecture package
for dep in $(cat dependencies); do
    echo "TRYING DEP" $dep
    apt-cache show $dep | grep Architecture | grep -q all && echo "$dep IS ALL"
    apt-cache show $dep | grep Architecture | grep -q all && echo "$dep" >> new_dependencies
    apt-cache show $dep | grep Architecture | grep -q -e armhf -e amd64 && echo "$dep:armhf" >> new_dependencies
done

mv new_dependencies dependencies
sort -u dependencies -o dependencies
echo "NEW DEPENDENCIES"
cat dependencies

mkdir -p packages/system-deps
# fix permission errors
chown -R _apt:root packages
chmod -R 777 packages
cd packages/system-deps
apt-get "$APT_OPTS" download $(cat ../../dependencies)
cd ../../

# cleanup
rm dependencies
chown -R _apt:root packages
chmod -R 777 packages
dpkg --remove-architecture armhf
