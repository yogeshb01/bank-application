# 1. Create Argo CD Namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# 2. Deploy Argo CD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "6.7.0"

  set = [
    {
      name  = "configs.params.server\\.insecure"
      value = "true"
    },
    {
      name  = "configs.params.server\\.rootpath"
      value = "/argocd"
    }
  ]
}

# 3. Create initial Shared Ingress for Argo CD
resource "kubernetes_ingress_v1" "argocd_ingress" {
  # Wait until AWS populates the status.load_balancer field before completing
  wait_for_load_balancer = true
  metadata {
    name      = "argocd-server-ingress"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/group.name"  = "shared-alb"
      "alb.ingress.kubernetes.io/group.order" = "1"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/argocd"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}