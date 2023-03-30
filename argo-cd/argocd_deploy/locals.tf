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

temp = format("%s",var.app_additional_yaml_config,)


}