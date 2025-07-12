#!/bin/bash

echo "[+] Creating PostgreSQL Secret"
kubectl apply -f k8s/postgres-secret.yaml

echo "[+] Creating Persistent Volume"
kubectl apply -f k8s/postgres-pv.yaml

echo "[+] Creating Persistent Volume Claim"
kubectl apply -f k8s/postgres-pvc.yaml

echo "[+] Creating Service"
kubectl apply -f k8s/postgres-service.yaml

echo "[+] Creating StatefulSet"
kubectl apply -f k8s/postgres-statefulset.yaml

echo "[✔] PostgreSQL Deployment Complete"
