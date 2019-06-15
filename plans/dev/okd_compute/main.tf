terraform {
  backend "s3" {
    bucket = "tsample"
    key    = "dev/okd_compute"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "tsample"
    key    = "dev/vpc"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config {
    bucket = "tsample"
    key    = "dev/bastion"
    region = "us-west-2"
  }
}


resource "aws_security_group" "okd" {
  name = "okd"
  description = "Allow SSH traffic from the bastion only"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${data.terraform_remote_state.bastion.aws_security_group.id}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 8000
    to_port = 9000
    protocol = "tcp"
    self = true
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

module "compute_a_side" {
  source = "../../../modules/compute"
  region = "us-west-2"
  instance_type = "t2.small"
  vpc_subnet_id = "${data.terraform_remote_state.vpc.private_usw2a.id}"
  ami = "ami-036affea69a1101c9"
  vpc_security_group_ids = "${aws_security_group.okd.id}"
  key_name = "april"
  count = 2
  name = "OKD Minion a side"
}

module "compute_b_side" {
  source = "../../../modules/compute"
  region = "us-west-2"
  instance_type = "t2.small"
  vpc_subnet_id = "${data.terraform_remote_state.vpc.private_usw2b.id}"
  ami = "ami-036affea69a1101c9"
  vpc_security_group_ids = "${aws_security_group.okd.id}"
  key_name = "april"
  count = 2
  name = "OKD Minion b side"
}

module "master" {
  source = "../../../modules/compute"
  region = "us-west-2"
  instance_type = "t2.small"
  vpc_subnet_id = "${data.terraform_remote_state.vpc.private_usw2b.id}"
  ami = "ami-036affea69a1101c9"
  vpc_security_group_ids = "${aws_security_group.okd.id}"
  key_name = "april"
  count = 1
  name = "OKD Master"
}