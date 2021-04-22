resource "aws_iam_policy" "antivirus-update-policy" {
  name_prefix = "BucketAntivirusUpdate"
  path        = "/"
  description = "Allows antivirus lambda function to update its definitions"

  policy = templatefile(
    "${path.module}/policies/bucket-antivirus-update.json.tmpl",
    { bucket-name = aws_s3_bucket.antivirus-definitions.bucket }
  )
}

resource "aws_iam_role" "antivirus-update-role" {
  name_prefix        = "bucket-antivirus-update"
  assume_role_policy = file("${path.module}/policies/lambda-assume-role.json")
}

resource "aws_iam_role_policy_attachment" "antivirus-update-policy" {
  policy_arn = aws_iam_policy.antivirus-update-policy.arn
  role       = aws_iam_role.antivirus-update-role.name
}
