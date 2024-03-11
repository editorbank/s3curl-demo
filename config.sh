### config ###
export project_name=s3curl-demo
export project_version=1.0.$(date +%y%m%d)
export docker=docker
export docker_image=scality/s3server
export docker_container=${project_name}-server
export dockerfile_dir=.

export S3_ACCESS_KEY=YOUR-ACCESS-KEY-HERE
export S3_SECRET_KEY=YOUR-SECRET-KEY-HERE
export S3_HOST="localhost"
export S3_PORT=8000
export S3_PROTOCOL=http
export S3_BUCKET="mybucket"

set -e
cd $(dirname $0)
