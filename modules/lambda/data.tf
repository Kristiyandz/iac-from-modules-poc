data "archive_file" "my_test_lambda_archive" {
  type        = "zip"
  source_dir  = "node/my_test_lambda.ts"
  output_path = "outputs/output.zip"
}
