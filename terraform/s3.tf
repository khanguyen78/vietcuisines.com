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
    protocol = "https"
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
