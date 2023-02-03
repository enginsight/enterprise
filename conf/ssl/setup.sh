#!/bin/bash

# generate new random password if not available.
if [ ! -f ./passwd ]; then
  echo $(openssl rand -base64 16) > ./passwd
fi

# get password from saved file.
passwd=$(cat ./passwd)

# generate mongodbCA key.
openssl genrsa -des3 -out mongodbCA.key -passout pass:$(echo ${passwd}) 4096

# generate mongodbCA certificate.
openssl req -x509 -new -nodes -key mongodbCA.key -sha256 -days 3650 -subj "/C=DE/ST=CA/O=Enginsight/CN=enginsight.com" -passin pass:$(echo ${passwd}) -out mongodbCA.crt

# generate mongodb key.
openssl genrsa -out mongodb.key -passout pass:$(echo ${passwd}) 2048

# generate mongodb csr.
openssl req -new -sha256 -key mongodb.key -out mongodb.csr -config csr.cnf -subj "/C=DE/O=Enginsight/CN=enginsight.com"

# generate mongodb certificate.
openssl x509 -sha256 -req -days 3650 -passin pass:$(echo ${passwd}) -in mongodb.csr -CA mongodbCA.crt -CAkey mongodbCA.key -CAcreateserial -out mongodb.crt -extfile csr.cnf -extensions v3_req

# concat key and certificate for /etc/mongod.conf.
cat mongodb.key mongodb.crt > mongodb.pem

# add restrictive permissions to all keys.
chmod 400 *.key
