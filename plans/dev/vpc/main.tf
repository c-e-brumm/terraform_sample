module "vpc" {
  source = "../../../modules/vpc"
  region = "us-west-2"
  cidr_block_main = "10.0.0.0/16"
  cidr_block_priv_a = "10.0.1.0/24"
  cidr_block_priv_b = "10.0.2.0/24"
  cidr_block_pub_a = "10.0.3.0/24"
  cidr_block_pub_b = "10.0.4.0/24"
}

terraform {
  backend "s3" {
    bucket = "tsample"
    key    = "dev/vpc"
    region = "us-west-2"
  }
}
