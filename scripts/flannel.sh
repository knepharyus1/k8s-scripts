#!/bin/bash

docker -H unix:///var/run/docker-bootstrap.sock run \
-d \
--name flannel \
--net host \
--privileged \
-e FLANNELD_ETCD_ENDPOINTS https://${HOSTNAME0}:4001,https://${HOSTNAME1}:4001,https://${HOSTNAME2}:4001 \
-e FLANNELD_ETCD_CERTFILE /secret/host.cer \
-e FLANNELD_ETCD_KEYFILE /secret/host.key \
-e FLANNELD_ETCD_CAFILE /secret/trust.pem \
-v ${PATH_TO_CERTS}:/secret:ro \
-v /dev/net:/dev/net \
flannel
