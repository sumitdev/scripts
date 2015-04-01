#!/bin/bash

# force script to stop on error
set -e

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php5
PHAB_DIR=$HOME/phabricator
echo "creating directory $PHAB_DIR"
mkdir -p $PHAB_DIR
git clone https://github.com/phacility/libphutil.git $PHAB_DIR/libphutil
git clone https://github.com/phacility/arcanist.git $PHAB_DIR/arcanist

echo "export PATH=\"\$PATH:$PHAB_DIR/arcanist/bin/\"" >> ~/.bashrc
echo "source $PHAB_DIR/arcanist/resources/shell/bash-completion" >> ~/.bashrc
echo "export PATH=\"\$PATH:$PHAB_DIR/arcanist/bin/\"" >> ~/.profile

source ~/.bashrc
arc install-certificate




