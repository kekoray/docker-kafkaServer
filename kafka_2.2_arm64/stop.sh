echo "-----------  kafka is stopping  ------------"
IP=$(ip addr show wlan0 | grep -Po 'inet \K[\d.]+')
externalIP="$IP" \
managerUser="root" \
managerPasswd="123456" \
docker-compose  -f ./docker-compose.yml down
