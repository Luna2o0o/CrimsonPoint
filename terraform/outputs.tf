output "public_ip" {
  value = aws_instance.crimson_vm.public_ip
}

output "s3_bucket" {
  value = aws_s3_bucket.crimson_logs.bucket
}
