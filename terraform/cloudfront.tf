# See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html

data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.www_bucket.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.www_bucket.id
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
  depends_on = [aws_s3_bucket_public_access_block.www_bucket]

}

locals {
  s3_origin_id = "${local.cname}.s3.us-east-1.amazonaws.com"
  my_domain    = local.cname
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = local.project
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.www_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id

    #connection_attempts = 3
    #connection_timeout = 10
    #domain_name              = "${local.cname}.s3-website-us-east-1.amazonaws.com"
    #origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    #origin_id                = "${local.cname}.s3.us-east-1.amazonaws.com"
    #    custom_origin_config {
    #
    #      http_port = 80
    #      https_port = 443
    #      ip_address_type = "ipv4"
    #      origin_keepalive_timeout = 5
    #      origin_protocol_policy   = "http-only"
    #      origin_read_timeout      = 30 
    #      origin_ssl_protocols     = [
    #        "SSLv3",
    #        "TLSv1",
    #        "TLSv1.1",
    #        "TLSv1.2",
    #      ]
    #    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = local.cname
  default_root_object = "index.html"

  aliases = [local.domain, local.cname]

  default_cache_behavior {
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress         = true
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = merge(local.common_tags, {
    Environment = "production"
    Name        = local.cname
  })

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "cloudfront" {
  for_each = aws_cloudfront_distribution.s3_distribution.aliases
  zone_id  = aws_route53_zone.zone.zone_id
  name     = each.value
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
