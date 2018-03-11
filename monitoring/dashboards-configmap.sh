#!/usr/bin/env bash
kubectl delete configmap grafana-dashboards --namespace=monitoring
kubectl create configmap grafana-dashboards --from-file=dashboards/ --namespace=monitoring
