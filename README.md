# 🧰 Self-Managed Kubernetes Cluster on AWS

This  project automates the provisioning and configuration of a **production-ready, self-managed Kubernetes cluster** on AWS using Infrastructure as Code and modern DevOps tooling.

---

## 🚀 Overview

A robust, reproducible setup that deploys a Kubernetes cluster (control plane + worker nodes) using:

- **Terraform**: AWS infrastructure provisioning (VPC, EC2, IAM, S3, etc.)
- **Ansible**: OS-level configuration and Kubernetes setup
- **GitHub Actions**: CI/CD pipeline for infrastructure and cluster provisioning
- **HashiCorp Vault**: Secure secret storage and Kubernetes token distribution
- **Kubeadm / Kubelet / Kubectl**: Kubernetes components for bootstrapping and management
- **Container Runtime**: `containerd` + `runc` + `CNI`
- **CNI Plugin**: Calico for Kubernetes networking
- **AWS EC2**: Control plane and worker nodes (RHEL)

---

## 🧱 Architecture
```
[GitHub Actions] → Terraform → AWS Infrastructure ↓ Ansible Provisioning ↓ Kubernetes Cluster Bootstrapped via kubeadm ↓ Calico CNI for Networking, Vault for Secrets
```
### ✅ Stack Details

| Component        | Tool / Service           |
|------------------|--------------------------|
| IaC              | Terraform                |
| Configuration    | Ansible                  |
| CI/CD            | GitHub Actions           |
| Secrets Mgmt     | HashiCorp Vault          |
| Cloud Platform   | AWS (EC2 + VPC)          |
| OS               | RHEL                     |
| Kubernetes Tools | kubeadm, kubelet, kubectl|
| Runtime          | containerd, runc         |
| Networking       | Calico (CNI)             |

---

## 📂 Project Structure
```
├── terraform/ # AWS infrastructure modules ├── ansible/ # Cluster setup and provisioning ├── github-actions/ # CI/CD workflows ├── vault/ # Vault setup and Kubernetes token storage ├── scripts/ # Helper scripts ├── README.md # This file └── LICENSE # GNU GPL v3
```

---

## 🔐 Vault Integration

- Kubernetes tokens and certificates are securely stored in **HashiCorp Vault**
- Ansible retrieves secrets from Vault during provisioning
- GitHub Actions uses Vault for sensitive variables

---

## ⚙️ CI/CD Workflow

1. Push to main triggers GitHub Actions
2. Terraform applies AWS infrastructure
3. Ansible installs and configures Kubernetes
4. Vault handles tokens/keys
5. Cluster is ready for workloads

---

## 📦 Prerequisites

- AWS CLI & credentials
- Terraform v1.5+
- Ansible v2.14+
- GitHub repository with Actions enabled
- HashiCorp Vault setup (can be local or AWS)
- SSH key for EC2 access

---

### 🧪 Future Improvements

- Add Prometheus & Grafana for observability

- Autoscaling with Cluster Autoscaler

- Ingress Controller (NGINX or Traefik)

- Helm charts for app deployment

- Multi-node HA control plane

### 📜 License

This project is licensed under the GNU General Public License v3.0.