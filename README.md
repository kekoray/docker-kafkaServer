# docker-kafkaService

### 版本说明

| 版本      | CPU架构 | 节点数 | 说明 | WEB-UI |
| :-------- | :----- | :------------ | ----------- | ----------- |
| koray2021/kafka:2.2.0-arm64 | arm64 | 3      | 依赖zookeeper | koray2021/kafka:2.2.0-arm64-kafka-manager |
| koray2021/kafka:3.3.2-arm64 | arm64 | 3      | 依赖内置kraft | koray2021/kafka:3.3.2-arm64-kafka-ui |



### 目录结构

```shell
docker-kafkaService/
├── kafka_2.2_arm64
│   ├── conf
│   │   └── zoo.cfg      # zookeeper配置
│   ├── docker-compose.yml
│   ├── start.sh
│   └── stop.sh
├── kafka_3.3_arm64
    ├── docker-compose.yml
    ├── start.sh
    └── stop.sh
└── README.md
```



### Compose传参说明

| 服务          | 参数项            | 说明                                                | 传参方式                         |
| ------------- | ----------------- | --------------------------------------------------- | -------------------------------- |
| kafka         | \${externalIP}    | kafka服务暴露在外的地址**(必须为具体IP，否则报错)** | 命令行形式传参，可动态获取本机IP |
| kafka-manager | \${managerUser}   | kafka-manager的用户名                               | 命令行形式传参                   |
| kafka-manager | \${managerPasswd} | kafka-manager的密码                                 | 命令行形式传参                   |



### 网络说明

> 各个版本的**启动脚本**中会对网络配置进行检查，若不存在则新建对应的网络配置

```shell
# kafka:2.2.0版本
docker network create --driver bridge --subnet 172.23.0.0/25 --gateway 172.23.0.1  kafka_net

# kafka:3.3.2版本
docker network create --driver bridge --subnet 192.168.5.0/25 --gateway 192.168.5.1  kafka_net
```



### 容器操作

**1.查看zookeeper集群是否正常**

```shell
# kafka2
docker exec -it zk1 bin/zkServer.sh status
```

**2.新建topic**

```shell
# kafka2
docker exec -it kafka1 bash
cd /opt/kafka/bin/
./kafka-topics.sh --create --replication-factor 1 --partitions 3 --topic test --zookeeper zk1:2181 

# kafka3-KRAFT
docker exec -it kafka1 bash
kafka-topics.sh --create --topic demo --partitions 3 --replication-factor 3 --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092
```

**3.查看topic**

```shell
# kafka2
kafka-topics.sh --list --zookeeper zk1:2181

# kafka3-KRAFT
kafka-topics.sh --list --bootstrap-server kafka1:9092 
```

**4.删除 Topic**

```shell
# kafka2
kafka-topics.sh --delete --zookeeper zk1:2181  --topic test

# kafka3-KRAFT
kafka-topics.sh --delete --bootstrap-server kafka1:9092  --topic demo

# zk彻底删除
zkCli.sh
ls /brokers/topics
delete  /brokers/topics/test
```

**5.生产消息**

```shell
# kafka2
kafka-console-producer.sh --broker-list kafka1:9092,kafka2:9092 --topic test

# kafka3-KRAFT
kafka-console-producer.sh --bootstrap-server kafka1:9092 --topic demo
```

**6.消费消息**

```shell
# kafka2
kafka-console-consumer.sh --bootstrap-server kafka1:9092,kafka2:9092 --topic test

# kafka3-KRAFT
kafka-console-consumer.sh --bootstrap-server kafka1:9092 --topic demo
```

**7.压力测试**

```shell
# kafka3-KRAFT
kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=kafka1:9092 batch.size=16384 linger.ms=0
```













