variable "aws_region" {}

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

variable "jmeter_keypair_pub" {}

variable "jmeter_keypair_pem" {}

variable "bucket_name" {}

variable "source_folder" {}

variable "environment" {}

variable "client_name" {}

variable "test_name" {}

variable "pub_sub_nets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24", "10.0.107.0/24"]
}
