resource "aws_lambda_function" "complete-s3-scan" {
  function_name = "bucket-complete-s3-scan"
  timeout       = 900
  memory_size   = 1024
  runtime       = "python3.7"
  # filename =    "../terraform-aws-bucket-antivirus/lambda-code/build/lambda.zip"
  handler       = "scan_bucket.lambda_handler"
  role          = aws_iam_role.complete-s3-scanner-role.arn

  s3_bucket = aws_s3_bucket.antivirus-code.bucket
  s3_key    = aws_s3_bucket_object.antivirus-code.key

  environment {
    variables = merge(
      {
        AV_DEFINITION_S3_BUCKET = aws_s3_bucket.antivirus-definitions.bucket
      },
      var.scanner-environment-variables
    )
  }
}

resource "aws_lambda_permission" "trigger-by-s3-complete-s3-scan" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.complete-s3-scan.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.antivirus-definitions.arn
}

resource "aws_s3_bucket_notification" "complete-s3-scan-notification" {
  bucket = aws_s3_bucket.antivirus-definitions.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.complete-s3-scan.arn
    events              = ["s3:ObjectCreated:*"]
  }
}