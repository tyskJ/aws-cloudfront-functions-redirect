# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ CloudFront S3 websitehosting redirect Stack - Terraform variable.tf variable                                                                     ║
# ╠══════════════════════════════════╤═══════════════════════════════════╤═══════════════════════════════════════════════════════════════════════════╣
# ║ cloudfront_cert_arn              │ string                            │ CloudFront Certificate ARN.                                               ║
# ║ website_endpoint                 │ string                            │ S3 Static WebSite Endpoint Name.                                          ║
# ║ cloudfront_hostzone_id           │ string                            │ Hostzone id.                                                              ║
# ║ cloudfront_fqdn                  │ string                            │ CloudFront FQDN.                                                          ║
# ╚══════════════════════════════════╧═══════════════════════════════════╧═══════════════════════════════════════════════════════════════════════════╝

variable "cloudfront_cert_arn" {
  type        = string
  description = "CloudFront Certificate ARN."
}

variable "website_endpoint" {
  type        = string
  description = "S3 Static WebSite Endpoint Name."
}

variable "cloudfront_hostzone_id" {
  type        = string
  description = "Hostzone id."
}

variable "cloudfront_fqdn" {
  type        = string
  description = "CloudFront FQDN."
}
