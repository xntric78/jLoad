provider "aws" {
  region = "${var.aws_region}"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"

  name = "jmeter-vpc"

  cidr           = "10.0.0.0/16"
  public_subnets = ["${slice(var.pub_sub_nets, 0, var.jmeter_num_instances > length(var.pub_sub_nets) ? length(var.pub_sub_nets) : var.jmeter_num_instances)}"]

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  enable_nat_gateway = "false"

  azs = "${data.aws_availability_zones.available.names}"

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

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${file("${var.jmeter_keypair_pub}")}"
}

resource "aws_instance" "jmeter-master-instance" {
  ami           = "${data.aws_ami.jmeter_ami.id}"
  instance_type = "${var.jmeter_instance_type}"

  key_name             = "${aws_key_pair.deployer.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.jmeter_master_iam_profile.name}"

  associate_public_ip_address = "true"

  count = "${var.jmeter_num_instances}"

  subnet_id = "${element(module.vpc.public_subnets, count.index)}"

  security_groups = ["${module.vpc.default_security_group_id}"]

  user_data = "${element(data.template_file.userdata.*.rendered, count.index)}"

  tags {
    Name      = "jmeter-master"
    HostID    = "${count.index}"
    HostCount = "${var.jmeter_num_instances}"
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
        "Service": "ec2.amazonaws.com",
        "Service": "ssm.amazonaws.com"
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

data "template_file" "userdata" {
  count = "${var.jmeter_num_instances}"

  template = "${file("user_data.sh")}"

  vars {
    HostID    = "${count.index}"
    HostCount = "${var.jmeter_num_instances}"
    Client    = "${var.client_name}"
    TestName  = "${var.test_name}"
    awsRegion = "${var.aws_region}"
  }
}

resource "aws_iam_role_policy" "jmeter_master_s3_policy" {
  name = "jmeter_master_s3_policy"
  role = "${aws_iam_role.jmeter_master_iam_role.id}"

  policy = "${data.template_file.jload_iam_policy.rendered}"
}
