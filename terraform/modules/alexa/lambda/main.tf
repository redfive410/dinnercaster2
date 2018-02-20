resource "aws_iam_role" "lambda-dinnercaster2-alexa-role" {
  name = "lambda-dinnercaster2-alexa-role"
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

data "aws_iam_policy_document" "lambda-dinnercaster2-alexa-role-policy-document" {
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:us-west-2:109613526816:function:dinnercaster2-*"
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

resource "aws_iam_policy" "lambda-dinnercaster2-alexa-role-policy" {
  name = "lambda-dinnercaster2-alexa-role-policy"
  path = "/"
  policy = "${data.aws_iam_policy_document.lambda-dinnercaster2-alexa-role-policy-document.json}"
}

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  role = "${aws_iam_role.lambda-dinnercaster2-alexa-role.name}"
  policy_arn = "${aws_iam_policy.lambda-dinnercaster2-alexa-role-policy.arn}"
}

data "archive_file" "dinnercaster2-alexa-zip" {
  type        = "zip"
  source_file = "modules/alexa/lambda/dinnercaster2-alexa/lambda_function.py"
  output_path = "modules/alexa/lambda/dinnercaster2-alexa.zip"
}

resource "aws_lambda_function" "lambda-dinnercaster2-alexa" {
    filename = "${data.archive_file.dinnercaster2-alexa-zip.output_path}"
    function_name = "dinnercaster2-alexa"
    role = "${aws_iam_role.lambda-dinnercaster2-alexa-role.arn}"
    handler = "lambda_function.lambda_handler"
    runtime = "python2.7"
    timeout = 10
    source_code_hash = "${data.archive_file.dinnercaster2-alexa-zip.output_base64sha256}"
}

resource "aws_lambda_permission" "with_alexa" {
  statement_id  = "AllowExecutionFromAlexa"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda-dinnercaster2-alexa.function_name}"
  principal     = "alexa-appkit.amazon.com"
}
