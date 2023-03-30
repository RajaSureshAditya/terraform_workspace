module "argo_cd" {
  source = "./argocd_deploy"
  app_additional_yaml_config = local.app_additional_yaml_config
}

output "local_temp" {
    value = module.argo_cd
}