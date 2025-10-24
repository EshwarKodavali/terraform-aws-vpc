variable "vpc" {
  type = string
  description = "vpc cidr"
}

variable "project" {
  type = string
}

variable "environmet" {
  type = string
}

variable "vpc_tags" {
  type = map
  default = {}
}

variable "igw_tags" {
  type = map
  default = {}
}

variable "public_subnet_cidr" {
  type = list
}
variable "subnet_public_tags" {
  type = map
  default = {}
}

variable "private_subnet_cidr" {
  type = list
}
variable "subnet_private_tags" {
  type = map
  default = {}
}


variable "database_subnet_cidr" {
  type = list
}
variable "subnet_database_tags" {
  type = map
  default = {}
}

variable "public_route_table_tags" {
  type = map
  default = {}
}

variable "private_route_table_tags" {
  type = map
  default = {}
}

variable "database_route_table_tags" {
  type = map
  default = {}
}

variable "eip_tags" {
  type = map
  default = {}
}

variable "nat_gateway_tags" {
  type = map
  default = {}
}

variable "is_peering_required" {
  type = bool
  default = "true"
}

variable "peering_tags" {
  type = map
  default = {}
}