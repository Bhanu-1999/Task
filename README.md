✅ Kubernetes Cluster Setup (Single Node)
Created an EC2 t3.medium with 2 CPU and 20GB Ubuntu 22.04.

🔧 1. System Preparation
Configured the system with required kernel modules, disabled swap, and applied sysctl values.

🐳 2. Install Container Runtime (containerd)
Installed containerd and enabled the systemd cgroup driver.

☸️ 3. Install Kubernetes Tools
Installed the following components from the Kubernetes repository:

kubeadm: Cluster initializer

kubelet: Node agent

kubectl: CLI for managing the cluster

🚀 4. Initialize the Cluster
Initialized the Kubernetes control plane using kubeadm with Calico-compatible pod CIDR (192.168.0.0/16). After initialization:

Configured kubectl access for the current user

🌐 5. Configured Network Add-on (Calico)
Deployed the Calico CNI plugin to enable pod networking.

🟢 6. Enable Master Node Scheduling
Allowed the master node to schedule workloads (since this is a single-node setup).

✅ 7. Verification
Ran the following commands to verify successful installation:

kubectl get nodes
kubectl get pods -A

<img width="764" height="217" alt="image" src="https://github.com/user-attachments/assets/72928ad5-e806-445a-aca5-fd257ea87dd7" />


🐘 PostgreSQL Deployment
This step sets up a standalone PostgreSQL instance inside the Kubernetes cluster using a StatefulSet, PersistentVolumeClaim, and a ClusterIP service. It is securely configured with credentials, persistent storage, resource limits, health probes, and an automation script.

⚙️ Key Components
🔐 Secret – Stores database credentials (username, password, and database name)
📦 PVC – Ensures PostgreSQL data is stored persistently
🧱 StatefulSet – Manages the PostgreSQL pod with stable identity and storage
🌐 ClusterIP Service – Internal-only service with stable DNS for PostgreSQL access

💡 Enhancements Added
✅ Liveness Probe – Automatically restarts the pod if PostgreSQL becomes unresponsive
✅ Readiness Probe – Ensures PostgreSQL is ready before exposing to other services
✅ Resource Requests & Limits – Controls CPU and memory usage for stability

✅ Verification
The following commands were used to validate the PostgreSQL deployment:

kubectl get pods -l app=postgres
kubectl exec -it postgres-0 -- psql -U keycloak -d keycloakdb

<img width="940" height="194" alt="image" src="https://github.com/user-attachments/assets/97aeaca4-f014-4658-bd36-acf55687ffa6" />


<img width="479" height="250" alt="image" src="https://github.com/user-attachments/assets/8e9e7137-8c33-4851-9488-cec348dff98d" />



🔐 Keycloak Deployment (Integrated with PostgreSQL)
Deployment of Keycloak in a single-node Kubernetes cluster, connected to the previously deployed PostgreSQL instance, and exposed securely using a NodePort-based HTTPS setup.

🚀 1. Keycloak Deployment
Keycloak was deployed using the official image quay.io/keycloak/keycloak:21.1.1 in development mode (start-dev). Environment variables were configured to connect with PostgreSQL via secrets.

The deployment includes:

Admin user and password setup

Database host, username, password, and name configuration using Kubernetes secrets

Container exposed on port 8080 internally

🌐 2. Service Configuration
A NodePort service was created to expose Keycloak on port 31319.

📦 3. Applying Manifests
Manifests used:

kubectl apply -f keycloak-deployment.yaml
kubectl apply -f keycloak-hpa.yaml
kubectl apply -f keycloak-service.yaml
kubectl apply -f keycloak-ingress.yaml

✅ 4. Verification
Checked that the Keycloak pod and services are running:
kubectl get pods -l app=keycloak
kubectl get svc keycloak

📡 5. Host Access
Keycloak was accessed through the NodePort using a self-signed TLS certificate:

Self-signed certificate generated using openssl

TLS secret created in Kubernetes

Host entry added in /etc/hosts: <EC2_PUBLIC_IP> keycloak.local

