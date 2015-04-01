#!/bin/bash

# force script to stop on error
set -e

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php5
PHAB_DIR='~/phabricator'
mkdir -p $PHAB_DIR
git clone https://github.com/phacility/libphutil.git $PHAB_DIR/libphutil
git clone https://github.com/phacility/arcanist.git $PHAB_DIR/arcanist

echo 'export PATH="$PATH:~/phabricator/arcanist/bin/"' >> ~/.bashrc
echo 'export PATH="$PATH:~/phabricator/arcanist/bin/"' >> ~/.profile

source ~/.bashrc
arc install-certificate




