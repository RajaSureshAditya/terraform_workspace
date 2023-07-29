module "argo_cd" {
  source = "./argocd_deploy"
  app_additional_yaml_config = local.app_additional_yaml_config
  argocd_app_config = local.argocd_app_config
}

output "local_temp" {
    value = module.argo_cd
}