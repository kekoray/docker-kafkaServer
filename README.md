# docker-kafkaService

> 使用之前要创建对应的网络配置



### Image版本说明

| kafka版本 | 节点数 | 依赖zookeeper |
| :-------- | :----- | :------------ |
| kafka_2.2 | 3      | 是            |
| kafka_3.3 | 3      | 否            |



### Compose传参说明

| 参数项            | 说明                                                | 传参方式                         |
| ----------------- | --------------------------------------------------- | -------------------------------- |
| \${externalIP}    | kafka服务暴露在外的地址**(必须为具体IP，否则报错)** | 命令行形式传参，可动态获取本机IP |
| \${managerUser}   | kafka-manager的用户名                               | 命令行形式传参                   |
| \${managerPasswd} | kafka-manager的密码                                 | 命令行形式传参                   |



### Kafka操作说明

**1.查看zookeeper集群是否正常**

```shell
docker exec -it zk1 bin/zkServer.sh status
```

**2.新建topic**

```shell
docker exec -it kafka1 bash
cd /opt/kafka/bin/
./kafka-topics.sh --create --replication-factor 1 --partitions 3 --topic test --zookeeper zk1:2181 

# kafka3-KRAFT
kafka-topics.sh --create --topic demo --partitions 3 --replication-factor 3 --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092
```

**3.查看topic**

```shell
kafka-topics.sh --list --zookeeper zk1:2181

# kafka3-KRAFT
kafka-topics.sh --bootstrap-server kafka1:9092 --list
```

**4.删除 Topic**

```shell
kafka-topics.sh --delete --zookeeper zk1:2181  --topic test

# kafka3-KRAFT
kafka-topics.sh --delete --bootstrap-server kafka1:9092  --topic demo
```

**5.生产消息**

```shell
kafka-console-producer.sh --broker-list kafka1:9092,kafka2:9092 --topic test

# kafka3-KRAFT
kafka-console-producer.sh --bootstrap-server kafka1:9092 --topic demo
```

**6.消费消息**

```shell
kafka-console-consumer.sh --bootstrap-server kafka1:9092,kafka2:9092 --topic test

# kafka3-KRAFT
kafka-console-consumer.sh --bootstrap-server kafka1:9092 --topic demo
```

**7.压力测试**

```shell
# kafka3-KRAFT
kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=kafka1:9092 batch.size=16384 linger.ms=0
```













