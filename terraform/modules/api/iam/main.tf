
resource "aws_iam_role" "lambda-role" {
  name = "lambda-role"
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

data "aws_iam_policy_document" "lambda-role-policy-document" {
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

resource "aws_iam_policy" "lambda-role-policy" {
  name = "lambda-role-policy"
  path = "/"
  policy = "${data.aws_iam_policy_document.lambda-role-policy-document.json}"
}

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  role = "${aws_iam_role.lambda-role.name}"
  policy_arn = "${aws_iam_policy.lambda-role-policy.arn}"
}
