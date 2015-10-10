#!/bin/bash

#Location of csv files
DIR='/home/sumit/scripts/'

echo -e "\E[33;33m CSV Files in $DIR";
csvFiles=($(ls  $DIR*.csv))
fileCount=${#csvFiles[@]}

for ((i=0; i<$fileCount; ++i )) ;
do
        echo -e '\E[36;40m '$i' '${csvFiles[i]}; tput sgr0
done

read option

INPUT_FILE=${csvFiles[$option]}
echo $INPUT_FILE
IFS=','
counts=0

while read sshdetails remarks
do
remarkarr[$counts]=$remarks
ssharr[$counts]=$sshdetails
let counts++
done < $INPUT_FILE

echo  -e '\E[33;33m Select the enviornment u want to operate'; tput sgr0
max=${#ssharr[@]}
for ((i=1; i<$max; ++i )) ; 
do
    echo -e '\E[36;40m '$i' '${remarkarr[i]}; tput sgr0
done

while true
do
read option
echo 'connecting....'
		if [[ -z ${ssharr[$option]} ]]; then
			echo -e '\E[31;31m Are you kidding me, Please try again'; tput sgr0
			continue;
		else 
			break;
		fi	
done
echo ${ssharr[$option]}
eval ${ssharr[$option]}
