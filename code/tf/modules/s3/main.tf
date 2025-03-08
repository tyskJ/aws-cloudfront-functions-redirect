# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ CloudFront Functions redirect Stack - Terraform main.tf resource                                                                                 ║
# ╠════════════════════════════════════╤═════════════════════════════════════════════════════╤═══════════════════════════════════════════════════════╣
# ║ bucket                             │ aws_s3_bucket                                       │ S3 Bucket.                                            ║
# ║ bucket_encrypt                     │ aws_s3_bucket_server_side_encryption_configuration  │ S3 Bucket Encryption configuration.                   ║
# ║ bucket_website                     │ aws_s3_bucket_website_configuration                 │ Enable static web site hosting.                       ║
# ║ bucket_block_public_access         │ aws_s3_bucket_public_access_block                   │ S3 Bucket Block Public Access.                        ║
# ║ object1                            │ aws_s3_object                                       │ Upload file.                                          ║
# ║ object2                            │ aws_s3_object                                       │ Upload file.                                          ║
# ║ bucket_policy                      │ aws_s3_bucket_policy                                │ S3 Bucket Policy.                                     ║
# ╚════════════════════════════════════╧═════════════════════════════════════════════════════╧═══════════════════════════════════════════════════════╝

resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = true

}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encrypt" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_website_configuration" "bucket_website" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  routing_rules = templatefile("${path.module}/json/redirect-rule.json",
    {
      RedirectHost = var.alb_fqdn
    }
  )
}

resource "aws_s3_bucket_public_access_block" "bucket_block_public_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "object1" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "index.html"
  source = "${path.module}/html/index.html"
}

resource "aws_s3_object" "object2" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "error.html"
  source = "${path.module}/html/error.html"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = templatefile("${path.module}/json/bucket-policy.json",
    {
      BucketArn = aws_s3_bucket.bucket.arn
    }
  )
  depends_on = [aws_s3_bucket_public_access_block.bucket_block_public_access]
}
