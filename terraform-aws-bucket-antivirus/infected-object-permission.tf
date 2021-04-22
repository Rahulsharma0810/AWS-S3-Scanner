resource "aws_iam_policy" "infected-object-bucket-policy" {
  name_prefix = "BucketInfectedObject"
  path        = "/"
  description = "Allows lambda function to copy objects from one bucket to another"

  policy = templatefile(
    "${path.module}/policies/bucket-antivirus-update.json.tmpl",
    { bucket-name = aws_s3_bucket.infected-object-bucket.bucket }
  )
}

resource "aws_iam_role" "infected-object-bucket-role" {
  name_prefix        = "bucket-infected-object"
  assume_role_policy = file("${path.module}/policies/lambda-assume-role.json")
}

resource "aws_iam_role_policy_attachment" "infected-object-bucket-policy" {
  policy_arn = aws_iam_policy.infected-object-bucket-policy.arn
  role       = aws_iam_role.infected-object-bucket-role.name
}
