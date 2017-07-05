provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"

  name = "jmeter-vpc"

  cidr           = "10.0.0.0/16"
  public_subnets = ["10.0.101.0/24"]

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  enable_nat_gateway = "false"

  azs = ["${split(",", var.availability_zones)}"]

  tags {
    "Terraform"   = "true"
    "Environment" = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_all" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${module.vpc.default_security_group_id}"
}

resource "aws_instance" "jmeter-master-instance" {
  ami           = "${var.jmeter_ami}"
  instance_type = "${var.jmeter_instance_type}"

  key_name             = "${var.jmeter_keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.jmeter_master_iam_profile.name}"

  associate_public_ip_address = "true"

  count = "${length(${var.availability_zones})}"

  subnet_id = "${element(module.vpc.public_subnets.*.id, count.index)}"

  security_groups = ["${module.vpc.default_security_group_id}"]

  tags {
    Name      = "jmeter-master"
    HostID    = "${count.index}"
    HostCount = "${length(${var.availability_zones})}"
    Client    = "${var.client_name}"
    TestName  = "${var.test_name}"
  }

  connection {
    user        = "ec2-user"
    private_key = "${file("${var.jmeter_keypair_pem}")}"
  }

  provisioner "file" {
    source      = "../jmx_pkg/"
    destination = "/home/ec2-user"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x bin/*.sh",
      "sudo bin/setup.sh > logs/setup.log",
      "sudo chown -R ec2-user:ec2-user /opt/",
      "ln -s /opt/apache-jmeter-3.2/ /opt/jmeter",
      "echo 'export PATH=$PATH:/opt/jmeter/bin:$HOME/bin' >> ~/.bash_profile",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "ln -s /opt/apache-jmeter-3.2/ /opt/jmeter",
      "echo 'export PATH=$PATH:/opt/jmeter/bin' >> ~/.bash_profile",
    ]
  }
}

resource "aws_iam_instance_profile" "jmeter_master_iam_profile" {
  name = "jmeter_master_iam_profile"
  role = "${aws_iam_role.jmeter_master_iam_role.name}"
}

resource "aws_iam_role" "jmeter_master_iam_role" {
  name = "jmeter_master_iam_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "template_file" "jload_iam_policy" {
  template = "${file("jmeter_ec2_iam_json.tpl")}"

  vars {
    bucket_name = "jload"
  }
}

resource "aws_iam_role_policy" "jmeter_master_s3_policy" {
  name = "jmeter_master_s3_policy"
  role = "${aws_iam_role.jmeter_master_iam_role.id}"

  policy = "${data.template_file.jload_iam_policy.rendered}"
}
