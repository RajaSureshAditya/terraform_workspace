
# variable "cluster_map" {
#     # type = list(object({
#     #     Group = string
#     #     dev-team = list(string)
#     # }))
#     type = any
#     default =[{
#         Group : "Operators",
#         name : ["dev","qa"]
#         },
#         {
#         Group : "dev-team",
#         dev-team : ["qa"]
#         }]
# }

variable "cluster_map" {
  type = map
  default = {
    app = "vista",
    env = "cdl2",
    namespace = "vista"
  }
}

variable "region_ami" {
  type = "map"
  default = {
      eu-central-1   = "ami-0ad303949e19f897a"
      eu-north-1     = "ami-0d76cb8752ad73ab1"
      eu-west-1      = "ami-0f38cdec7da648424"
      eu-west-2      = "ami-0127cb92c2ac61534"
      eu-west-3      = "ami-0083960c1530c641f"
      us-east-1      = "ami-0a01a5636f3c4f21c"
      us-east-2      = "ami-0a02eadc6d8770f83"
      us-west-1      = "ami-0bbeea654a35ef611"
      us-west-2      = "ami-0a1af68029fa293b6"
      sa-east-1      = "ami-059c26b020488b2f7"
  }
}


# resource "local_file" "aws-auth-map" {
#   content = "${templatefile("role_binding.tmpl", {
#     namespace_list = var.cluster_map
#   })}"
#   filename = "aws-auth.yaml"
# }


locals {
  data = "${join(",", formatlist("key: %s, val: %s. ", keys(var.cluster_map), values(var.cluster_map)))}"
}

output "default_tags_rendered" {
 value="${local.data}"
}


# %{ for addr in ip_addrs ~}
# backend ${addr}:${port}
# %{ endfor ~}

# locals {
#     val = templatefile("${path.module}/role_binding.tpl",{ namespace_list = var.cluster_map })
# }

# output "default_tags_rendered" {
#  value="${local.val}"
# }



# resource "null_resource" "myconfig" {
    # val = templatefile("${path.module}/role_binding.tpl", {
    #     namespace_list = var.cluster_map
    # })
#     provisioner "local-exec" {
#         val = templatefile("${path.module}/role_binding.tpl", {
#         namespace_list = var.cluster_map
#     })
#     }
# }
