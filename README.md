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
├── Dockerfile
├── Jenkinsfile
├── README.md			 # Project documentation
├── app-code
├── kubernetes
└── terraform
    ├── EKS-Infra
    │   ├── argocd.tf
    │   ├── eks.tf
    │   ├── helm.tf
    │   ├── iam.tf
    │   ├── output.tf
    │   ├── providers.tf
    │   ├── variable.tf
    │   └── vpc.tf
    └── Jenkins-Server
        ├── ec2.tf
        ├── install_tools.sh
        ├── outputs.tf
        ├── provider.tf
        └── var.tf              

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

# 🚀 Step-by-Step Deployment Guide

---

### Step 1: Provision Infrastructure with Terraform

All AWS cloud infrastructure resources (VPC, EKS cluster, AWS Load Balancer Controller, and ArgoCD base manifests) are declared inside the `terraform/` directory.

```bash
# 1. Clone the repository
git clone [https://github.com/yogeshb01/bank-application.git](https://github.com/yogeshb01/bank-application.git)
cd bank-application

# 2. Navigate to the Terraform directory
cd terraform/EKS-Infra

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

## 🌐 Step 2: Accessing ArgoCD via AWS Application Load Balancer (ALB)

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

## 🚀 Step 3: Deploying the Application via ArgoCD GitOps

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

## ✅ Step 4: Accessing the Live Banking Application

Once ArgoCD finishes syncing, the AWS Load Balancer Controller automatically provisions a dedicated AWS ALB for public user access.

Retrieve the Banking Application's public ALB DNS:

```bash
kubectl get ingress bank-app-ingress -n bank-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

```bash
http://<SHARED-ALB>.elb.amazonaws.com/argocd
```

---

## 🎯 **Testing the Application**
- **Register a user** and log in.  
- Perform operations like **deposits, withdrawals, and transfers**.  
- Check the **transaction history** to verify the transactions.  

---

# 🤖 Jenkins Setup Steps 

Jenkins is responsible for automating the complete Continuous Integration and Continuous Deployment (CI/CD) pipeline.

```bash
# 1. Clone the repository
git clone https://github.com/yogeshb01/bank-application.git
cd bank-application

# 2. Navigate to the Terraform directory
cd terraform/Jenkins-Server

# 3. Initialize Terraform plugins and backend
terraform init

# 4. Preview infrastructure plan
terraform plan

# 5. Provision the infrastructure on AWS
terraform apply
```
## Steps to Access Jenkins & Install Plugins

#### 1. **Open Jenkins in Browser:**
> Use your public IP with port 8081:
>**http://<public_IP>:8081**

#### 2. **Initial Admin password:**
> Start the service and get the Jenkins initial admin password:
> ```bash
> sudo docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
> ```

#### 3. **Start Jenkins Container(*If Not Running*):**
> Get the Jenkins initial admin password:
> ```bash
> docker ps
> ```
#### 4. **Install Essential Plugins:**
> - Navigate to:
> **Manage Jenkins → Plugins → Available Plugins**<br/>
> - Search and install the following:<br/>
>   - **Docker Pipeline**<br/>
>   - **Pipeline View**


#### 5. **Set Up Docker & GitHub Credentials in Jenkins (Global Credentials)**<br/>
>
> - GitHub Credentials:
>   - Go to:
**Jenkins → Manage Jenkins → Credentials → (Global) → Add Credentials**
> - Use:
>   - Kind: **Username with password**
>   - ID: **github-credentials**<br/>


> - DockerHub Credentials:
> Go to the same Global Credentials section
> - Use:
>   - Kind: **Username with password**
>   - ID: **docker-hub-credentials**
> [Notes:]
> Use these IDs in your Jenkins pipeline for secure access to GitHub and DockerHub

#### 6. Jenkins Shared Library Setup:
> - `Configure Trusted Pipeline Library`:
>   - Go to:
> **Jenkins → Manage Jenkins → Configure System**
> Scroll to Global Pipeline Libraries section
>
> - **Add a New Shared Library:** 
> - **Name:** shared
> - **Default Version:** main
> - **Project Repository URL:** `https://github.com/<your user-name/jenkins-shared-libraries`.
>
> [Notes:] 
> Make sure the repo contains a proper directory structure eq: vars/<br/>
	
#### 7. Setup Pipeline<br/>
> - Create New Pipeline Job<br/>
>   - **Name:** Bank-Application<br/>
>   - **Type:** Pipeline<br/>
> Press `Okay`<br/>

> > In **General**<br/>
> > - **Description:** Bank-Application<br/>
> > - **Check the box:** `GitHub project`<br/>
> > - **GitHub Repo URL:** `https://github.com/<your user-name/bank-application`<br/>
>
> > In **Trigger**<br/>
> > - **Check the box:**`GitHub hook trigger for GITScm polling`<br/>
>
> > In **Pipeline**<br/>
> > - **Definition:** `Pipeline script from SCM`<br/>
> > - **SCM:** `Git`<br/>
> > - **Repository URL:** `https://github.com/<your user-name/bank-application`<br/>
> > - **Credentials:** `github-credentials`<br/>
> > - **Branch:** master<br/>
> > - **Script Path:** `Jenkinsfile`<br/>

#### **Fork Required Repos**<br/>
> > Fork App Repo:<br/>
> > * Open the `Jenkinsfile`<br/>
> > * Change the DockerHub username to yours<br/>
>
> > **Fork Shared Library Repo:**<br/>
> > * Edit `vars/update_k8s_manifest.groovy`<br/>
> > * Update with your `DockerHub username`<br/>
> 
> > **Setup Webhook**<br/>
> > In GitHub:<br/>
> >  * Go to **`Settings` → `Webhooks`**<br/>
> >  * Add a new webhook pointing to your Jenkins URL<br/>
> >  * Select: **`GitHub hook trigger for GITScm polling`** in Jenkins job<br/>
>
> > **Trigger the Pipeline**<br/>
> > Click **`Build Now`** in Jenkins


## 🚀 **Project Expansion Ideas**
- **Add AWS RDS:** Replace the local MySQL container with an **AWS RDS instance** for better scalability.  
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
