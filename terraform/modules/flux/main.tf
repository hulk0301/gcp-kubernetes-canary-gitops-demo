resource "tls_private_key" "flux" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_namespace" "gitops" {
  metadata {
    name = "gitops"
  }
}

resource "kubernetes_secret" "flux-git-deploy" {
  metadata {
    name      = "flux-git-deploy"
    namespace = kubernetes_namespace.gitops.metadata.0.name
  }

  data = {
    identity = tls_private_key.flux.private_key_pem
  }
}

resource "helm_release" "flux" {
  name       = "fluxcd"
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  version    = "1.3.0"
  namespace  = kubernetes_namespace.gitops.metadata.0.name

  set {
    name  = "git.url"
    value = var.git_url
  }

  set {
    name  = "git.path"
    value = var.git_path
  }

  set {
    name  = "git.branch"
    value = var.git_branch
  }

  set {
    name  = "git.pollInterval"
    value = "1m"
  }

  set {
    name  = "git.secretName"
    value = kubernetes_secret.flux-git-deploy.metadata.0.name
  }

  set {
    name  = "git.ciSkip"
    value = "true"
  }

  set {
    name  = "registry.rps"
    value = 80
  }

  set {
    name  = "logFormat"
    value = "json"
  }

  set {
    name  = "crd.keep"
    value = "false"
  }

  set {
    name  = "ssh.known_hosts"
    value = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
  }

  set {
    name  = "syncGarbageCollection.enabled"
    value = "true"
  }
}

resource "helm_release" "helm-operator" {
  name       = "helm-operator"
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  version    = "1.1.0"

  namespace = kubernetes_namespace.gitops.metadata.0.name

  set {
    name  = "logFormat"
    value = "json"
  }

  set {
    name  = "helm.versions"
    value = "v3"
  }

  set {
    name  = "git.ssh.secretName"
    value = kubernetes_secret.flux-git-deploy.metadata.0.name
  }
}
