
output "s3_bucket_name" {
  value = aws_s3_bucket.your_s3_bucket.bucket
}

output "lambda_function_arn" {
  value = aws_lambda_function.s3_trigger_example.arn
}

output "lambda_function_role" {
  value = aws_iam_role.lambda_role.name
}

output "lambda_function_policy" {
  value = aws_iam_role_policy_attachment.lambda_s3_policy_attachment.policy_arn
}



output "s3_bucket_notification" {
  value = aws_s3_bucket_notification.bucket_notification.id
} 

output "s3_bucket_notification_lambda" {
  value = aws_s3_bucket_notification.bucket_notification.lambda_function.0.lambda_function_arn
} 

output "lambda_function_name" {
  value = aws_lambda_function.s3_trigger_example.function_name
}


output "cloud_watch_log_group" {
  value = aws_cloudwatch_log_group.s3_trigger_cloudwatch.name
}


output "cloud_watch_arn" {
  description = "Cloudwatch ARN"
  value = aws_cloudwatch_log_group.s3_trigger_cloudwatch.arn
}

