# Cluster
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "Kubernetes version running on the cluster"
  value       = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for cluster authentication"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN (for IRSA if needed)"
  value       = module.eks.oidc_provider_arn
}

# Networking
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs (worker nodes)"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs (load balancers)"
  value       = module.vpc.public_subnets
}

# Quick connect command
output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}

# Raw Shared ALB Hostname
output "shared_alb_dns_name" {
  description = "AWS ALB Hostname provisioned for shared-alb"
  value       = kubernetes_ingress_v1.argocd_ingress.status[0].load_balancer[0].ingress[0].hostname
}

# Full Argo CD Access URL
output "argocd_url" {
  description = "Complete URL to access Argo CD UI"
  value       = "http://${kubernetes_ingress_v1.argocd_ingress.status[0].load_balancer[0].ingress[0].hostname}/argocd"
}