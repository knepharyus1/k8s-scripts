# Installation on a workstation with a pre-existing Docker instance

```bash
systemctl stop docker
mv /usr/lib/systemd/system/docker.service /usr/lib/systemd/system/docker.service.org
mv /etc/sysconfig/docker /etc/sysconfig/docker.org
cp ${path-to-k8scripts}/usr/lib/systemd/system/docker.service /usr/lib/systemd/system/docker.service
cp ${path-to-k8scripts}/usr/lib/systemd/system/docker.socket /usr/lib/systemd/system/docker.socket
chmod 644 /usr/lib/systemd/system/docker.service
chmod 644 /usr/lib/systemd/system/docker.socket
cp ${path-to-k8scripts}/etc/sysconfig/docker /etc/sysconfig/docker
chmod 644 /etc/sysconfig/docker
mkdir -p /etc/systemd/system/docker.service.d
cp ${path-to-k8scripts}/etc/systemd/system/docker.service.d/custom-environment-file.conf /etc/systemd/system/docker.service.d/custom-environment-file.conf
chmod 644 /etc/systemd/system/docker.service.d/custom-environment-file.conf
cp ${path-to-k8scripts}/dev/k8s-scripts/usr/lib/systemd/system/docker-bootstrap.service /usr/lib/systemd/system/docker-bootstrap.service
cp ${path-to-k8scripts}/dev/k8s-scripts/usr/lib/systemd/system/docker-bootstrap.socket /usr/lib/systemd/system/docker-bootstrap.socket
chmod 644 /usr/lib/systemd/system/docker-bootstrap.service
chmod 644 /usr/lib/systemd/system/docker-bootstrap.socket
cp ${path-to-k8scripts}/dev/k8s-scripts/etc/sysconfig/docker-bootstrap /etc/sysconfig/docker-bootstrap
chmod 644 /etc/sysconfig/docker-bootstrap
mkdir -p /etc/systemd/system/docker-bootstrap.service.d
cp ${path-to-k8scripts}/dev/k8s-scripts/etc/systemd/system/docker-bootstrap.service.d/custom-environment-file.conf /etc/systemd/system/docker-bootstrap.service.d/custom-environment-file.conf
chmod 644 /etc/systemd/system/docker-bootstrap.service.d/custom-environment-file.conf
systemctl enable docker-bootstrap.socket
systemctl enable docker-bootstrap
systemctl start docker-bootstrap
```
