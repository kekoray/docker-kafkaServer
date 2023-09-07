echo "-----------  kafka is stopping  ------------"
IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
externalIP="$IP" \
docker-compose  -f ./docker-compose.yml down
