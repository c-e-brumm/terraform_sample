terraform {
  backend "s3" {
    bucket = "tsample"
    key    = "dev/bastion"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "tsample"
    key    = "dev/vpc"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "Allow SSH traffic from the internet"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["172.90.81.207/32"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

module "compute" {
  source = "../../../modules/compute"
  region = "us-west-2"
  instance_type = "t2.micro"
  vpc_subnet_id = "${data.terraform_remote_state.vpc.public_usw2a.id}"
  ami = "ami-005bdb005fb00e791"
  vpc_security_group_ids = "${aws_security_group.bastion.id}"
  associate_public_ip_address = true
  key_name = "april" 
}





