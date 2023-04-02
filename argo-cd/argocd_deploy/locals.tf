locals {
    additional_yaml_config = <<EOF
server:
  rbacConfig:
    policy.csv: |
      p, role:aditya_role, applications, get, */*, allow
      p, role:aditya_role, applications, sync, */*, allow
      p, role:aditya_role, applications, action/apps/Deployment/restart, */*, allow
      g, aditya, role:aditya_role
EOF



local_var = yamldecode(var.app_additional_yaml_config)

#policy_var = lookup(local_var,"server",null) == null ? null : lookup()

aditya = concat([yamldecode(var.app_additional_yaml_config)],[yamldecode(local.additional_yaml_config)])

flattened_map = flatten([
    for server, rbacConfig in local.local_var : [
      for policy,rules in rbacConfig:[
        rules
      ]
    ]
  ])

#actual_value = lookup(local.temp,"server","null") == null ? null : 

}