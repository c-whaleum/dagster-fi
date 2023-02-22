#!/bin/bash
#kubectl config view --raw > ~/.kube/config
minikube start
minikube addons enable ingress
# Run this to forward to localhost in the background
nohup kubectl port-forward --pod-running-timeout=24h -n ingress-nginx service/ingress-nginx-controller :80 &

# Cleanup stale namespaces
kubectl get namespaces --no-headers=true -o custom-columns=:metadata.name | grep dagster | xargs kubectl delete namespace

helm repo add dagster https://dagster-io.github.io/helm
helm install dagster/dagster \
    --generate-name \
    --namespace dagster \
    --create-namespace

