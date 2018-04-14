#!/usr/bin/env bash
kubectl delete configmap grafana-dashboards-common --namespace=monitoring
kubectl delete configmap grafana-dashboards-eth --namespace=monitoring
kubectl delete configmap grafana-dashboards-etc --namespace=monitoring
kubectl create configmap grafana-dashboards-common --from-file=dashboards/ --namespace=monitoring
kubectl create configmap grafana-dashboards-eth --from-file=dashboards/ethereum --namespace=monitoring
kubectl create configmap grafana-dashboards-etc --from-file=dashboards/ethereum_classic --namespace=monitoring

kubectl delete configmap grafana-dashboards-exchanges --namespace=monitoring
kubectl create configmap grafana-dashboards-exchanges --from-file=dashboards/markets --namespace=monitoring