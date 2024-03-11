#!/bin/env bash
source $(dirname $0)/config.sh

# Удалить контейнер если он есть
$docker ps -q -a -f name=$docker_container | xargs -r $docker rm -f

# Запустить новый контейнер сервера
$docker run -d --name $docker_container \
  -p $S3_PORT:8000 \
  -e SCALITY_ACCESS_KEY_ID=$S3_ACCESS_KEY \
  -e SCALITY_SECRET_ACCESS_KEY=$S3_SECRET_KEY \
  -v ${project_name}-Data:/usr/src/app/localData \
  -v ${project_name}-Metadata:/usr/src/app/localMetadata \
  $docker_image

# Установить утилиту s3cmd если её нет
s3cmd --help >/dev/null || sudo apt install s3cmd
# Настроить конфиг утилиты s3cmd
sed "s|host_base = .*|host_base = http://$S3_HOST:$S3_PORT|" -i ./.s3cfg
sed "s|access_key = .*|access_key = $S3_ACCESS_KEY|" -i ./.s3cfg
sed "s|secret_key = .*|secret_key = $S3_SECRET_KEY|" -i ./.s3cfg
sed "s|host_bucket = .*|host_bucket = http://$S3_HOST:$S3_PORT/%(bucket)s|" -i ./.s3cfg

# Сделать бакап старого конфига и копировать новый конфиг
diff ./.s3cfg ~/.s3cfg >/dev/null || ( mv ~/.s3cfg ./.s3cfg.$RANDOM.bak && cp ./.s3cfg ~/.s3cfg ) 
# Создать бакет
s3cmd mb s3://$S3_BUCKET || true
# Список бакетов
s3cmd ls
# Положить файл readme.md в бакет под именем test (таким образом подождать готовность сервера к работе)
s3cmd put readme.md s3://$S3_BUCKET/test && s3cmd rm s3://$S3_BUCKET/test
# Список файлов в бакете
s3cmd ls s3://$S3_BUCKET
echo OK
