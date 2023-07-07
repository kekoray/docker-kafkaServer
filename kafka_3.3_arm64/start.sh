echo "-----------  kafka is starting  ------------"
# docker-compose传参
IP=$(ip addr show wlan0 | grep -Po 'inet \K[\d.]+')
externalIP="$IP" docker-compose  -f ./docker-compose.yml  up -d
