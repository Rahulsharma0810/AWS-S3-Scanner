resource "aws_lambda_function" "antivirus-scanner" {
  function_name = "bucket-antivirus-scanner"
  timeout       = 900
  memory_size   = 2048
  runtime       = "python3.7"
  handler       = "scan.lambda_handler"
  role          = aws_iam_role.antivirus-scanner-role.arn

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

resource "aws_lambda_permission" "trigger-by-s3" {
  count = length(var.buckets-to-scan)

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.antivirus-scanner.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.buckets-to-scan[count.index]}"
}

resource "aws_s3_bucket_notification" "staging" {
  count  = length(var.buckets-to-scan)
  bucket = var.buckets-to-scan[count.index]

  lambda_function {
    lambda_function_arn = aws_lambda_function.antivirus-scanner.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
