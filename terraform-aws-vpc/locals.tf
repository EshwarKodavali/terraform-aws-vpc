locals {
  common_tags ={
    Project=var.project
    Environmet=var.environmet
    Terraform = true
  }
 common_name_suffix = "${var.project}-${var.environmet}"
  az_names = slice(data.aws_availability_zones.available.names, 0, 2 )
}