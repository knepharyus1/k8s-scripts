```bash
mkdir /kubernetes
cp ${path-to-k8scripts}/ca /kubernetes
cd /kubernetes/ca
openssl genrsa -aes256 -out private/ca.key.pem 4096
chmod 400 private/ca.key.pem
openssl req -config openssl.cnf \
-key private/ca.key.pem \
-new -x509 -days 7300 -sha256 -extensions v3_ca \
-out certs/ca.cert.pem
chmod 444 certs/ca.cert.pem
openssl genrsa -aes256 \
-out intermediate/private/intermediate.key.pem 4096
```
