resource "helm_release" "argo_cd" {
  name = "argo-cd"

  repository          = "https://argoproj.github.io/argo-helm"

  chart     = "argo-cd"
  version   = "5.24.4"
  namespace = "argo-cd"
  create_namespace = true
  timeout   = 1200

  values = [var.app_additional_yaml_config]
}

resource "helm_release" "argo_app" {
  name  = "argocd-apps"
  chart = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argo-cd"
  depends_on = [resource.helm_release.argo_cd]
  values = [
    var.argocd_app_config
  ]
}



#data "template_file" "init" {
#  template = "${file("${path.module}/rbac.tftpl")}"
#  vars = {
#    rules = local.flattened_map
#  }
#}


