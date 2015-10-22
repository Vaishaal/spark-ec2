#!/bin/bash

pushd /root

# Checkout keystone
if [ ! -d "/root/keystone" ]; then
  git clone https://github.com/shivaram/keystone.git -b imagenet-research
fi

pushd /root/keystone

# Build keystone
git stash
git pull
sbt/sbt assembly
make

/root/spark-ec2/copy-dir /root/keystone

popd

/root/spark/sbin/stop-all.sh

~/spark/sbin/slaves.sh rm -rf /root/spark/work
~/spark/sbin/slaves.sh mkdir -p /mnt/spark-work 
~/spark/sbin/slaves.sh ln -s /mnt/spark-work /root/spark/work

/root/spark/sbin/start-all.sh

mkdir -p /mnt/spark-events
