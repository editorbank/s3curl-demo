#!
set -x
docker rm -f scality-s3server
docker rmi -f scality/s3server
ls -1t ./.s3cfg.*.bak | head -qn 1 | xargs -i mv {} ~/.s3cfg 
