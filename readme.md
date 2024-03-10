# s3curl-demo

Пример отправки и получения файлов на S3/AWS-совместимый сервер

## Требования к среде исполнения

* ОС Linux (Ubuntu)
* Виртуальная среда исполнения образов Docker/Podman

## Назначение коммандных файлов

* `init.sh` - Инициализация примера (загрузка образа, запуск сервера,
 установка и настройка клиента (s3cmd), создание бакета)
* `s3put.sh` - Отправка файла (по умолчанию, `readme.md`)
* `s3get.sh` - Получение файла (по умолчанию, `readme.md`)
* `clean.sh` - Очистка места от образа, востановление настроек s3cmd
