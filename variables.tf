variable "project_name" {
  description = "Name of the client"
  type        = string
  default     = "Sample"
}

variable "scanner-environment-variables" {
  description = "Custom environment variables for the scanner function"
  type        = map(string)
  default     = {}
}

variable "buckets-to-scan" {
  description = "Name of the scan buckets"
  type        = list(string)
  default     = ["Bucket1","Bucket2"]
}

variable "bucket-scanner-environment-variables" {
  description = "Custom environment variables for the scanner function"
  type        = map(string)
  default     = {}
}

variable "sns-notification-emails" {
  description = "Email to be notified"
  type        = list(string)
  default     = ["SecOps@example.com"]
}
