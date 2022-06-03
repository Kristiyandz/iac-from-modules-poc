resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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
  function_name = var.function_name
  filename      = data.archive_file.my_test_lambda_archive.output_path
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "my_test_lambda.handler"

  # Lambda Runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime = "nodejs14.x"
  timeout = "30"
  # memory_size = local.lambda_memory

  # environment {
  #   variables = {
  #     "EXAMPLE_SECRET" = "${var.example_secret}"
  #   }
  # }

  depends_on = [
    data.archive_file.my_test_lambda_archive
  ]
}

# resource "aws_lambda_permission" "lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.lambda.function_name}"
#   principal     = "apigateway.amazonaws.com"

#   # The "/*/*" portion grants access from any method on any resource
#   # within the API Gateway REST API.
#   source_arn = "${aws_api_gateway_rest_api.api_gateway_rest_api.execution_arn}/*/*"
# }
