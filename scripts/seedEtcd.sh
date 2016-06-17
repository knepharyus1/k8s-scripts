#!/bin/bash
docker -H unix:///var/run/docker-bootstrap.sock exec \
-t \
etcd etcdctl \
--no-sync \
--peers https://${HOSTNAME}:2379,https://${HOSTNAME}:4001 \
--ca-file=/secret/trust.pem \
--cert-file=/secret/host.cer \
--key-file=/secret/host.key \
mk /coreos.com/network/config {\"Network\":\"10.1.0.0/16\"}
