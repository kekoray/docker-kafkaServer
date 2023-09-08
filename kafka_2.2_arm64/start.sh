#!/bin/bash

# 检查网络配置是否存在
docker network inspect kafka_net >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "-----------  network exists : [ kafka_net ]  ------------"
else
    echo "-----------  network not exist, creating : [ kafka_net ]  ------------"
    docker network create --driver bridge --subnet 172.23.0.0/25 --gateway 172.23.0.1  kafka_net
fi

# docker-compose传参
echo "-----------  kafka is starting  ------------"
# (本机IP/FRP云服务IP)
IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
externalIP="$IP" \
managerUser="root" \
managerPasswd="123456" \
docker-compose  -f ./docker-compose.yml  up -d
