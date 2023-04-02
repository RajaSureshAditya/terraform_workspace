locals {
#server:
#  rbacConfig:
#    policy.csv: 
#    -  p, role:raja_role, applications, get, */*, allow
#    -  p, role:raja_role, applications, sync, */*, allow
#    -  p, role:raja_role, applications, action/apps/Deployment/restart, */*, allow
#    -  g, raja, role:raja_role
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
    service.webhook.jenkins: >
      url:
      http://jenkins.jenkins:8080/job/test/buildWithParameters?token=gen-token&ImageName=Aditya

      basicAuth:
        username: admin
        password: 11692851e9aa2aebad0d97ffb6c5db71b5
  subscriptions:
    - recipients:
        - webhook:jenkins
      selector: app=helm-guestbook
      triggers:
        - on-sync-succeeded
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
    trigger.on-sync-succeeded: >
      - description: Application is synced and healthy.
      Triggeredonce per commit.
        oncePer: app.status.sync.revision
        send:
        - on-sync-succeeded
        when: app.status.operationState.phase in ['Succeeded'] and app.status.health.status == 'Healthy'

EOF


}