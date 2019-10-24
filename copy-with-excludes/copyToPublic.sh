DEST="../test/public"
# Copy all files to DEST except those patterns specified in .publicignore and .gitignore 
# using find and rsync commands
# Example output:
# find . -not \( -path . -o -name '*.class' -o -path '**.class/*' -o -name target -o -path '*target/*' \) -exec rsync -R '{}' ../public-samples ';'
# Given a word in ignore file (e.g. target/), create the exclude option for find Command (-name target -o -path '*target/*')
# Return empty string in case of empty line
function getFindPart(){
    local line="$1"
    local PART=""
    if [ -z "$line" ] || [[ "$line" =~ ^\s*#.* ]]; then
     : #noop    
    elif [[ "$line" =~ /$ ]]; then
     #ends with a / (this is a directory) 
     strippedLine=${line%?}; #strip '/'
     #
     PART=" -name $strippedLine -o -path '*"$line"*'"
    else
     #
     PART=" -name '"$line"' -o -path '*"$line"/*'" 
    fi
    echo $PART  
}
# Returns options string for all patterns in an ignore file
# e.g. name '*.class' -o -path '**.class/*' -o -name target -o -path '*target/*'
function getPartsOfFile(){
    local file="$1"
    local parts=""
    local isFirst="1"
    while read line;
    do
       PART=$(getFindPart "$line")
       if [ ! -z "$PART" ]; then  
        if [[ $isFirst -eq "0" ]]; then
           PART=" -o $PART"   
        else 
           isFirst="0"
        fi   
         #echo $PART
         parts="$parts $PART"
       fi
    done <$file
    echo $parts
}
gitIgnore=$(getPartsOfFile .gitignore)
pubIgnore=$(getPartsOfFile .publicignore)
# Combine all options to create the find command
FIND_CMD="find . -not \( -path . -o $gitIgnore -o $pubIgnore \)" 
#COPY_CMD="$FIND_CMD -exec cp -r '{}' ../public-samples/'{}' ';'"
# Combine with exec
COPY_CMD="$FIND_CMD -exec rsync -R '{}' $DEST ';'"
echo $COPY_CMD