#!/bin/bash

set -x

# To setup cluster you have to use same cookie
docker run -d --hostname rabbit-1 \
--name rabbit-1  --restart=always \
--network rabbits \
-v ${pwd}/config/rabbit-1/config:/config/ \
-e RABBITMQ_CONFIG_FILE=/config/rabbitmq \
-e RABBITMQ_ERLANG_COOKIE=FGBHGCLDDWMIMOONLTPD \
-p 8091:15672 rabbitmq:4.0-management


docker run -d --hostname rabbit-2 \
--name rabbit-2  --restart=always \
--network rabbits \
-v ${pwd}/config/rabbit-2/config:/config/ \
-e RABBITMQ_CONFIG_FILE=/config/rabbitmq \
-e RABBITMQ_ERLANG_COOKIE=FGBHGCLDDWMIMOONLTPD \
-p 8092:15672 rabbitmq:4.0-management


docker run -d --hostname rabbit-3 \
--name rabbit-3  --restart=always \
--network rabbits \
-v ${pwd}/config/rabbit-3/config:/config/ \
-e RABBITMQ_CONFIG_FILE=/config/rabbitmq \
-e RABBITMQ_ERLANG_COOKIE=FGBHGCLDDWMIMOONLTPD \
-p 8093:15672 rabbitmq:4.0-management

# join node-02 with node-01
docker exec -it rabbit-2 rabbitmqctl stop_app
docker exec -it rabbit-2 rabbitmqctl reset
docker exec -it rabbit-2 rabbitmqctl join_cluster rabbit@rabbit-1
docker exec -it rabbit-2 rabbitmqctl start_app
docker exec -it rabbit-2 rabbitmqctl cluster_status

# join node-03 with node-01
docker exec -it rabbit-3 rabbitmqctl stop_app
docker exec -it rabbit-3 rabbitmqctl reset
docker exec -it rabbit-3 rabbitmqctl join_cluster rabbit@rabbit-1
docker exec -it rabbit-3 rabbitmqctl start_app
docker exec -it rabbit-3 rabbitmqctl cluster_status
