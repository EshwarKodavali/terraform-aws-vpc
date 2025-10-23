variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "project" {
  default = "roboshop"
}
variable "env" {
    default = "dev"
}
variable "vpc_tags" {
  default = {
    Purpose= "vpc-module-test"
    DontDelete="true"
  }
}

variable "subnet_cidr_public" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "subnet_cidr_private" {
  default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "subnet_cidr_database" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}