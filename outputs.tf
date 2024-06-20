output "s3_bucket_name" {
  description = "Name of S3 Bucket"
  value       = aws_s3_bucket.this.name
}

output "bucket_details" {
  description = "S3 Bucket Details"
  value = {
    arn     = aws_s3_bucket.this.arn,
    region  = aws_s3_bucket.this.region,
    id      = aws_s3_bucket.this.id
  }
}