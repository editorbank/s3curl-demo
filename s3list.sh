#!/bin/bash  
source $(dirname $0)/config.sh
 
#S3_ACCESS_KEY="YOUR-ACCESS-KEY-HERE"
#S3_SECRET_KEY="YOUR-SECRET-KEY-HERE"
#S3_HOST="localhost"
#S3_PORT=8000
#S3_PROTOCOL=http
#S3_BUCKET="mybucket"
 
set -e
[ -n "${S3_ACCESS_KEY}" -a -n "${S3_SECRET_KEY}" -a -n "${S3_HOST}" -a -n "${S3_BUCKET}" ] || (1>&2 echo "Error: Undefined need variables!" ; exit 1)
s3_file="${1:-s3list.xml}"
content_type="application/octet-stream"
date_time=$(date -R)
resource="/${S3_BUCKET}/"
method="GET"
signed_text="${method}\n\n${content_type}\n${date_time}\n${resource}"
signature=$(echo -en "${signed_text}" | openssl sha1 -hmac ${S3_SECRET_KEY} -binary | base64)
url="${S3_PROTOCOL:-https}://${S3_HOST}:${S3_PORT:-443}${resource}"
echo "${method} file:${s3_file} url:${url} ..."
curl -ks -o ${s3_file} ${url} \
 -X ${method} \
 -H "Host: ${S3_HOST}" \
 -H "Content-Type: ${content_type}" \
 -H "Date: ${date_time}" \
 -H "Authorization: AWS ${S3_ACCESS_KEY}:${signature}" \
  && sed "s/<Contents>\|<\/ListBucketResult>/\n\0/g" -i ${s3_file} \
  && echo OK || (1>&2 echo "Error: ${method}!" ; exit 1)

