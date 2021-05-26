#!/bin/bash

kubectl delete svc nginx-lb
kubectl delete svc backend-service-cluster-ip
kubectl delete svc frontend-service-cluster-ip

kubectl delete --all configmap
kubectl delete --all deployments

exit 0
