data "archive_file" "my_test_lambda_archive" {
  type        = "zip"
  source_file = "./node/testLambda.ts"
  output_path = "outputs/my_test_lambda_archive.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_role_test_lambda"

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

resource "aws_lambda_function" "my_test_lambda" {
  function_name    = var.function_name
  filename         = data.archive_file.my_test_lambda_archive.output_path
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "my_test_lambda.handler"
  source_code_hash = filebase64sha256(data.archive_file.my_test_lambda_archive.output_path)

  # Lambda Runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime = "nodejs16.x"
  timeout = "30"
  # memory_size = local.lambda_memory

  # environment {
  #   variables = {
  #     "EXAMPLE_SECRET" = "${var.example_secret}"
  #   }
  # }
}
