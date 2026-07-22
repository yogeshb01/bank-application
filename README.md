# 🚀 **Spring Boot Bank Application - EKS Deployment with ArgoCD**

Welcome to the **Spring Boot Bank Application**! This project demonstrates how to deploy a **Spring Boot-based Bank Application** with **MySQL** as the database on an **Amazon EKS cluster** using **ArgoCD** for continuous delivery.

---

## 🛠️ **Features**
- **User Registration & Authentication:** Create and log in with different users.  
- **Banking Operations:** Perform **deposits, withdrawals, and fund transfers**.  
- **Transaction History:** View and track all previous transactions.  
- **Continuous Delivery:** Automated deployment with **ArgoCD** and GitOps practices.  
- **Kubernetes Deployment:** Scalable and reliable deployment on **Amazon EKS**.  

---

## ✅ **Tech Stack**
- **Backend:** Spring Boot  
- **Database:** MySQL  
- **Containerization:** Docker, Docker Compose  
- **Orchestration:** Kubernetes (EKS)  
- **Continuous Delivery:** ArgoCD  
- **Cloud Provider:** AWS  

---

## 📂 **Folder Structure**
```
├── docker-compose.yml         # Docker Compose file for local testing
├── Dockerfile                 # Dockerfile to build the bank-app image
├── kubernetes                 # Kubernetes manifests for EKS deployment
│   ├── deployment.yaml        # Bank app deployment configuration
│   ├── service.yaml           # Kubernetes service for the bank-app
│   └── mysql-configmap.yaml   # MySQL configuration for the application
├── src                        # Spring Boot source code
├── README.md                  # Project documentation
└── pom.xml                    # Maven dependencies configuration
```

---

## ⚙️ **Prerequisites**
Before running this project, make sure you have the following installed:  
- **Docker** and **Docker Compose**  
- **AWS CLI** configured with an IAM user  
- **Kubectl** and **eksctl** installed  
- Basic knowledge of **Docker and Kubernetes**

---

## 🚀 **Local Setup & Testing**

### 🔥 **Step 1: Clone the Repository**
```bash
git clone https://github.com/Pravesh-Sudha/Springboot-BankApp.git
cd Springboot-BankApp
```

### 🔥 **Step 2: Run the App Locally with Docker**
Start the app using Docker Compose:
```bash
docker-compose up --build
```

Once the app is running, access it at:
```
http://localhost:8080
```

✅ **Test the application:**  
- Register a new user.  
- Log in and perform operations like **deposit, withdraw, and transfer**.  
- Check the **transaction history**.  

---

## ☁️ **Deploying on AWS EKS with ArgoCD**

### 🔥 **Step 1: Create an EKS Cluster**
Run the following commands to create the cluster and node group:
```bash
eksctl create cluster --name=bankapp \
                      --region=us-west-1 \
                      --version=1.30 \
                      --without-nodegroup

eksctl utils associate-iam-oidc-provider \
  --region us-west-1 \
  --cluster bankapp \
  --approve

eksctl create nodegroup --cluster=bankapp \
                        --region=us-west-1 \
                        --name=bankapp \
                        --node-type=t2.medium \
                        --nodes=2 \
                        --nodes-min=2 \
                        --nodes-max=2 \
                        --node-volume-size=29 \
                        --ssh-access \
                        --ssh-public-key=default-ec2
```

### 🔥 **Step 2: Configure Kubectl to Use the EKS Cluster**
```bash
aws eks update-kubeconfig --region us-west-1 --name bankapp
```

### 🔥 **Step 3: Install ArgoCD**
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Change ArgoCD server service type to LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

✅ **Access the ArgoCD dashboard:**  
Get the **external IP**:
```bash
kubectl get svc -n argocd
```
Get the **admin password**:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Login to the ArgoCD dashboard at:
```
http://<EXTERNAL-IP>
```

---

### 🔥 **Step 4: Deploy the Bank Application with ArgoCD**

In the **ArgoCD dashboard**, create a new application with the following configuration:  
- **App Name:** `bank-app`  
- **Project:** `default`  
- **Sync Policy:** Automatic  
- **Repo URL:** `https://github.com/Pravesh-Sudha/Springboot-BankApp.git`  
- **Path:** `kubernetes`  
- **Cluster URL:** `https://kubernetes.default.svc`  
- **Namespace:** `bankapp-namespace`  

Click **Create App** and wait for the deployment to complete.

---

### 🔥 **Step 5: Access the Bank Application**

Once deployed, get the service details:
```bash
kubectl get svc -n bankapp-namespace
```

✅ **Access the Bank Application:**  
- Go to the **EC2 dashboard** and copy the **public IP** of a worker node.  
- Access the app by combining the **public IP and NodePort**, e.g.:  
```
http://<EC2-PUBLIC-IP>:<NODE-PORT>
http://54.183.241.73:30776/login
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
**👤 Pravesh Sudha**  
- 🌐 [Website](https://praveshsudha.com)  
- 📝 [Blog](https://blog.praveshsudha.com)  
- 🐙 [GitHub](https://github.com/Pravesh-Sudha)  
- 🐦 [Twitter](https://x.com/praveshstwt)  
- 💼 [LinkedIn](https://www.linkedin.com/in/pravesh-sudha/)  

---

## 📜 **License**
This project is licensed under the **MIT License**.  

---

✅ **Star the repo** ⭐ if you find it helpful!  
🔥 **Happy Coding!** 🚀
