provider "aws" {
  region = "ap-southeast-1"
}

module "antivirus" {
  source = "./terraform-aws-bucket-antivirus/"

  # List of Buckets to scan.
  buckets-to-scan = var.buckets-to-scan

  scanner-environment-variables = {
    # This is Toggle, only vise-versa will work.
    AV_DELETE_INFECTED_FILES = "False"
    AV_MOVE_INFECTED_FILES   = "True"

    # Leave Beloe Values as it is.
    DESTINATION_BUCKET_NAME        = "secops-clamav-infected-objects-${format("%.10s", sha1(var.project_name))}"
    AV_STATUS_SNS_PUBLISH_INFECTED = module.infected-object-found-topic.arn
    AV_BUCKETS_TO_SCAN             = join(",", var.buckets-to-scan)
    AV_SCANNER_LAMBDA              = "bucket-antivirus-scanner"
  }

  allow-public-access = false
}

module "infected-object-found-topic" {
  source          = "./terraform-aws-bucket-antivirus/modules/tf-sns-email-list"
  display_name    = "SecOps S3 Infected Object Found"
  email_addresses = var.sns-notification-emails
  stack_name      = "secops-clamav-infected-objects-sns"
}

module "secops-clamav-definations-topic" {
  source          = "./terraform-aws-bucket-antivirus/modules/tf-sns-email-list"
  display_name    = "SecOps ClamAV definations failed"
  email_addresses = var.sns-notification-emails
  stack_name      = "secops-clamav-definations-sns"
}

resource "aws_sns_topic_policy" "infected-object-creation-sns-policy" {
  arn = module.infected-object-found-topic.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:s3:::${module.antivirus.destination_bucket_name}",
      ]
    }

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [
      module.infected-object-found-topic.arn,
    ]
  }
}

resource "aws_s3_bucket_notification" "infected-bucket-notification" {
  bucket = module.antivirus.destination_bucket_name

  topic {
    topic_arn = module.infected-object-found-topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

locals {
  metric_transformation_name      = "ErrorCount"
  metric_transformation_namespace = "MyAppNamespace"
}

module "log_metric_filter" {
  source = "./terraform-aws-bucket-antivirus/modules/log-metric-filter"

  log_group_name = "/aws/lambda/${module.antivirus.update-function-name}"

  name    = "metric-${module.antivirus.random_id}"
  pattern = "ERROR"

  metric_transformation_namespace = local.metric_transformation_namespace
  metric_transformation_name      = local.metric_transformation_name
}

module "alarm" {
  source = "./terraform-aws-bucket-antivirus/modules/metric-alarm"

  alarm_name          = "log-errors-${module.antivirus.random_id}"
  alarm_description   = "Log errors are too high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 10
  period              = 60
  unit                = "Count"

  namespace   = local.metric_transformation_namespace
  metric_name = local.metric_transformation_name
  statistic   = "Sum"

  alarm_actions = [module.secops-clamav-definations-topic.arn]
}