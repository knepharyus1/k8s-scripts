#!/bin/bash

docker run \
-d \
--name kubelet \
--net host \
--pid host \
--privileged \
-v /:/rootfs:ro \
-v /cgroup:/cgroup \
-v /var/run:/var/run \
-v /data/docker/var:/data/docker/var \
-v ${PATH_TO_CERTS}:/secret:ro \
-v ${PATH_TO_MANIFEST}:/etc/kubernetes/manifests-multi \
-v ${PATH_TO_KUBECONFIG}:/config \
hyperkube /hyperkube kubelet \
--address 0.0.0.0 \
--api-servers https://${HOSTNAME}:6443 \
--containerized true \
--enable-server \
--kubeconfig /config/kubeconfig.yaml \
--root-dir=/data/docker/var/lib/kubelet \
--tls-cert-file /secret/host.cer \
--tls-private-key /secret/host.key \
--cluster-dns 10.0.0.10 \
--cluster-domain cluster.local \
--v 2

docker run \
-d \
--name proxy \
--net host \
--privileged \
-v /cgroup:/cgroup \
-v /var/run:/var/run \
-v ${PATH_TO_KUBECONFIG}:/config \
-v ${PATH_TO_CERTS}:/secret \
hyperkube /hyperkube proxy \
--kubeconfig /config/kubeconfig.yaml \
--master https:${HOSTNAME}:6443 \
--v 2
