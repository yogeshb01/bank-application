# 🏦 Bank Application — Automated Infrastructure & Deployment

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/Cloud-AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)


A modern, cloud-native banking application engineered with automated infrastructure provisioning using **Terraform** and deployed on cloud containerized infrastructure.

---

## 📌 Project Overview

The **Bank Application** provides core digital banking functionality (user authentication, account management, transactions, and balance tracking) while demonstrating enterprise DevOps best practices. 

All underlying cloud infrastructure — including networking, compute clusters, security groups, and database instances — is fully automated, reproducible, and managed as code using **Terraform**.

---

## 🛠️ **Features**
- **User Registration & Authentication:** Create and log in with different users.  
- **Banking Operations:** Perform **deposits, withdrawals, and fund transfers**.  
- **Transaction History:** View and track all previous transactions.  
- **Continuous Delivery:** Automated deployment with **ArgoCD** and GitOps practices.  
- **Kubernetes Deployment:** Scalable and reliable deployment on **Amazon EKS**.  

## 🏗️ Architecture & Tech Stack

### DevOps & Infrastructure
* **Infrastructure as Code (IaC):** Terraform
* **Cloud Provider:** Amazon Web Services (AWS)
* **Containerization:** Docker
* **Orchestration:** Kubernetes (AWS EKS / ECS)
* **CI/CD Pipeline:** GitHub Actions / Jenkins

---

## 📁 Repository Structure

```text
bank-application/
├── terraform/                  # Infrastructure as Code (Terraform)
│   ├── main.tf                 # Primary Terraform entry point
│   ├── variables.tf            # Configurable variables
│   ├── outputs.tf              # Infrastructure outputs (IPs, URIs)
│   ├── providers.tf            # Cloud provider configurations
│   └── modules/                # Reusable Terraform modules
│       ├── vpc/                # Networking & Security Groups
│       ├── eks/                # Kubernetes Cluster (or EC2/ECS)
│       └── rds/                # Relational Database
├── app/                        # Application Source Code
│   ├── frontend/               # User interface source
│   └── backend/                # Application API source
├── kubernetes/                        # Kubernetes Manifests / Helm Charts
├── Dockerfile                  # Application containerization definition
└── README.md                   # Project documentation

```
---

## 🛠️ Prerequisites

Before you begin, ensure you have the following CLI tools installed and configured:

* [Git](https://git-scm.com/)
* [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.5.0+)
* [AWS CLI](https://aws.amazon.com/cli/) (Configured with credentials: `aws configure`)
* [Docker](https://www.docker.com/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

---

## 🚀 Step-by-Step Deployment Guide

---

### Step 1: Provision Infrastructure with Terraform

All AWS cloud infrastructure resources (VPC, EKS cluster, AWS Load Balancer Controller, and ArgoCD base manifests) are declared inside the `terraform/` directory.

```bash
# 1. Clone the repository
git clone [https://github.com/yogeshb01/bank-application.git](https://github.com/yogeshb01/bank-application.git)
cd bank-application

# 2. Navigate to the Terraform directory
cd terraform

# 3. Initialize Terraform plugins and backend
terraform init

# 4. Preview infrastructure plan
terraform plan

# 5. Provision the infrastructure on AWS
terraform apply
```


> 💡 **Note**
>
> Confirm the prompt with `yes` to execute provisioning.

Once complete, update your local kubeconfig:

```bash
aws eks update-kubeconfig --region <your-aws-region> --name <cluster-name>
```

---

# 🌐 Step 2: Accessing ArgoCD via AWS Application Load Balancer (ALB)

Access the dashboard directly through your AWS load balancer endpoint.

### 1️⃣ Retrieve the ArgoCD ALB DNS Name

```bash
kubectl get ingress argocd-server-ingress -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

### 2️⃣ Retrieve the Admin Password

Fetch initial admin secret:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### 3️⃣ Log In to ArgoCD

**a)** Open the retrieved ALB DNS URL (e.g., `k8s-argocd-xxxxxx.us-east-1.elb.amazonaws.com`) in your browser.

**b)** Log in with:

- **Username:** `admin`
- **Password:** *(Retrieved from Step 2.2)*

---

# 🚀 Step 3: Deploying the Application via ArgoCD GitOps

## 📌 Option A: Apply Declarative GitOps Manifest

Apply the root Application manifest to configure ArgoCD:

```bash
kubectl apply -f argocd-app.yaml
```

**Example `argocd-app.yaml`:**

```bash
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: bank-application
  namespace: argocd
spec:
  project: default
  source:
    repoURL: '[https://github.com/yogeshb01/bank-application.git](https://github.com/yogeshb01/bank-application.git)'
    targetRevision: HEAD
    path: kubernetes
  destination:
    server: '[https://kubernetes.default.svc](https://kubernetes.default.svc)'
    namespace: bank-app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

---

## 🌐 Option B: Register via ArgoCD Web UI (Recommended)

In the **ArgoCD dashboard**, create a new application with the following configuration:

- **App Name:** `bank-app`
- **Project:** `default`
- **Sync Policy:** `Automatic`
- **Repo URL:** `https://github.com/yogeshb01/bank-application.git`
- **Path:** `kubernetes`
- **Cluster URL:** `https://kubernetes.default.svc`
- **Namespace:** `bankapp-namespace`

Click **Create App** and wait for the deployment to complete.

---

# ✅ Step 4: Accessing the Live Banking Application

Once ArgoCD finishes syncing, the AWS Load Balancer Controller automatically provisions a dedicated AWS ALB for public user access.

Retrieve the Banking Application's public ALB DNS:

```bash
kubectl get ingress bank-app-ingress -n bank-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

---

## 🎯 **Testing the Application**
- **Register a user** and log in.  
- Perform operations like **deposits, withdrawals, and transfers**.  
- Check the **transaction history** to verify the transactions.  

---

## 🚀 **Project Expansion Ideas**
- **Add AWS RDS:** Replace the local MySQL container with an **AWS RDS instance** for better scalability.  
- **CI/CD Integration:** Automate Docker image builds and deployments using **GitHub Actions or Jenkins**.  
- **Monitoring and Logging:** Add **Prometheus and Grafana** for monitoring and **Fluentd or Loki** for logging.  

---

## 🎯 **Contributing**
Feel free to contribute to this project by:  
- Submitting issues and pull requests.  
- Improving the deployment or adding new features.  

---

## 🛠️ **Author**
**👤 Yogesh Bharambe**    
- 🐙 [GitHub](https://github.com/yogeshb01)  
- 💼 [LinkedIn](https://www.linkedin.com/in/pravesh-sudha/)  

---

## 📜 **License**
This project is licensed under the **MIT License**.  

---

✅ **Star the repo** ⭐ if you find it helpful!  
🔥 **Happy Coding!** 🚀
