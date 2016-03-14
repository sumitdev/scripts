#!/bin/bash
# Script assumes an entry of preprod in hosts file
# and username/key already configured in ~/.ssh/config

source $1

func_wrapper(){
 echo "executing for option $@"
 func "$@"	
}

count=${#options[@]}
echo "Select an option"
for ((i=0; i<$count; ++i )) ;
do
        echo -e '\E[36;40m '$i' '${options[i]}; tput sgr0
done

echo -e '\E[36;40m '"$count"' All'; tput sgr0

read option

if [ "$option" -eq "$count" ]; then
    for ((i=0; i<$count; ++i )) ;
    do
       func_wrapper ${options[i]}
    done
else
    func_wrapper ${options[option]}
fi
