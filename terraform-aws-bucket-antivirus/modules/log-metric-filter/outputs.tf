output "clamav_definations_cloudwatch_log_metric_filter_id" {
  description = "The name of the metric filter"
  value       = element(concat(aws_cloudwatch_log_metric_filter.clamav-definations-filter.*.id, [""]), 0)
}
