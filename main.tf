
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}


resource "aws_s3_bucket" "b" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}



