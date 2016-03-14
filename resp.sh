#!/bin/bash

func(){
index=$1
gcmd="grep -B 11 '\"_index\" : \"$index''index\"' server.log | grep took | awk -F \" \" '{gsub(/,$/,\"\"); sum += \$3; n++} END {print \"Count: \"n; print \"Avg: \"sum/n}'"
eval $gcmd
}

options=("employee" "company")
