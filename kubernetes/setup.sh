#!/bin/bash

while getopts u:p:h:n: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) password=${OPTARG};;
        h) hostname=${OPTARG};;
        n) cluster_name=${OPTARG};;
    esac
done
port="3306"

echo "Updating kubeconfig with new cluster name"
aws eks --region eu-west-1 update-kubeconfig --name ${cluster_name}

echo
echo "Setting backend-deployment.yaml with the correct environment variables..."
sed -i "s/default_hostname/${hostname}/g; s/default_port/${port}/g; s/default_username/${username}/g; s/default_password/${password}/g" ./backend/backend-deployment.yaml

echo
echo "Deploying backend deployments & clusterIp service"
kubectl apply -f ./backend/backend-deployment.yaml
kubectl apply -f ./backend/backend-cluster-ip.yaml

echo
echo "Deploying frontend deployments & clusterIp service"
kubectl apply -f ./frontend/frontend-deployment.yaml
kubectl apply -f ./frontend/frontend-cluster-ip.yaml

echo
echo "Wait for 5s before checking results..."
sleep 5s

echo
echo "Checking current services, deployments & pods"
echo
kubectl get svc
echo
kubectl get deployments
echo
kubectl get pods

echo
echo "Storing cluster IPs to be used for nginx.conf"
backend_cluster_ip=$(kubectl describe svc/backend-service-cluster-ip | grep IP: | awk '{print $2;}')
frontend_cluster_ip=$(kubectl describe svc/frontend-service-cluster-ip | grep IP: | awk '{print $2;}')

echo
echo "Populating nginx.conf with the correct cluster IPs required for reverse proxy"
sed -i "s/backend_cluster_ip/${backend_cluster_ip}/g; s/frontend_cluster_ip/${frontend_cluster_ip}/g" ./reverse-proxy/nginx-config-map.yaml

echo
echo "Deploying nginx reverse proxy config maps, deployments, and load balancer"
kubectl apply -f ./reverse-proxy/nginx-config-map.yaml
kubectl apply -f ./reverse-proxy/nginx-deployment.yaml
kubectl apply -f ./reverse-proxy/nginx-lb.yaml

sleep 5s
echo
echo "Running kubectl get svc"
kubectl get svc

exit 0
