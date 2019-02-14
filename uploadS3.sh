# Modified from https://gist.github.com/chrismdp/6c6b6c825b07f680e710 to support temporary security credentials
# References
# https://s3.amazonaws.com/doc/s3-developer-guide/RESTAuthentication.html
# https://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html#UsingTemporarySecurityCredentials
# 
# 

display_help() {
    echo "Usage: $0 fullFilePath"
    echo
    exit 1
}

if [ $# -ne 1 ]
  then
    display_help
fi

AWS_ACCESS_KEY_ID="ASXXXXXXXXXXXX"
AWS_SECRET_ACCESS_KEY=""
AWS_SECURITY_TOKEN=""

function putS3
{

  fullFilePath=$1
  file=$(basename "$fullFilePath")
  bucket=$2
  aws_path=$3
   
  date=$(date +"%a, %d %b %Y %T %z")
  
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html#UsingTemporarySecurityCredentials
  tokenHeader="x-amz-security-token:$AWS_SECURITY_TOKEN"
  
  content_type='image/jpeg'
  
  #See https://s3.amazonaws.com/doc/s3-developer-guide/RESTAuthentication.html
  signatureString="PUT\n\n$content_type\n$date\n$tokenHeader\n/$bucket$aws_path$file"
  #echo "signatureString: $signatureString"
  signature=$(echo -en "${signatureString}" | openssl sha1 -hmac "${AWS_SECRET_ACCESS_KEY}" -binary | base64)
  
  time curl -v "https://$bucket.s3.amazonaws.com$aws_path$file" -X PUT -T "$fullFilePath" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$tokenHeader" \
    -H "Authorization: AWS $AWS_ACCESS_KEY_ID:$signature"
}

#fileName will also become object name in s3
#putS3 fullFilePath bucket aws_path  

putS3 $1 'mybucket' "/" 
