resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set = [
{
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    },
  {
    name  = "serviceAccount.create"
    value = "true"
  },
  {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  },
  {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.load_balancer_controller_role.iam_role_arn
  }
]

  depends_on = [module.eks]
}