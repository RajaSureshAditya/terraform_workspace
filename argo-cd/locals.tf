locals {
app_names = ["carbon","restws"]
    app_additional_yaml_config = <<EOF
operator:
  clusterDomain: ""
  image:
    pullPolicy: IfNotPresent

server:
  rbacConfig:
    policy.csv: |
      p, role:raja_role, applications, get, */*, allow
      p, role:raja_role, applications, sync, */*, allow
      p, role:raja_role, applications, action/apps/Deployment/restart, */*, allow
      g, raja, role:raja_role
configs:
    cm:
        admin.enabled: true
    secret:
        argocdServerAdminPassword: $2a$12$1UH/UNZ5ofJcHXylEUGgmuIbY7.pa6/BvLEt2xBVRIQX3dj.IDS66
notifications:
  enabled: true
  secret:
    create: true
  cm:
    create: true
      
  notifiers: 
${join("\n\n", [
  for app in local.app_names :
  <<-EOF2
    service.webhook.${app}: |
      url: "http://jenkins.jenkins:8080/job/test/buildWithParameters?token=gen-token&ImageName=${upper(app)}"
      basicAuth:
        username: admin
        password: 11514a57c0ef43e2f9abf1ff2914d5c57a
  EOF2
])}
#  subscriptions:
#    - recipients:
#        - webhook:jenkins
#      selector: app=helm-guestbook
#      triggers:
#        - on-sync-succeeded
  templates:
    template.on-sync-succeeded: |
      webhook:
        jenkins:
          method: POST
          body: |
            {
              "ImageName": "Raja"
            }
  triggers:
    trigger.on-sync-succeeded: |
      - when: app.status.operationState.phase in ['Succeeded'] and app.status.health.status == 'Healthy'
        send: [on-sync-succeeded]
EOF
argocd_app_config = <<EOF1
applications:
  - name: "helm-guestbook"
    namespace: "argo-cd"
    project: "default"
    source:
      helm:
        valueFiles:
          - values.yaml
      repoURL: "https://github.com/argoproj/argocd-example-apps.git"
      targetRevision: "HEAD"
      path: "helm-guestbook"
    destination:
      server: "https://kubernetes.default.svc"
      namespace: "default"
EOF1

}