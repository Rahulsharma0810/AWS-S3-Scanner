resource "aws_s3_bucket" "antivirus-definitions" {
  bucket_prefix = "secops-clamav-updates"
  force_destroy = true
}

resource "aws_s3_bucket" "antivirus-code" {
  bucket_prefix = "secops-clamav-lambda"
  force_destroy = true
}

resource "aws_s3_bucket" "infected-object-bucket" {
  # bucket_prefix = "secops-clamav-infected-objects"
  bucket = var.scanner-environment-variables.DESTINATION_BUCKET_NAME
  force_destroy = true
}

resource "aws_s3_bucket_policy" "public-antivirus-definitions" {
  count = (
    var.allow-public-access == true
    ? 1
    : 0
  )

  bucket = aws_s3_bucket.antivirus-definitions.bucket

  policy = templatefile(
    "${path.module}/policies/bucket-antivirus-definitions.json.tmpl",
    { bucket-name = aws_s3_bucket.antivirus-definitions.bucket }
  )
}

resource "aws_s3_bucket_policy" "infected-object-bucket" {
  count = (
    var.allow-public-access == true
    ? 1
    : 0
  )
  bucket = aws_s3_bucket.infected-object-bucket.bucket

  policy = templatefile(
    "${path.module}/policies/infected-object-bucket-policy.json.tmpl",
    { bucket-name = aws_s3_bucket.infected-object-bucket.bucket }
  )
}
