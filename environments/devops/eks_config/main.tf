resource "helm_release" "metric-server" {
  name       = "metric-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace  = "monitoring"
  version    = "7.2.7"

  set {
    name  = "apiService.create"
    value = "true"
  }
  set {
    name  = "nameOverride"
    value = "metric-server"
  }
}

resource "helm_release" "kube-state-metrics" {
  name       = "kube-state-metrics"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kube-state-metrics"
  version    = "4.2.5"

  namespace        = "monitoring"
  create_namespace = true
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.15.1"

  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }
}

resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.8.1"

  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  depends_on = [
    helm_release.cert-manager
  ]
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"
  version    = "5.3.0"

  namespace        = "atlantis"
  create_namespace = true

    values = [
      templatefile("${path.module}/templates/atlantis_values.tpl", {
        user             = local.github_access_credentials.user
        token            = local.github_access_credentials.token
        secret           = local.github_access_credentials.secret
        hostname         = local.github_access_credentials.hostname
        allowed_repos    = var.repo
        storageClassName = "gp2"
      })
    ]
}