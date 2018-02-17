resource "aws_dynamodb_table" "dinnercaster-dynamodb-table" {
  name           = "dinnercaster2-v0.1"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "dinnername"

  attribute {
    name = "dinnername"
    type = "S"
  }
  ttl {
    attribute_name = "TimeToExist"
    enabled = false
  }

  tags {
    Name        = "dinnercaster2-0"
    Environment = "production"
  }
}
