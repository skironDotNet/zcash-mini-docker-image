#!/bin/bash
if [ -f /.dockerenv ]; then 
   echo "Started script in staging container to build zcashd"
else
   echo "This script was meant to run in docker container only!. Exiting without any action."
   exit
fi

#Install needed tools
export DEBIAN_FRONTEND=noninteractive
export TZ=Etc/UTC
apt-get update
apt-get install -y wget git make jq curl binutils build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python3 python3-zmq zlib1g-dev curl bsdmainutils automake libtinfo5

cd /

#check latest zcash build tag
ZEC_TAG=$(curl -sL https://api.github.com/repos/zcash/zcash/releases/latest | jq -r ".tag_name")
echo "Latest zcash version tag: $ZEC_TAG"
echo "***"
echo $ZEC_TAG > /output/zec-version.txt

#clone zcash repo to inside container
git clone --progress https://github.com/zcash/zcash.git
cd zcash

#checkout previously discovered latest tag and use that source code
git checkout -b buildtag $ZEC_TAG
./zcutil/build.sh -j$(nproc)

#minimize binary size by removing debug info
cd src
strip zcashd
strip zcash-cli

#copy zcashd to host (via mounted volume when container started in the main build.sh script)
cp zcashd /output
cp zcash-cli /output
echo "All done in staging container"
