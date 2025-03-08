# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ CloudFront S3 websitehosting redirect Stack - Terraform output.tf output                                                                         ║
# ╠═════════════════════════════╤════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
# ║ website_endpoint            │ S3 Static WebSite Endpoint Name.                                                                                   ║
# ╚═════════════════════════════╧════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

output "website_endpoint" {
  description = "S3 Static WebSite Endpoint Name."
  value       = aws_s3_bucket_website_configuration.bucket_website.website_endpoint
}
