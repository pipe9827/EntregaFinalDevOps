#!/bin/bash
# This script applies all the Kubernetes configurations for the microservices.

kubectl apply -f configmap.yml

#configserver
kubectl apply -f configserver/deployment.yml
kubectl apply -f configserver/service.yml

#eurekaserver
kubectl apply -f eurekaserver/deployment.yml
kubectl apply -f eurekaserver/service.yml

#gatewayserver
kubectl apply -f gatewayserver/deployment.yml
kubectl apply -f gatewayserver/service.yml

#accounts
kubectl apply -f accounts/deployment.yml
kubectl apply -f accounts/service.yml

#loans
kubectl apply -f loans/deployment.yml
kubectl apply -f loans/service.yml

#cards
kubectl apply -f cards/deployment.yml
kubectl apply -f cards/service.yml