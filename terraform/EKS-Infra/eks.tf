module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = "bankapp-eks-cluster"
  kubernetes_version = "1.33"

  addons = {
    coredns                = {
        most_recent = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {
        most_recent = true
    }
    vpc-cni                = {
      before_compute = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Allows you to connect to the cluster over the public internet via kubectl
  endpoint_public_access = true

  # Automatically grants your current AWS CLI identity administrative access to the cluster
  enable_cluster_creator_admin_permissions = true

  # Defines the traditional EC2 Managed Node Group
  eks_managed_node_groups = {
    standard_workers = {

      instance_types = ["c7i-flex.large"]
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 3
      desired_size = 2 # Starts the cluster with 2 worker nodes
    }
  }

  tags = {
    Environment = "Development"
    Terraform   = "true"
  }
}