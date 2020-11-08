variable "resource_name" {
  default = ""
}

variable "ami" {
  default = {
    "us-east-1" = "t2.micro"
    "us-east-2" = "t2.medium"
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "instance_count" {
  default = "2"
}

variable "application_name" {
  default = "vista"
}

variable "environment" {
  default = "Non-prod-getscicd"
}

locals {
  resource_name = var.resource_name != "" ? "${var.resource_name}" : "${var.application_name}-${var.environment}"
}



output "myresource_name" {
  value = "${local.resource_name}"
}

locals {
  foor = [{bar = "baz"}]
}

output "qux" {
  value = "${local.foor[0]["bar"]}"
}

locals {
  fat = [
    {
      bar = "baz"
      qux = "quux"
    },
    {
      quuz = "corge"
      grault = "garply"
    },
  ]
  foibre = {
    bar = ["baz", "qux", "quux"]
    quuz = ["corge", "grault", "garply"]
  }
}

output "waldo" {
  value = "${lookup(local.fat[0], "bar")}"
}

output  "myvals" {
  value = "${element(local.foibre["bar"], 1)}"
}