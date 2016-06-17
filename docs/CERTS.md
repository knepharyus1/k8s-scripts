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

# Create cert
openssl genrsa -aes256 -out /certs/hostname.key.pem
chmod 400 /certs/hostname.key.pem
openssl req -key /certs/hostname.key.pem -out /certs/hostname.csr.pem \
    -subj '/CN=hostname' -new -sha256
openssl ca -config /kubernetes/ca/intermediate/openssl.cnf \
    -extensions server_cert -days 375 -notext -md sha256 \
    -in /certs/hostname.csr.pem \
    -out /certs/hostname.cert.pem
chmod 444 /certs/hostname.cert.pem

# Verify cert
openssl x509 -noout -text \
    -in /certs/hostname.cert.pem
```
