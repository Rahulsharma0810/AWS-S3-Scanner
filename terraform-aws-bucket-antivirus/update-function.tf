resource "aws_lambda_function" "antivirus-update" {
  function_name = "bucket-antivirus-update"
  timeout       = 900
  memory_size   = 1024
  runtime       = "python2.7"
  handler       = "update.lambda_handler"
  role          = aws_iam_role.antivirus-update-role.arn

  s3_bucket = aws_s3_bucket.antivirus-code.bucket
  s3_key    = aws_s3_bucket_object.antivirus-code.key

  environment {
    variables = merge(
      {
        AV_DEFINITION_S3_BUCKET = aws_s3_bucket.antivirus-definitions.bucket
      },
      var.updater-environment-variables
    )
  }
}

resource "random_pet" "this" {
  length = 2
}

module "trigger-antivirus-update-periodically" {
  source = "./modules/periodic-lambda-trigger"

  lambda-function     = aws_lambda_function.antivirus-update
  schedule-expression = "rate(${var.antivirus-update-rate})"
  description         = "Update antivirus definitions every ${var.antivirus-update-rate}"
}
