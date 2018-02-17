resource "aws_iam_role" "api-lambda-role" {
  name = "api-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "api-lambda-role-policy-document" {
  statement {
    actions = [
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "api-lambda-role-policy" {
  name = "api-lambda-role-policy"
  path = "/"
  policy = "${data.aws_iam_policy_document.api-lambda-role-policy-document.json}"
}

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  role = "${aws_iam_role.api-lambda-role.name}"
  policy_arn = "${aws_iam_policy.api-lambda-role-policy.arn}"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "modules/api/lambda/dinnercaster2-init-dynamodb/lambda_function.py"
  output_path = "modules/api/lambda/dinnercaster2-init-dynamodb.zip"
}

resource "aws_lambda_function" "dinnercaster2-api-lambda-init-dynamodb" {
    filename = "${data.archive_file.lambda_zip.output_path}"
    function_name = "dinnercaster2-init-dynamodb"
    role = "${aws_iam_role.api-lambda-role.arn}"
    handler = "lambda_function.lambda_handler"
    runtime = "python2.7"
    timeout = 10
    source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
}
