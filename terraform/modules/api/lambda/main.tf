resource "aws_iam_role" "lambda-dinnercaster2-api-role" {
  name = "lambda-dinnercaster2-api-role"
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

data "aws_iam_policy_document" "lambda-dinnercaster2-api-role-policy-document" {
  statement {
    actions = [
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem"
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

resource "aws_iam_policy" "lambda-dinnercaster2-api-role-policy" {
  name = "lambda-dinnercaster2-api-role-policy"
  path = "/"
  policy = "${data.aws_iam_policy_document.lambda-dinnercaster2-api-role-policy-document.json}"
}

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  role = "${aws_iam_role.lambda-dinnercaster2-api-role.name}"
  policy_arn = "${aws_iam_policy.lambda-dinnercaster2-api-role-policy.arn}"
}

data "archive_file" "dinnercaster2-init-dynamodb-zip" {
  type        = "zip"
  source_file = "modules/api/lambda/dinnercaster2-init-dynamodb/lambda_function.py"
  output_path = "modules/api/lambda/dinnercaster2-init-dynamodb.zip"
}

data "archive_file" "dinnercaster2-get-dinnerlist-zip" {
  type        = "zip"
  source_file = "modules/api/lambda/dinnercaster2-get-dinnerlist/lambda_function.py"
  output_path = "modules/api/lambda/dinnercaster2-get-dinnerlist.zip"
}

data "archive_file" "dinnercaster2-get-dinner-zip" {
  type        = "zip"
  source_file = "modules/api/lambda/dinnercaster2-get-dinner/lambda_function.py"
  output_path = "modules/api/lambda/dinnercaster2-get-dinner.zip"
}

resource "aws_lambda_function" "lambda-dinnercaster2-init-dynamodb" {
    filename = "${data.archive_file.dinnercaster2-init-dynamodb-zip.output_path}"
    function_name = "dinnercaster2-init-dynamodb"
    role = "${aws_iam_role.lambda-dinnercaster2-api-role.arn}"
    handler = "lambda_function.lambda_handler"
    runtime = "python2.7"
    timeout = 10
    source_code_hash = "${data.archive_file.dinnercaster2-init-dynamodb-zip.output_base64sha256}"
}

resource "aws_lambda_function" "lambda-dinnercaster2-get-dinnerlist" {
    filename = "${data.archive_file.dinnercaster2-get-dinnerlist-zip.output_path}"
    function_name = "dinnercaster2-get-dinnerlist"
    role = "${aws_iam_role.lambda-dinnercaster2-api-role.arn}"
    handler = "lambda_function.lambda_handler"
    runtime = "python2.7"
    timeout = 10
    source_code_hash = "${data.archive_file.dinnercaster2-get-dinnerlist-zip.output_base64sha256}"
}

resource "aws_lambda_function" "lambda-dinnercaster2-get-dinner" {
    filename = "${data.archive_file.dinnercaster2-get-dinner-zip.output_path}"
    function_name = "dinnercaster2-get-dinner"
    role = "${aws_iam_role.lambda-dinnercaster2-api-role.arn}"
    handler = "lambda_function.lambda_handler"
    runtime = "python2.7"
    timeout = 10
    source_code_hash = "${data.archive_file.dinnercaster2-get-dinner-zip.output_base64sha256}"
}

resource "aws_cloudwatch_event_rule" "init-dynamodb" {
  name        = "init-dynamodb"
  description = "init-dynamodb"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "cron" {
  rule      = "${aws_cloudwatch_event_rule.init-dynamodb.name}"
  target_id = "Cron"
  arn       = "${aws_lambda_function.lambda-dinnercaster2-init-dynamodb.arn}"
}

resource "aws_lambda_permission" "allow-cloudwatch-to-call-lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda-dinnercaster2-init-dynamodb.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.init-dynamodb.arn}"
}
