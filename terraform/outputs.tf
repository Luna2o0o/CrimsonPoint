output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.crimson_asg.name
}

output "launch_template_id" {
  description = "The ID of the EC2 launch template"
  value       = aws_launch_template.crimson_template.id
}

output "s3_log_bucket" {
  description = "The name of the S3 bucket for logs"
  value       = aws_s3_bucket.crimson_logs.bucket
}

output "cloudwatch_dashboard_name" {
  description = "The name of the CloudWatch Dashboard"
  value       = aws_cloudwatch_dashboard.crimson_dashboard.dashboard_name
}

output "s3_lifecycle_rule_id" {
  description = "The ID of the lifecycle rule for storage efficiency"
  value       = "log-storage-optimization"
}
