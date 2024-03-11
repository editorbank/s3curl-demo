#!/bin/env bash
source $(dirname $0)/config.sh

# Удаление контейнеров и образов сделанных проектом
$docker ps -q -a -f name=$docker_container | xargs -r $docker rm -f
$docker images -q -f reference=$docker_image | xargs -r $docker rmi -f
$docker volume ls -q -f name=$project_name | xargs -r $docker volume rm
# востановление настроек s3cmd, если они были 
(ls -1t ./.s3cfg.*.bak 2>/dev/null||true) | head -qn 1 | xargs -i mv {} ~/.s3cfg

echo OK
