resource "aws_cloudwatch_event_rule" "periodic" {
  name                = var.name
  description         = var.description
  schedule_expression = var.schedule-expression
}

resource "aws_cloudwatch_event_target" "lambda-target" {
  rule = aws_cloudwatch_event_rule.periodic.name
  arn  = var.lambda-function.arn
  input = (
    var.input != null
    ? jsonencode(var.input)
    : null
  )
}

resource "aws_lambda_permission" "allow-cloudwatch-execution" {
  statement_id_prefix = "allow-cloudwatch-periodic-execution"
  action              = "lambda:InvokeFunction"
  function_name       = var.lambda-function.function_name
  principal           = "events.amazonaws.com"
  source_arn          = aws_cloudwatch_event_rule.periodic.arn
}
