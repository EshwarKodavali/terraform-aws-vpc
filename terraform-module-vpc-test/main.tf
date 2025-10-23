module "vpc" {
  source = "../terraform-aws-vpc"

  #VPC
  vpc = var.vpc_cidr
  project = var.project
  environmet = var.env
  vpc_tags = var.vpc_tags

  #PUBLIC_SUBNET
  public_subnet_cidr = var.subnet_cidr_public

  #private_SUBNET
  private_subnet_cidr = var.subnet_cidr_private

  #database_SUBNET
  database_subnet_cidr = var.subnet_cidr_database
}