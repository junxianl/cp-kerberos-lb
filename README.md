# Documentation

This repository is a simple demo of Confluent Kafka with Kerberos authentication behind a HAProxy load balancer.


## Startup
Running `docker-compose up -d` will bring up all services. 

**Note:** This may involve somewhere between 3-5 GB of downloads, depending what images are already present on your system. 

The services included in this demo are:
- kafka-kdc-server: Kerberos authentication server
- zookeeper: Apache Zookeeper
- broker1 : Confluent Kafka broker
  - unsecure port: 29091 PLAINTEXT 
  - secure port: 9991 SASL_PLAINTEXT Kerberos
- broker2: Confluent Kafka broker
  - unsecure port: 29092 PLAINTEXT 
  - secure port: 9992 SASL_PLAINTEXT Kerberos
- control-center: Confluent Control Center - available on localhost:9021
- loadbalancer: HAProxy 
  - unsecure port: 9001 -> broker1:29091/broker2:29092
  - secure port: 9101 -> broker1:9991/broker2:9992
- kafkaclient1: demo container to run commands from

## Demo
All kafka-commands must be executed from within the kafkaclient1 container for networking purposes. Kerberos authenticates based on the FQDN which has been defined in this scenario as seen from the docker cp-kerberos-lb bridge network, so the authentication will fail if accessed externally.

`docker exec -it kafkaclient1 /bin/bash`


### Plaintext Authentication with HAProxy load balancing
To demo the load balancer is working without authentication:

`kafka-topics --bootstrap-server broker1:29091 --list`

`kafka-topics --bootstrap-server broker2:29092 --list`

`kafka-topics --bootstrap-server haproxy:9001 --list`

You may bring down any of the brokers and test the above commands to confirm the behaviour as expected.
  
  
  

### Kerberos Authentication with HAProxy load balancing
To demo the load balancer behind the Kerberos authentication:

Firstly, it would be instructive to run `docker logs -f broker1` in a separate terminal to view the logs from the broker.

You may begin by running the same command but pointing to the SECURED listener port: 

`kafka-topics --bootstrap-server broker1:9991 --list`

This will not return anything on the executing terminal. Examine the logs from broker1 in your separate terminal for further information: You will see that broker1 should continuously be printing Authentication errors from the client.

Terminate the running kafka-topics command with `ctrl-c`.

Now, you may attempt the same commands with Kerberos authentication:

`kafka-topics --command-config client.properties --bootstrap-server broker1:9991 --list` and it should work properly.

`kafka-topics --command-config client.properties --bootstrap-server haproxy:9101 --list`


Some further commands that you may use for your testing:

`kafka-topics --command-config client.properties --bootstrap-server haproxy:9101 --create --replication-factor 2 --topic test-topic`

`kafka-console-producer --producer.config client.properties --bootstrap-server haproxy:9101 --topic test-topic`

`kafka-console-consumer --consumer.config client.properties --bootstrap-server haproxy:9101 --topic test-topic --from-beginning`


Further experimentation is left up to the reader.
