terraform {
  backend "s3" {
    bucket         = "tfstate-14d62e79"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-lock"
    encrypt        = true
  }
}
