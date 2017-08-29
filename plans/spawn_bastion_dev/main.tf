provider "aws" {
   region     = "us-west-2"
}

data "terraform_remote_state" "create_vpc" {
  backend = "local" 
  config {
    path = "../create_dev/terraform.tfstate"
  }
}

resource "aws_instance" "bastion_2b" {
  ami = "ami-6e1a0117"
  availability_zone = "us-west-2b"
  instance_type = "t2.micro"
  subnet_id = "${data.terraform_remote_state.create_vpc.private_usw2b.id}"
}