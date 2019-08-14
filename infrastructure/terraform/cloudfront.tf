resource "aws_cloudfront_origin_access_identity" "origin" {
  comment = "${var.members_only}"
}


resource "aws_cloudfront_distribution" "origin" {
  aliases = ["${var.members_only}"]
  default_root_object = "index.html"
  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name = "${aws_s3_bucket.origin.bucket_domain_name}"
    origin_id = "S3-${aws_s3_bucket.origin.id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods         = ["GET", "HEAD"]
    cached_methods          = ["GET", "HEAD"]
    target_origin_id        = "S3-${aws_s3_bucket.origin.id}"

    forwarded_values {
      query_string = "false"

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy  = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate_validation.cert.certificate_arn}"
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}
