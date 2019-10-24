# Modified from https://gist.github.com/chrismdp/6c6b6c825b07f680e710 to support temporary security credentials
# References
# https://s3.amazonaws.com/doc/s3-developer-guide/RESTAuthentication.html
# https://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html#UsingTemporarySecurityCredentials
# 

AWS_ACCESS_KEY_ID=""
S3SECRET="" # pass these in
TOKEN=""

function putS3
{
  path=$1
  file=$2
  aws_path=$3
  bucket=$4
  
  date=$(date +"%a, %d %b %Y %T %z")
  tokenHeader="x-amz-security-token:$TOKEN"
  content_type='image/jpeg'
  
  signatureString="PUT\n\n$content_type\n$date\n$tokenHeader\n/$bucket$aws_path$file" 
  #echo "signatureString: $signatureString"

  signature=$(echo -en "${signatureString}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  
  time curl -v "https://$bucket.s3.amazonaws.com$aws_path$file" -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$tokenHeader" \
    -H "Authorization: AWS $AWS_ACCESS_KEY_ID:$signature"
}

#fileName will also become object name in s3
#putS3 fileBaseDirPath fileName aws_path bucket 

putS3 "/home/sumjain" $1 "/" 'sc-s3-test-nv-1'
