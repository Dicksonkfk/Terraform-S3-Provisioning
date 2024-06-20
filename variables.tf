variable "aws_region" {
  description = "AWS region to deploy the resource"
  type        = string
  default     = "us-west2"
}

variable "s3_bucket_name" {
  description = "Default name of S3 Bucket"
  type        = string
  default     = "Terraform-project-bucket"
}