🌍 6. Accessing Keycloak
Accessed via HTTPS using NodePort:

✅ In Browser:
https://keycloak.local:31319

<img width="1911" height="984" alt="Screenshot 2025-07-11 115224" src="https://github.com/user-attachments/assets/797ce93b-289c-45f7-a74e-cae74ee69a8f" />

<img width="959" height="470" alt="image" src="https://github.com/user-attachments/assets/6559e1ec-1e3c-4f94-b377-7b98999f7ae2" />

<img width="958" height="471" alt="image" src="https://github.com/user-attachments/assets/cfa995ae-a0f5-483c-b265-f83ad64c3ba2" />

🧰 Dashboard Installation
The official Kubernetes Dashboard components were deployed into the kubernetes-dashboard namespace:

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.8.0/aio/deploy/recommended.yaml

👤 2. Admin Access Configuration
To access the dashboard with admin privileges, a ServiceAccount and ClusterRoleBinding were created:
kubectl apply -f dashboard-adminuser.yaml

🔑 3. Generate Bearer Token
A token was generated to authenticate with the dashboard UI:
kubectl -n kubernetes-dashboard create token admin-user

🔐 4. Secure Exposure via NodePort + Self-Signed TLS
The dashboard service was accessed securely using HTTPS via a NodePort:

A self-signed TLS certificate was generated using openssl

TLS secret created in kubernetes-dashboard namespace

Ingress configured with host: dashboard.local

🌐 5. Local DNS Resolution
The local machine’s /etc/hosts was updated to route dashboard.local to the EC2 public IP:
<EC2_PUBLIC_IP> dashboard.local
This enabled browser access using the custom domain.

✅ 6. Accessing the Dashboard
Dashboard UI was successfully accessed via:
https://dashboard.local:30595
Login was done using the bearer token generated in Step 3.

<img width="944" height="454" alt="image" src="https://github.com/user-attachments/assets/3f83cb92-42e9-4b92-a867-3d11af9cc2a3" />

<img width="950" height="470" alt="image" src="https://github.com/user-attachments/assets/fd26d68e-0d0d-45f4-8953-33d295b4565b" />

<img width="956" height="469" alt="image" src="https://github.com/user-attachments/assets/19d39692-9928-458c-988f-0196eda6b62d" />

<img width="946" height="361" alt="image" src="https://github.com/user-attachments/assets/71732a60-4b4e-49d8-8ebd-b6f642d03f96" />

<img width="946" height="467" alt="image" src="https://github.com/user-attachments/assets/62a3cd6b-767b-41c4-b7fc-c4949f83e906" />

🛡️ OAuth2 Proxy Secured Whoami Application with Keycloak OIDC Integration
🔹 What it is:
A simple Whoami app secured by OAuth2 Proxy using Keycloak as the OpenID Connect (OIDC) identity provider.

🔎 Architecture Overview
🖥️ Whoami App — Minimal HTTP service showing request info (for testing auth).

🔐 OAuth2 Proxy — Auth proxy validating users via Keycloak OIDC tokens.

🔑 Keycloak — Central authentication provider issuing OAuth2/OIDC tokens.

☸️ Kubernetes Deployment — Both apps run as pods exposed externally.

🚪 Exposure & Access
🔌 NodePort Service — OAuth2 Proxy is exposed via NodePort (30180) on the Kubernetes node.

🌐 Hostnames configured in /etc/hosts like oauth2-proxy.local and whoami.local pointing to the cluster IP for convenience.

🔒 TLS — HTTPS enabled on OAuth2 Proxy using self-signed certificates.

⚙️ How It Works
User accesses https:<EC2_PUBLIC_IP>//:30180)

OAuth2 Proxy redirects unauthenticated users to Keycloak login.

After login, Keycloak issues a token which OAuth2 Proxy validates.

Authenticated requests are forwarded to Whoami with user info headers.

Whoami responds confirming authenticated access.

<img width="957" height="260" alt="image" src="https://github.com/user-attachments/assets/564d6945-4f19-46e8-a142-6d24944bc648" />





