#!/bin/sh

kubectl delete secret  tls-secret 


kubectl delete -f nginx-ilb.yaml
kubectl delete -f ingress.yaml
kubectl delete -f nginx-webserver.yaml
kubectl delete -f echoserver.yaml
kubectl delete -f oauth2-proxy.yaml
