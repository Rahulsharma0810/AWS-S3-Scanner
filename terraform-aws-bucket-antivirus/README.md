# AWS S3 Bucket Antivirus Scanner

Used to create lambda functions prepared to scan buckets for viruses.
Two functions are created, one namely to scan the uploads, and another that runs periodically to update the antivirus definitions.

The deployed function is based on [bucket-antivirus-function](https://github.com/upsidetravel/bucket-antivirus-function).
All due credits to the original developers, as this project aims only to document the required infrastructure using terraform.

## Pre-requisites

* git
* docker
* run docker commands without sudo
* enough space and permissions to use `/tmp` to compile the lambda code

## Usage

```hcl
module "antivirus" {
  source = "gchamon/bucket-antivirus/aws"

  buckets-to-scan = [
    aws_s3_bucket.test.bucket
  ]

  scanner-environment-variables = {
    AV_DELETE_INFECTED_FILES = "True"
  }
  
  allow-public-access = true
}
```

## Terraform version

Developed using version `0.12.9`. Should work on `0.12.x`

## Examples

[Test file scan and deletion](https://github.com/gchamon/terraform-aws-bucket-antivirus/tree/master/examples/antivirus-with-custom-environment-variables) - Detailed instructions in the example's readme

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| buckets-to-scan | List of bucket names to be scanned by the antivirus | list(string) | - | yes |
| scanner-environment-variables | Custom environment variables for the scanner function | map(string) | {} | no |
| updater-environment-variables | Custom environment variables for the definitions update function | map(string) | {} | no |
| antivirus-lambda-code | Optional argument to provide precompiled zip file containing the lambda code, skipping the built in compilation process | string | null | no |
| allow-public-access | If true, contents of the bucket in which the antivirus definitions are saved will be public. Good for sharing the same definitions across multiple accounts | bool | false | no |
| antivirus-update-rate | Configures the antivirus update rate. Syntax is the same of cloudwatch rate schedule expression for rules | string | "3 hours" | no |

## Output variables

| Name | Description |
|------|-------------|
| definitions-bucket | The bucket created to store de antivirus definitions |
| scanner-function | The created scanner function resource |
| update-function | The created definitions update function resource |
| scanner-function-role | The role used by the scanner function |
| update-function-role | The role used by the definitions update function |
| scanner-function-policy | The policy attached to the scanner function role |
| scanner-function-policy | The policy attached to the definitions update function role |

