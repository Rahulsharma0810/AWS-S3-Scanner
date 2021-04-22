resource "aws_iam_policy" "complete-s3-scanner-policy" {
  name_prefix = "Bucketcomplete-s3Scan"
  path        = "/"
  description = "Allows antivirus lambda function to scan buckets"

  policy = templatefile(
    "${path.module}/policies/complete-s3-scan.json.tmpl",
    {
      bucket-names                       = var.buckets-to-scan
      antivirus-definitions-bucket-name  = aws_s3_bucket.antivirus-definitions.bucket
      lambda-scanner                     = aws_lambda_function.antivirus-scanner.arn
    }
  )
}

resource "aws_iam_role" "complete-s3-scanner-role" {
  name_prefix        = "bucket-complete-s3-scanner"
  assume_role_policy = file("${path.module}/policies/lambda-assume-role.json")
}

resource "aws_iam_role_policy_attachment" "complete-s3-scanner-policy" {
  policy_arn = aws_iam_policy.complete-s3-scanner-policy.arn
  role       = aws_iam_role.complete-s3-scanner-role.name
}
