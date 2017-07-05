variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default = "us-east-1b,us-east-1a"
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
