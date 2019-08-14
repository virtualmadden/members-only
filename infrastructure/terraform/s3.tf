resource "aws_s3_bucket" "origin" {
  bucket = "${var.members_only}"
  acl    = "private"
}
