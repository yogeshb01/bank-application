#!/bin/bash

# 1. Prevent interactive prompt freezes
export DEBIAN_FRONTEND=noninteractive

# Wait for any background automatic system updates to release lock files
while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "Waiting for other package managers to finish..."
    sleep 5
done

# 2. Update system and install basic core tools
sudo apt-get update -y
sudo apt-get install -y wget apt-transport-https gnupg lsb-release snapd curl

# 3. Install Docker 
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# 4. Set permissions so the 'ubuntu' user can use Docker without sudo
sudo usermod -aG docker ubuntu

# 5. Create a persistent volume directory on the host machine 
# This ensures you don't lose your Jenkins data/jobs if the container restarts!
sudo mkdir -p /var/jenkins_home
sudo chown -R 1000:1000 /var/jenkins_home

# 6. Run Jenkins as a Docker Container
# We mount the Docker socket so Jenkins can build Docker images inside your CI pipeline (Docker-in-Docker)
sudo docker run -d \
  --name jenkins-server \
  --restart always \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /var/jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

# 7. Install other tools on the host system (Trivy, AWS CLI, Helm, Kubectl)
# Trivy Setup
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y && sudo apt-get install -y trivy

# Snap Apps
sudo snap install aws-cli --classic
sudo snap install helm --classic
sudo snap install kubectl --classic

# ArgoCD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64