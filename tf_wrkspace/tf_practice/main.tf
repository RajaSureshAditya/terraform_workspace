locals {
  ips = ["1.1.1.1","2.2.2.3","172.16.0.1"]
  filename = "test_output.json"
}

variable "myfile" {
    default = "test_output.json"
}

variable  "ips" {
    type = "list"
    default = ["127.0.0.1","1.2.1.2","192.168.0.1","172.16.0.1"]
}

resource "local_file" "ip_list" {
  filename = "playbook"
  content = <<-EOT
  [server-type]
  %{ for ip in local.ips }${ip}
  %{ endfor }
  EOT
}

data "local_file" "myfile" {
  filename = "${path.module}/test_output.json"
}


resource "local_file" "nameserverfiles" {
    content = templatefile("${path.module}/my_tmp.tpl", { nameservers = local.ips } )
    filename = local.filename
}


resource "null_resource" "refresh_nameservers"{
    triggers = {
        # myiplist = filemd5(var.myfile)
        myfilecontent = "${local_file.nameserverfiles.content}"
    }
   provisioner "local-exec" {
   command = "echo Aditya"
  }
}



# resource null_resource "get_data" {
#   templatefile("${file("./tpl.json.tpl")}",alist = local.ips)
# }

output "test" {
   value = templatefile("${path.module}/my_tmp.tpl", { nameservers = var.ips } )
 }

# resource "local_file" "ansible_hosts" {
#   content = templatefile( "templates/gen_hosts.tpl", {
#     master_ips = var.map_master_ips
#     worker_ips = var.worker_ips
#     prefix     = var.vm_name_prefix
#     user       = var.vm_user
#   })
#   filename = "config/hosts.ini"
# }

# data "template_file" "test_wrapper" {
#   template = <<JSON
# [
#   $${list_of_dicts}
# ]
# JSON
#   vars = {
#     list_of_dicts = "${join(",\n", data.template_file.test.*.rendered)}"
#   }
# }



# resource "null_resource" "test"{
#     triggers = {
#         myiplist_count = length(local.ips)
#     }
#    provisioner "local-exec" {
#    command = "cat > ./test_output.json <<EOL\ndata.template_file.test_wrapper.rendered\nEOL"
#    on_failure = "continue"
#   }
# }