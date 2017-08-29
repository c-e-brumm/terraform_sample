variable "region" {}
variable "cidr_block_main" {}
variable "cidr_block_priv_a" {}
variable "cidr_block_priv_b" {}
variable "cidr_block_pub_a" {}
variable "cidr_block_pub_b" {}

provider "aws" {
  region     = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block_main}"
  tags {
    Name = "main"
  }
}

resource "aws_internet_gateway" "main" {
	vpc_id = "${aws_vpc.main.id}"
}

resource "aws_subnet" "private_usw2a"{
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "us-west-2a"
  cidr_block = "${var.cidr_block_priv_a}"
}

resource "aws_subnet" "private_usw2b"{
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "us-west-2b"
  cidr_block = "${var.cidr_block_priv_b}"
}

resource "aws_route_table" "us-west-2-private" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_route_table_association" "us-west-2a-private" {
  subnet_id = "${aws_subnet.private_usw2a.id}"
  route_table_id = "${aws_route_table.us-west-2-private.id}"
}

resource "aws_route_table_association" "us-west-2b-private" {
  subnet_id = "${aws_subnet.private_usw2b.id}"
  route_table_id = "${aws_route_table.us-west-2-private.id}"
}
