```bash
mkdir /kubernetes
cp ${path-to-k8scripts}/ca /kubernetes
cd /kubernetes/ca

# Create root CA
openssl genrsa -aes256 -out private/ca.key.pem 4096
chmod 400 private/ca.key.pem
openssl req -config openssl.cnf \
    -key private/ca.key.pem \
    -new -x509 -days 7300 -sha256 -extensions v3_ca \
    -out certs/ca.cert.pem
chmod 444 certs/ca.cert.pem

# Create intermediate CA
openssl genrsa -aes256 \
    -out intermediate/private/intermediate.key.pem 4096
chmod 400 intermediate/private/intermediate.key.pem
openssl req -config intermediate/openssl.cnf -new -sha256 \
    -key intermediate/private/intermediate.key.pem \
    -out intermediate/csr/intermediate.csr.pem
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
    -days 3650 -notext -md sha256 \
    -in intermediate/csr/intermediate.csr.pem \
    -out intermediate/certs/intermediate.cert.pem
chmod 444 intermediate/certs/intermediate.cert.pem

# Verify intermediate CA
openssl x509 -noout -text \
    -in intermediate/certs/intermediate.cert.pem
openssl verify -CAfile certs/ca.cert.pem \
    intermediate/certs/intermediate.cert.pem

# Create CA chain
cat intermediate/certs/intermediate.cert.pem \
    certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem
chmod 444 intermediate/certs/ca-chain.cert.pem

# Create a single cert
openssl genrsa -out /kubernetes/secret/hostname.key.pem 2048
chmod 400 /kubernetes/secret/hostname.key.pem
openssl req -key /kubernetes/secret/hostname.key.pem \
    -out /kubernetes/secret/hostname.csr.pem \
    -subj '/CN=hostname' -new -sha256
SUBJECTALTNAMES="IP:${hostip}, IP:10.0.0.1" openssl ca -config /kubernetes/ca/intermediate/openssl.cnf \
    -extensions server_cert -days 375 -notext -md sha256 \
    -in /kubernetes/secret/hostname.csr.pem \
    -out /kubernetes/secret/hostname.cert.pem
chmod 444 /kubernetes/secret/hostname.cert.pem

#### OR do a bunch of certs at once
hosts="hostip1 hostip2 hostip3"
for host in $hosts;do
  mkdir $host
  openssl genrsa -out /kubernetes/secret/$host/$host.key.pem 2048
  openssl req -key /kubernetes/secret/$host/$host.key.pem \
    -out /kubernetes/secret/$host/$host.csr.pem \
    -subj "/CN=$host" -new -sha256
  SUBJECTALTNAMES="IP:$host, IP:10.0.0.1" openssl ca -config /kubernetes/ca/intermediate/openssl.cnf \
    -extensions server_cert -days 375 -notext -md sha256 \
    -in /kubernetes/secret/$host/$host.csr.pem \
    -out /kubernetes/secret/$host/$host.cert.pem
done


# Verify cert
openssl x509 -noout -text \
    -in /kubernetes/secret/hostname.cert.pem
openssl verify -CAfile /kuberetes/ca/intermediate/certs/ca-chain.cert.pem \
    /kubernetes/secret/hostname.cert.pem
```
