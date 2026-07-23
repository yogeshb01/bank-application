variable aws_region {
  description = "AWS region to deploy resources"
  default     = "us-west-1"
}

variable cluster_name {
  description = "Name of the EKS cluster"
  default     = "bankapp-eks-cluster"
}