locals {
    app_additional_yaml_config = <<EOF
server:
  rbacConfig:
    policy.csv: |
      p, role:raja_role, applications, get, */*, allow
      p, role:raja_role, applications, sync, */*, allow
      p, role:raja_role, applications, action/apps/Deployment/restart, */*, allow
      g, raja, role:raja_role
EOF


}