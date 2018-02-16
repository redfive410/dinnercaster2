provider "aws" {
  region     = "${var.aws_region}"
}

module "api_iam" {
  source = "modules/api/iam"
}

module "api_dynamodb" {
  source = "modules/api/dynamodb"
}

module "api_lambda" {
  source = "modules/api/lambda"
}
