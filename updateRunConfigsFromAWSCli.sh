#!/usr/bin/env bash

## References
# https://stackoverflow.com/questions/29613304/is-it-possible-to-escape-regex-metacharacters-reliably-with-sed

confFileName=workspace.xml
#projectDir=`pwd`
projectDirs=("/Users/sumjain/dev/ans/repos/whitebox-test/wbt-root" "/Users/sumjain/dev/ans/repos/ans")

function sanitizeSedReplaceStr() {
    str=$1
    sanitizedStr=$(sed 's/[&/\]/\\&/g' <<<"$str")
    echo $sanitizedStr
}

AWS_ACCESS_KEY_ID_REPL=$(sanitizeSedReplaceStr "$AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY_REPL=$(sanitizeSedReplaceStr "$AWS_SECRET_ACCESS_KEY")
AWS_SECURITY_TOKEN_REPL=$(sanitizeSedReplaceStr "$AWS_SECURITY_TOKEN")
AWS_SESSION_TOKEN_REPL=$(sanitizeSedReplaceStr "$AWS_SESSION_TOKEN")

function setAWSVars() {

    projPath=$1
    workFile=$projPath/.idea/$confFileName
    echo "Working on $workFile"
    ls $workFile

#    return 1

    cp $workFile $workFile.bk

    sed -i '' -E 's/="AWS_ACCESS_KEY_ID" value=".*"/="AWS_ACCESS_KEY_ID" value="'$AWS_ACCESS_KEY_ID_REPL'"/' $workFile
    sed -i '' -E 's/="AWS_SECRET_ACCESS_KEY" value=".*"/="AWS_SECRET_ACCESS_KEY" value="'$AWS_SECRET_ACCESS_KEY_REPL'"/' $workFile
    sed -i '' -E 's/="AWS_SECURITY_TOKEN" value=".*"/="AWS_SECURITY_TOKEN" value="'$AWS_SECURITY_TOKEN_REPL'"/' $workFile
    sed -i '' -E 's/="AWS_SESSION_TOKEN" value=".*"/="AWS_SESSION_TOKEN" value="'$AWS_SESSION_TOKEN_REPL'"/' $workFile

    grep AWS_ $workFile
}

for i in "${projectDirs[@]}"
do :
   setAWSVars "$i"
done

#export AWS_ACCESS_KEY_ID=aaa
#export AWS_SECRET_ACCESS_KEY=bbb
#export AWS_SECURITY_TOKEN=ccc
#export AWS_SESSION_TOKEN=ddd


#echo $AWS_SECURITY_TOKEN
#echo $AWS_SECURITY_TOKEN_REPL
#echo '="AWS_SECURITY_TOKEN" value="aaaa"' | sed -E 's/="AWS_SECURITY_TOKEN" value=".*"/'$AWS_SECURITY_TOKEN_REPL'/'

