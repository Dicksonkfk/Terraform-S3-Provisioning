provider "aws" {
  region = var.aws_region
  default_tags{
    tags = {
      name        = "s3-provisioning"
      environment = "dev"
    }
  }
}

resource "aws_s3_bucket" "this" {
  name          = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#resource "aws_s3_bucket_public_access_block" "this" {
#  bucket = aws_s3_bucket.this.id

#  block_public_acls       = false
#  block_public_policy     = false
#  ignore_public_acls      = false
#  restrict_public_buckets = false
#}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this
  ]
  bucket = aws_s3_bucket.this.id

  access_control_policy {
    grant {
      grantee {
        id   = data.aws_authorized_s3_user.s3_owner.id
        type = "CanonicalUser"
      }
      permission = "READ"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    owner {
      id = data.aws_authorized_s3_user.s3_owner.id
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    "Statement" = [
      {
        "Action" = [
          "s3:GetObject",
          "s3:GetObjectVersion",
        ]
        "Effect"    = "Allow"
        "Principal" = "*"
        "Resource" = [
          "${aws_s3_bucket.data.arn}/*",
        ]
        "Sid" = "PublicRead"
      },
    ]
    "Version" = "2012-10-17"
  })
}

data "aws_s3_objects" "this" {
  bucket = aws_s3_bucket.this.bucket
}

data "aws_authorized_s3_user" "s3_owner"{}
