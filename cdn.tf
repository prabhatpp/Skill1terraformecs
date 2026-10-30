resource "aws_s3_bucket" "static_assets" {
  bucket        = var.s3_static_bucket_name
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-static-assets"
  })
}

resource "aws_cloudfront_origin_access_identity" "static_assets" {
  comment = "OAI for ${var.project_name} static assets"
}

resource "aws_s3_bucket" "logs" {
  bucket        = var.s3_logs_bucket_name
  force_destroy = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-cloudfront-logs"
  })
}

resource "aws_s3_bucket_policy" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowCloudFrontReadOnly"
      Effect = "Allow"
      Principal = {
        AWS = aws_cloudfront_origin_access_identity.static_assets.iam_arn
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.static_assets.arn}/*"
    }]
  })
}

resource "aws_wafv2_web_acl" "cloudfront" {
  name        = var.waf_acl_name
  description = "WAF for CloudFront distribution"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.waf_metric_name
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_acm_certificate" "app" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = [var.domain_name]

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

resource "aws_route53_record" "cert_validation" {
  count = var.route53_zone_id == "" ? 0 : 1

  zone_id = var.route53_zone_id
  name    = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "app" {
  count                   = var.route53_zone_id == "" ? 0 : 1
  certificate_arn         = aws_acm_certificate.app.arn
  validation_record_fqdns = [aws_route53_record.cert_validation[0].fqdn]
}

resource "aws_cloudfront_distribution" "app" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  aliases             = [var.domain_name]

  origin {
    domain_name = aws_s3_bucket.static_assets.bucket_regional_domain_name
    origin_id   = "static-assets-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_assets.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "static-assets-origin"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/static/*"
    target_origin_id = "static-assets-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  logging_config {
    bucket = aws_s3_bucket.logs.bucket_domain_name
    prefix = "cloudfront/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn     = aws_acm_certificate.app.arn
    ssl_support_method     = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-cdn"
  })

  depends_on = [aws_acm_certificate_validation.app]
}

resource "aws_wafv2_web_acl_association" "cloudfront" {
  resource_arn = aws_cloudfront_distribution.app.arn
  web_acl_arn  = aws_wafv2_web_acl.cloudfront.arn
}
