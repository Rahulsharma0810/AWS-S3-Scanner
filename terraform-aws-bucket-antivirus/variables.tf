variable "buckets-to-scan" {
  description = "List of bucket names to be scanned by the antivirus"
  type        = list(string)
}

variable "scanner-environment-variables" {
  description = "Custom environment variables for the scanner function"
  type        = map(string)
  default     = {}
}

variable "updater-environment-variables" {
  description = "Custom environment variables for the definitions update function"
  type        = map(string)
  default     = {}
}

variable "antivirus-lambda-code" {
  description = "Optional argument to provide precompiled zip file containing the lambda code, skipping the built in compilation process"
  type        = string
  default     = null
}

variable "allow-public-access" {
  description = "If true, contents of the bucket in which the antivirus definitions are saved will be public. Good for sharing the same definitions across multiple accounts."
  type        = bool
  default     = false
}

variable "antivirus-update-rate" {
  description = "Configures the antivirus update rate. Syntax is the same of cloudwatch rate schedule expression for rules"
  type        = string
  default     = "3 hours"
}
