output "public_ip" {
  value = aws_instance.crimson_vm.public_ip
}

output "s3_bucket" {
  value = aws_s3_bucket.crimson_logs.bucket
}

output "ec2_public_ip" {
  value = aws_instance.crimson_vm.public_ip
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.equipment_usage.name
}

