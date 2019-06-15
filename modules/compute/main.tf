variable "region" {}
variable "instance_type" {}
variable "vpc_subnet_id" {}
variable "ami" {}
variable "key_name" {}
variable "vpc_security_group_ids" {}
variable "associate_public_ip_address" {
  default = false
}
variable "count" {
  default = 1
}
variable "name" {
  default = ""
}
provider "aws" {
  region     = "${var.region}"
}



resource "aws_instance" "web" {
  count = "${var.count}"
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.vpc_subnet_id}"
  key_name      = "${var.key_name}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  tags = {
    Name = "${var.name}"
  }
}