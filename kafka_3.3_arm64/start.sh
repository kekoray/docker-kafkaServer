#!/bin/bash

# 检查网络配置是否存在
docker network inspect kafka_net >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "-----------  network exists : [ kafka_net ]  ------------"
else
    echo "-----------  network not exist, creating : [ kafka_net ]  ------------"
    docker network create --driver bridge --subnet 192.168.5.0/25 --gateway 192.168.5.1  kafka_net
fi

# docker-compose传参
echo "-----------  kafka is starting  ------------"
IP=$(ip addr show wlan0 | grep -Po 'inet \K[\d.]+')
externalIP="$IP" \
docker-compose -f ./docker-compose.yml up -d
