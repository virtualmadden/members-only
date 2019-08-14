variable "region" {
  default = "us-west-2"
}

variable "members_only" {
  default = "members.virtualmadden.dev"
}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "origin" {
  name         = "${var.members_only}."
  private_zone = false
}

provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket               = "vrtlmdn-terraform-state"
    key                  = "members_only"
    workspace_key_prefix = "members_only"
    region               = "us-west-2"
  }
}
