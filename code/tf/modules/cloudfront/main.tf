# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ CloudFront S3 websitehosting redirect Stack - Terraform main.tf resource                                                                         ║
# ╠════════════════════════════════════╤═════════════════════════════════════════════════════╤═══════════════════════════════════════════════════════╣
# ║ distribution                       │ aws_cloudfront_distribution                         │ CloudFront Distribution.                              ║
# ║ cloudfront_recordset               │ aws_route53_record                                  │ CloudFront Alias Record Set.                          ║
# ╚════════════════════════════════════╧═════════════════════════════════════════════════════╧═══════════════════════════════════════════════════════╝

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  wait_for_deployment = true
  default_root_object = "index.html"
  origin {
    origin_id   = "S3CustomOrigin"
    domain_name = var.website_endpoint
    custom_origin_config {
      http_port              = 80
      origin_protocol_policy = "http-only"
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1"]
    }
  }
  default_cache_behavior {
    target_origin_id       = "S3CustomOrigin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/error.html"
  }
  aliases = [var.cloudfront_fqdn]
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.cloudfront_cert_arn
    ssl_support_method             = "sni-only"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_route53_record" "cloudfront_recordset" {
  zone_id = var.cloudfront_hostzone_id
  name    = var.cloudfront_fqdn
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
