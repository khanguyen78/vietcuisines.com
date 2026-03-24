resource "aws_s3_bucket" "bucket" {
  bucket = local.project

  tags = merge(local.common_tags, {
    Name        = local.project
    Environment = local.environment
  })
}

resource "aws_s3_bucket_website_configuration" "configuration" {
  bucket = aws_s3_bucket.bucket.id
  redirect_all_requests_to {
    host_name = local.cname
    protocol  = "https"
  }
}



resource "aws_s3_bucket" "www_bucket" {
  bucket = local.cname

  tags = merge(local.common_tags, {
    Name        = local.cname
    Environment = local.environment
  })
}


output "s3_bucket_name" {
  value       = aws_s3_bucket.www_bucket.id
  description = "S3 bucket name."
}

resource "aws_s3_bucket_public_access_block" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}
