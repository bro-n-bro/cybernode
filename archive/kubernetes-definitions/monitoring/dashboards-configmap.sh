#!/usr/bin/env bash
kubectl delete configmap grafana-dashboards-common --namespace=monitoring
kubectl delete configmap grafana-dashboards-chains --namespace=monitoring
kubectl delete configmap grafana-dashboards-cluster --namespace=monitoring
kubectl delete configmap grafana-dashboards-exchanges --namespace=monitoring



kubectl create configmap grafana-dashboards-common --from-file=dashboards/ --namespace=monitoring
kubectl create configmap grafana-dashboards-chains --from-file=dashboards/chains --namespace=monitoring
kubectl create configmap grafana-dashboards-cluster --from-file=dashboards/cluster --namespace=monitoring
kubectl create configmap grafana-dashboards-exchanges --from-file=dashboards/markets --namespace=monitoring