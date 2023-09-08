#!/bin/bash

# 检查网络配置是否存在
docker network inspect unite_net >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "-----------  network exists : [ unite_net ]  ------------"
else
    echo "-----------  network not exist, creating : [ unite_net ]  ------------"
    docker network create --driver bridge --subnet 192.168.5.0/25 --gateway 192.168.5.1  unite_net
fi

# docker-compose传参
echo "-----------  kafka is starting  ------------"
# (本机IP/FRP云服务IP)
IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
externalIP="$IP" \
docker-compose -f ./docker-compose.yml up -d
