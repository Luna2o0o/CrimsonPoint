resource "aws_dynamodb_table" "equipment_usage" {
  name           = "equipment_usage"
  billing_mode   = "PAY_PER_REQUEST"  # on-demand pricing
  hash_key       = "component_id"

  attribute {
    name = "component_id"
    type = "S"
  }

  tags = {
    Name        = "equipment_usage"
    Environment = var.environment
  }
}
