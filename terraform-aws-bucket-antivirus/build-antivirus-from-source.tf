resource "null_resource" "build-antivirus-from-source" {
  count = (
    var.antivirus-lambda-code == null
    ? 1
    : 0
  )

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/build-antivirus-from-source.sh"
  }
}

resource "aws_s3_bucket_object" "antivirus-code" {
  depends_on = [null_resource.build-antivirus-from-source]

  bucket = aws_s3_bucket.antivirus-code.bucket
  key    = "lambda.zip"

  source = (
    var.antivirus-lambda-code == null
    ? "./terraform-aws-bucket-antivirus/lambda-code/build/lambda.zip"
    : pathexpand(var.antivirus-lambda-code)
  )
}
