output "sns_topic_arn" {
  description = "Name of the destination bucket"
  value       = module.infected-object-found-topic.arn
}
