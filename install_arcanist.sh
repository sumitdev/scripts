#!/bin/bash

# force script to stop on error
set -e

#setup arc script and dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php5 php5-cli php5-curl < "/dev/null" ;
PHAB_DIR=$HOME/phabricator
echo "creating directory $PHAB_DIR"
mkdir -p $PHAB_DIR
git clone https://github.com/phacility/libphutil.git $PHAB_DIR/libphutil
git clone https://github.com/phacility/arcanist.git $PHAB_DIR/arcanist

#add arc to path
echo "export PATH=\"\$PATH:$PHAB_DIR/arcanist/bin/\"" >> ~/.bashrc
export PATH="$PATH:$PHAB_DIR/arcanist/bin/"
echo "source $PHAB_DIR/arcanist/resources/shell/bash-completion" >> ~/.bashrc
#echo "export PATH=\"\$PATH:$PHAB_DIR/arcanist/bin/\"" >> ~/.profile

# This should be run in git project directory which must have .arcconfig file
# example .arcconfig
#{
#  "project.name" : "project",
#  "phabricator.uri" : "http://phabricator-hostname/"
#}
arc install-certificate




