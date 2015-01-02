#!/bin/bash

echo '=============================='
echo 'create database '${DB_NAME} > /app/setup/createdb.sql
cat /app/setup/createdb.sql

mysql -h${DB_HOST} -P${DB_PORT} -u${DB_USER} -p${DB_PASS} < /app/setup/createdb.sql

