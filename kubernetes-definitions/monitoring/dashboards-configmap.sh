#!/usr/bin/env bash
kubectl delete configmap grafana-dashboards-common --namespace=monitoring
kubectl delete configmap grafana-dashboards-eth --namespace=monitoring
kubectl delete configmap grafana-dashboards-etc --namespace=monitoring
kubectl create configmap grafana-dashboards-common --from-file=dashboards/ --namespace=monitoring
kubectl create configmap grafana-dashboards-eth --from-file=dashboards/ethereum --namespace=monitoring
kubectl create configmap grafana-dashboards-etc --from-file=dashboards/ethereum_classic --namespace=monitoring

kubectl delete configmap grafana-dashboards-exchanges --namespace=monitoring
kubectl create configmap grafana-dashboards-exchanges --from-file=dashboards/markets --namespace=monitoring

kubectl delete configmap grafana-dashboards-btc --namespace=monitoring
kubectl create configmap grafana-dashboards-btc --from-file=dashboards/bitcoin --namespace=monitoring

kubectl delete configmap grafana-dashboards-cluster --namespace=monitoring
kubectl create configmap grafana-dashboards-cluster --from-file=dashboards/cluster --namespace=monitoring