output "definitions-bucket" {
  description = "The bucket created to store de antivirus definitions"
  value       = aws_s3_bucket.antivirus-definitions
}

output "scanner-function" {
  description = "The created scanner function resource"
  value       = aws_lambda_function.antivirus-scanner
}

output "complete-s3-scanner-function" {
  description = "The created scanner function resource"
  value       = aws_lambda_function.complete-s3-scan
}

output "complete-s3-scanner-function-name" {
  description = "The created scanner function resource"
  value       = aws_lambda_function.complete-s3-scan.function_name
}


output "update-function" {
  description = "The created definitions update function resource"
  value       = aws_lambda_function.antivirus-update
}

output "update-function-name" {
  description = "The created definitions update function name"
  value       = aws_lambda_function.antivirus-update.function_name
}

output "scanner-function-name" {
  description = "The created definitions update function name"
  value       = aws_lambda_function.antivirus-scanner.function_name
}

output "random_id" {
  description = "Id"
  value       = random_pet.this.id
}


output "scanner-function-role" {
  description = "The role used by the scanner function"
  value       = aws_iam_role.antivirus-scanner-role
}

output "update-function-role" {
  description = "The role used by the definitions update function"
  value       = aws_iam_role.antivirus-update-role
}

output "scanner-function-policy" {
  description = "The policy attached to the scanner function role"
  value       = aws_iam_policy.antivirus-scanner-policy
}

output "update-function-policy" {
  description = "The policy attached to the definitions update function role"
  value       = aws_iam_policy.antivirus-update-policy
}

output "destination_bucket_name" {
  description = "Name of the destination bucket"
  value       = aws_s3_bucket.infected-object-bucket.bucket
}

output "antivirus-definitions_bucket_name" {
  description = "Name of the destination bucket"
  value       = aws_s3_bucket.antivirus-definitions.bucket
}

# output "lambda_result" {
#   description = "Name of the destination bucket"
#   value       = data.aws_lambda_function.lambda_result.function_name
# }


