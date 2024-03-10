#!
set -ex
docker ps >/dev/null
docker rm -f scality-s3server || true

docker run -d --name scality-s3server \
  -p 8000:8000 \
  -e SCALITY_ACCESS_KEY_ID=YOUR-ACCESS-KEY-HERE \
  -e SCALITY_SECRET_ACCESS_KEY=YOUR-SECRET-KEY-HERE \
  scality/s3server

s3cmd --help >/dev/null || sudo apt install s3cmd 
diff ./.s3cfg ~/.s3cfg >/dev/null || ( mv ~/.s3cfg ./.s3cfg.$RANDOM.bak && cp ./.s3cfg ~/.s3cfg ) 
s3cmd mb s3://mybucket || true
echo OK
