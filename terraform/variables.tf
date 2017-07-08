variable "aws_region" {
  default = "us-east-2"
}

variable "jmeter_num_instances" {}

variable "jmeter_asset_tags" {
  description = "Tags to set on all created resources to enable reporting within AWS"
  type        = "map"

  default = {}
}

variable "jmeter_instance_type" {
  description = "Instance type for jmeter node"
  default     = "t2.medium"
}

variable "jmeter_ami" {
  default = "ami-a4c7edb2"
}

variable "jmeter_keypair" {
  default = "cpieper"
}

variable "jmeter_keypair_pub" {
  default = "/Users/cpieper/.ssh/cpieper.pub"
}

variable "jmeter_keypair_pem" {
  default = "/Users/cpieper/.ssh/cpieper.pem"
}

variable "environment" {
  default = "JMeter Cloud Infrastructure"
}

variable "client_name" {
  default = "development"
}

variable "test_name" {
  default = "working"
}
