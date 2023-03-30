resource "helm_release" "argo_cd" {
  name = "argo-cd"

  repository          = "https://argoproj.github.io/argo-helm"

  chart     = "argo-cd"
  version   = "5.24.4"
  namespace = "argo-cd"
  create_namespace = true
  timeout   = 1200

  values = [local.additional_yaml_config]
}