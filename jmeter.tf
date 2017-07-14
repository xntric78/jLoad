variable "aws_region" {
  default = "us-west-1"
}

provider "aws" {
  region = "${var.aws_region}"
}

module "jmeter_engine" {
  source = "./terraform"

  aws_region           = "${var.aws_region}"
  jmeter_num_instances = 2
  jmeter_instance_type = "t2.large"
  bucket_name          = "jload-west"
  source_folder        = "./jmx_pkg"
  client_name          = "siteworx"
  test_name            = "jload-beta"
  environment          = "beta"
  jmeter_keypair_pub   = "/Users/cpieper/.ssh/cpieper.pub"
  jmeter_keypair_pem   = "/Users/cpieper/.ssh/cpieper.pem"
}
