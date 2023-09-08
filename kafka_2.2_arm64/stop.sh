echo "-----------  kafka is stopping  ------------"
# (本机IP/FRP云服务IP)
IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
externalIP="$IP" \
managerUser="root" \
managerPasswd="123456" \
docker-compose  -f ./docker-compose.yml down
