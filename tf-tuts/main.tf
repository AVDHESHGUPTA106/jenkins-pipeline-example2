# resource "aws_instance" "my_vm" {
#   ami           = var.ami //Ubuntu AMI
#   instance_type = var.instance_type

#   tags = {
#     Name = var.name_tag,
#   }
# }

# import {
#   to = aws_s3_bucket.b1
#   id = "avdhesh5-glo-s3-object-terraform"
# }

resource "aws_s3_bucket" "b1" {
  bucket = "avdhesh15-glo-s3-object-terraform"
  #acl = "private" # or can be "public-read"
  # tags = {
  #   Name        = "My bucket"
  #   Environment = "Dev"
  # }
}

# resource "aws_timestreamwrite_database" "anaplan-timestream-db" {
#   database_name = "tsdb-model-db"
# }

# resource "aws_timestreamwrite_table" "timestream-tbl" {
#   database_name = aws_timestreamwrite_database.anaplan-timestream-db.database_name
#   table_name    = "tsdb-model-table"
#   retention_properties {
#     magnetic_store_retention_period_in_days = 1
#     memory_store_retention_period_in_hours  = 1
#   }
# }

data "aws_region" "current" {}

# data "aws_timestreamwrite_database" "timestream_db"{}

