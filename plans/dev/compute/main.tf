terraform {
  backend "s3" {
    bucket = "tsample"
    key    = "dev/compute"
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


module "compute" {
  source = "../../../modules/compute"
  region = "us-west-2"
  instance_type = "t2.micro"
  vpc_subnet_id = "${data.terraform_remote_state.vpc.private_usw2b.id}"
  ami = "ami-005bdb005fb00e791"
  vpc_security_group_ids = "sg-049e45a2359ba8843"
  key_name = "april"
}


