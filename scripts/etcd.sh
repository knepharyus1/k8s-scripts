#!/bin/bash

docker -H unix:///var/run/docker-bootstrap.sock create \
--name data_etcd \
-v /etcd.data \
gcr.io/google_containers/etcd-amd64:2.2.1 /bin/true

docker -H unix:///var/run/docker-bootstrap.sock run \
-d \
--name etcd \
--net host \
--volumes-from data_etcd \
-p 2379:2379 \
-p 2380:2380 \
-p 4001:4001 \
-e ETCD_NAME=etcd${HOSTNUMBER} \
-e ETCD_DATA_DIR=/etcd.data \
-e ETCD_ADVERTISE_CLIENT_URLS=https://${HOSTNAME}:2379,https://${HOSTNAME}:4001 \
-e ETCD_LISTEN_CLIENT_URLS=https://0.0.0.0:2379,https://0.0.0.0:4001 \
-e ETCD_INITIAL_ADVERTISE_PEER_URLS=https://${HOSTNAME}:2380 \
-e ETCD_LISTEN_PEER_URLS=https://0.0.0.0:2380 \
-e ETCD_INITIAL_CLUSTER_TOKEN=etcd_cluster \
-e ETCD_INITIAL_CLUSTER=etcd0=https://${HOSTNAME0}:2380,etcd1=https://${HOSTNAME1}:2380,etcd2=https://${HOSTNAME2}:2380 \
-e ETCD_PEER_CLIENT_CERT_AUTH=true \
-e ETCD_PEER_CERT_FILE=/secret/host.cer \
-e ETCD_PEER_KEY_FILE=/secret/host.key \
-e ETCD_PEER_TRUSTED_CA_FILE=/secret/trust.pem \
-e ETCD_CLIENT_CERT_AUTH=true \
-e ETCD_CERT_FILE=/secret/host.cer \
-e ETCD_KEY_FILE=/secret/host.key \
-e ETCD_TRUSTED_CA_FILE=/secret/trust.pem \
-v ${PATH_TO_CERTS}:/secret:ro \
gcr.io/google_containers/etcd-amd64:2.2.1 etcd
