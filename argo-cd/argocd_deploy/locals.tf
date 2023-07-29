#flattened_map = flatten([
#    for server, rbacConfig in local.aditya : [
#      for policy,rules in rbacConfig:[
#        rules
#      ]
#    ]
#  ])
locals {
  app_names = ["carbon","restwsss"]
    additional_yaml_config = <<EOT
server:
  rbacConfig:
    policy.csv: |
      p, role:aditya_role, applications, get, */*, allow
      p, role:aditya_role, applications, sync, */*, allow
      #p, role:aditya_role, applications, action/apps/Deployment/restart, */*, allow
      g, aditya, role:aditya_role
EOT

app_rbac = try(yamldecode(var.app_additional_yaml_config)["server"]["rbacConfig"]["policy.csv"] != null, false)

rbac_policy =  local.app_rbac == true ? join("",[yamldecode(local.additional_yaml_config)["server"]["rbacConfig"]["policy.csv"]],[yamldecode(var.app_additional_yaml_config)["server"]["rbacConfig"]["policy.csv"]]): join("",[yamldecode(local.additional_yaml_config)["server"]["rbacConfig"]["policy.csv"]])

gen_rbac_policy = <<EOF
server:
  rbacConfig:
    policy.csv: |
      ${indent(6,local.rbac_policy)}
EOF
}