#!/bin/sh

DOMAIN=$1
if [ -z "$DOMAIN"]; then
   echo "Usage: start.sh <domain>"
   exit 1;
fi

# Generate self-signed TLS certs
if [ ! -f "certs/${DOMAIN}.cert" ]; then
   echo "Generating self-signed certificate for $DOMAIN"
   mkdir -p certs && \
   openssl genrsa 2048 > certs/${DOMAIN}.key && \
   openssl req -new -x509 -nodes -sha1 -days 3650 -subj "/C=US/ST=IL/L=Champaign/O=NCSA/OU=NDS/CN=*.$DOMAIN" -key "certs/${DOMAIN}.key" -out "certs/${DOMAIN}.cert"
fi

kubectl create secret generic tls-secret --from-file=tls.crt="certs/${DOMAIN}.cert" --from-file=tls.key="certs/${DOMAIN}.key" --namespace=default


cat ingress.yaml | sed -e "s#{\s*DOMAIN\s*}#$DOMAIN#g" | kubectl create -f -
kubectl create -f nginx-ilb.yaml
kubectl create -f nginx-webserver.yaml
kubectl create -f echoserver.yaml
kubectl create -f oauth2-proxy.yaml
