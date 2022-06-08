# resource "null_resource" "wait_for_service_deploy" {
#   triggers  = {
#     # task_definition = "${aws_ecs_service.service.task_definition}"
#     static_trigger = "foo"
#   }

#   provisioner "local-exec" {
#     command = "echo foo"
#   }
# }