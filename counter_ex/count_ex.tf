resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = "t2.micro"
  key_name      = "getsteamcicd"

  tags = {
    Name  = "Terraform-${count.index + 1}"
    Tag_Name = local.resource_name
  }
}

provider "aws" {
  region = "us-east-1"
}
